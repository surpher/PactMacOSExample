//
//  SWAPIClient.swift
//  PactMacOSExample
//
//  Created by Marko Justinek on 5/2/21.
//
//  DISCLAIMER:
//
//  This is not how you write good API clients.
//  This is only to demonstrate the minimal required setup to get Pact tests running.
//

import Foundation
import os.log

class SWAPIClient: NSObject {

	enum Endpoint: String {
		case people
		case planets
		case starships
	}

	let baseURL: String

	private lazy var session = {
		return URLSession(configuration: .ephemeral, delegate: self, delegateQueue: .main)
	}()

	init(baseURL: String) {
		self.baseURL = baseURL
	}

	// MARK: - SWAPIClient

	func fetchPerson(id: Int, completion: @escaping (SWPerson?, Error?) -> Void) {
		session
			.decodable(
				for: .makeRequest(
					url: Endpoint.people.url(baseURL: baseURL, id: id),
					method: .GET,
					body: nil
				)
			) { (result: Result<SWPerson, Error>) in
				switch result {
				case .success(let person):
					completion(person, nil)
				case .failure(let error):
					completion(nil, error)
				}
		}
	}

	func fetchPlanet(id: Int, completion: @escaping (SWPlanet?, Error?) -> Void) {
		session
			.decodable(for: .makeRequest(url: Endpoint.planets.url(baseURL: baseURL, id: id))) { (result: Result<SWPlanet, Error>) in
				switch result {
				case .success(let planet):
					completion(planet, nil)
				case .failure(let error):
					completion(nil, error)
				}
			}
	}

	func fetchStarships(completion: @escaping (SWStarshipsList?, Error?) -> Void) {
		session
			.decodable(for: .makeRequest(url: Endpoint.starships.url(baseURL: baseURL))) { (result: Result<SWStarshipsList, Error>) in
				switch result {
				case .success(let starship): completion(starship, nil)
				case .failure(let error): completion(nil, error)
				}
			}
	}

}

private extension SWAPIClient.Endpoint {

	func url(baseURL: String, id: Int? = nil) -> URL {
		// This API client only handles the following endpoints:
		// - https://swapi.dev/api/people/{id?}
		// - https://swapi.dev/api/planets/{id?}
		// - https://swapi.dev/api/starships/{id?}
		//
		if let id = id {
			return URL(string: "\(baseURL)/\(self.rawValue)/\(id)")!
		} else {
			return URL(string: "\(baseURL)/\(self.rawValue)")!
		}
	}

}

enum SWAPIError: Error {
	case missingData
	case unknown
	case statusCode(Int?)
	case parsingError
}

enum HTTPMethod: String, RawRepresentable {
	case GET
	case POST
	case PATCH
	case PUT
	case DELETE
	// and so on and on
}

extension HTTPMethod: CustomStringConvertible {
	var description: String { rawValue }
}

// MARK: - URLRequest

private extension URLRequest {

	static func makeRequest(url: URL, method: HTTPMethod = .GET, body: Data? = nil) -> URLRequest {
		var request = URLRequest(url: url)
		request.setDefaultHeaders()
		request.httpMethod = method.rawValue
		request.httpBody = body
		return request
	}

	mutating func setDefaultHeaders() {
		Self.defaultHeaders().forEach {
			self.setValue($0.value, forHTTPHeaderField: $0.key)
		}
	}

	static func defaultHeaders() -> [String: String] {
		[
			"Authorization": "Bearer \(UUID().uuidString)",
			"Accept": "application/json"
		]
	}

}

// MARK: - URLSession

private extension URLSession {

	func decodable<D>(for request: URLRequest, completion: @escaping ((Result<D, Error>) -> Void)) where D: Decodable {
		dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
			}

			guard let response = response as? HTTPURLResponse else {
				completion(.failure(SWAPIError.unknown))
				return
			}

			guard (200...299).contains(response.statusCode) else {
				completion(.failure(SWAPIError.statusCode(response.statusCode)))
				return
			}

			guard let data = data else {
				completion(.failure(SWAPIError.missingData))
				return
			}

			do {
				let response = try JSONDecoder().decode(D.self, from: data)
				completion(.success(response))
			} catch {
				completion(.failure(SWAPIError.parsingError))
			}
		}
		.resume()
	}

}

extension SWAPIClient: URLSessionDelegate {

	public func urlSession(
			_ session: URLSession,
			didReceive challenge: URLAuthenticationChallenge,
			completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
		) {
			guard
				challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
				["localhost", "127.0.0.1", "0.0.0.0"].contains(where: challenge.protectionSpace.host.contains),
				let serverTrust = challenge.protectionSpace.serverTrust
				 else {
					completionHandler(.performDefaultHandling, nil)
					return
			}
			let credential = URLCredential(trust: serverTrust)
			completionHandler(.useCredential, credential)
		}

}
