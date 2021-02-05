//
//  PactMacOSExampleTests.swift
//  PactMacOSExampleTests
//
//  Created by Marko Justinek on 5/2/21.
//

import XCTest
@testable import PactMacOSExample
import PactConsumerSwift

class PactMacOSExampleTests: XCTestCase {

	var mockService: MockService!
	var apiClient: SWAPIClient!

	override func setUpWithError() throws {
		let verificationService = PactVerificationService(url: "https://127.0.0.1", port: 2345, allowInsecureCertificates: true)
		mockService = MockService(provider: "SWAPI", consumer: "ThisApp", pactVerificationService: verificationService)

		apiClient = SWAPIClient(baseURL: mockService.baseUrl)
	}

	// MARK: - Tests

	func testFetchingStarWarsPerson() {
		mockService
			.given("a character exists")
			.uponReceiving("a request for a character")
			.withRequest(
				method: .GET,
				path: "/people/1",
				headers: [
					"Authorization": Matcher.somethingLike("Bearer"),
					"Accept": "application/json"
				]
			)
			.willRespondWith(
				status: 200 ,
				body: [
					"name": Matcher.somethingLike("Luke Skywalker"),
					"eye_color": "blue",
					"birth_year": "19BBY",
					"films": Matcher.eachLike("https://swapi.co/api/films/2/"),
					"species": Matcher.eachLike("https://swapi.co/api/species/1/", min: 1),
					"edited": Matcher.term(matcher: "\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{,6}Z", generate: "2014-12-20T21:17:56.891000Z")
				]
			)

		mockService.run(timeout: 0.1) { [unowned self] testCompleted in
			apiClient.fetchPerson(id: 1) { result, error in
				do {
					let person = try XCTUnwrap(result)

					XCTAssertEqual(person.name, "Luke Skywalker")
					XCTAssertEqual(person.eyeColor, "blue")
					XCTAssertEqual(person.edited, "2014-12-20T21:17:56.891000Z")
					XCTAssertTrue(person.films.contains("https://swapi.co/api/films/2/"))
					XCTAssertTrue(person.species.count == 1)
				} catch {
					XCTFail("Expected a SWPerson object")
				}

				testCompleted()
			}
		}
	}

	func testFetchingStarWarsPersonWithError() {
		mockService
			.given("a character does not exist")
			.uponReceiving("a request for a character")
			.withRequest(
				method: .GET,
				path: "/people/999999",
				headers: [
					"Authorization": Matcher.somethingLike("Bearer"),
					"Accept": "application/json"
				]
			)
			.willRespondWith(
				status: 404,
				body: [ "404 Error" ]
			)

		mockService.run(timeout: 0.1) { [unowned self] testCompleted in
			apiClient.fetchPerson(id: 999999) { result, error in
				do {
					let error = try XCTUnwrap(error as? SWAPIError)
					guard case .statusCode(let code) = error else {
						XCTFail("Expected a status code error")
						return
					}
					XCTAssertEqual(code, 404)
				} catch {
					XCTFail("Expected a SWAPIError")
				}

				testCompleted()
			}
		}
	}

	func testFetchingStarWarsPlanet() {
		mockService
			.given("a planet exists")
			.uponReceiving("a request for a planet")
			.withRequest(method: .GET, path: "/planets/12")
			.willRespondWith(
				status: 200,
				body: [
					"name": Matcher.somethingLike("Utapau"),
					"rotation_period": "27",
					"orbital_period": "351",
					"diameter": "12900",
					"climate": "temperate, arid, windy",
					"gravity": "1 standard",
					"terrain": "scrublands, savanna, canyons, sinkholes",
					"surface_water": "0.9",
					"residents": Matcher.eachLike(
						Matcher.term(
							matcher: "^(http[s]?:\\/\\/(www\\.)?|ftp:\\/\\/(www\\.)?|www\\.){1}([0-9A-Za-z-\\.@:%_\\+~#=]+)+((\\.[a-zA-Z]{2,3})+)(/(.)*)?(\\?(.)*)?",
							generate: "http://swapi.dev/api/people/83/"
						),
						min: 3
					)
				]
			)

		mockService.run(timeout: 1) { [unowned self] testComplete in
			apiClient.fetchPlanet(id: 12) { planet, error in
				do {
					let planet = try XCTUnwrap(planet)

					XCTAssertEqual(planet.name, "Utapau")
					XCTAssertEqual(planet.orbitalPeriod, "351")
					XCTAssertEqual(planet.residents.count, 3)
				} catch {
					XCTFail("Expected a SWPlanet object")
				}

				testComplete()
			}
		}
	}

	func testFetchingAListOfStarships() {
		mockService
			.given("starships exist")
			.uponReceiving("a request for a list of starships")
			.withRequest(method: .GET, path: "/starships")
			.willRespondWith(
				status: 200,
				body: [
					"count": Matcher.somethingLike(99),
					"results": Matcher.eachLike(
						[
							"name": Matcher.somethingLike("CR90 corvette"),
							"model": Matcher.somethingLike("CR90 corvette"),
							"manufacturer": "Corellian Engineering Corporation",
							"cost_in_credits": "3500000",
							"length": "150",
							"max_atmosphering_speed": Matcher.somethingLike("950"),
							"crew": "30-165",
							"passengers": "600",
							"cargo_capacity": "3000000",
							"films": Matcher.eachLike(
								Matcher.somethingLike("http://swapi.dev/api/films/1/")
							)
						],
						min: 2
					)
				]
			)

		mockService.run { [unowned self] testComlete in
			apiClient.fetchStarships { starships, error in
				do {
					let starships = try XCTUnwrap(starships)

					XCTAssertEqual(starships.count, 99)
					XCTAssertEqual(starships.results.count, 2)

					let starship = try XCTUnwrap(starships.results.first)
					XCTAssertEqual(starship.films.count, 1)
					XCTAssertEqual(starship.maxAtmospheringSpeed, "950")
				} catch {
					XCTFail("Expected a SWStarshipsList object")
				}
				testComlete()
			}
		}
	}

}
