//
//  SwapiClient.swift
//  PactMacOSExample
//
//  Created by Marko Justinek on 20/9/17.
//  Copyright © 2017 DiUS. All rights reserved.
//

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
  
  public func fetchStarWarsCharacter(id: Int = 1, completion: @escaping (Any, Int) -> Void) {
    Alamofire.request("\(baseUrl)/people/\(id)/", headers: self.headers)
      .responseJSON { response in
        if let json = response.result.value, let statusCode = response.response?.statusCode {
          completion(json, statusCode)
        }
      }
  }
  
  public func fetchStarWarsSpacecraft(id: Int = 9, completion: @escaping (Any,  Int) -> Void) {
    Alamofire.request("\(baseUrl)/starships/\(id)/", headers: self.headers)
      .responseJSON { response in
        if let json = response.result.value, let statusCode = response.response?.statusCode {
          completion(json, statusCode)
        }
    }
  }
}
