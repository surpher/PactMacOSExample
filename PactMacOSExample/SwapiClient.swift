import Foundation
import Alamofire

public class SwapiClient {
  private let baseUrl: String
  
  private let headers = [
    "Accept": "application/json"
  ]
  
  public init(baseUrl: String) {
    self.baseUrl = baseUrl
  }
  
  public func fetchStarWarsCharacter(id: Int = 4, completion: @escaping (Any, Int) -> Void) {
    Alamofire.request("\(baseUrl)/people/\(id)/", headers: self.headers)
      .responseJSON { response in
        
        if let data = response.data, let statusCode = response.response?.statusCode {
          do {
            let decoder = JSONDecoder()
            let swCharacter = try decoder.decode(SWCharacter.self, from: data)
            completion(swCharacter, statusCode)
          } catch let error {
            completion(error, statusCode)
          }
        }
      }
  }
  
}
