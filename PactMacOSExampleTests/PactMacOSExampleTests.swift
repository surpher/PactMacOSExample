//
//  PactMacOSExampleTests.swift
//  PactMacOSExampleTests
//
//  Created by Marko Justinek on 20/9/17.
//  Copyright © 2017 DiUS. All rights reserved.
//

import XCTest
import PactConsumerSwift

@testable import PactMacOSExample

class PactMacOSExampleTests: XCTestCase {
  
  var starWarsProvider: MockService?
  var starWarsClient: SwapiClient?
  
  override func setUp() {
    super.setUp()
  
    starWarsProvider = MockService(provider: "Star Wars API", consumer: "Our macOS app")
    starWarsClient = SwapiClient(baseUrl: starWarsProvider!.baseUrl)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_API_returnsCharacter() {
    // Prepare the expecated behaviour
    starWarsProvider!.uponReceiving("a request for a character").withRequest(method: .GET, path: "/people/3/")
        .willRespondWith(status: 200, headers: ["Content-Type": "application/json"], body: [
          "name": "Luke Skywalker",
          "height": "172",
          "mass": "77",
          "hair_color": "blond",
          "skin_color": "fair",
          "eye_color": "blue",
          "birth_year": "19BBY",
          "gender": "male",
          "homeworld": "https://swapi.co/api/planets/1/",
          "films": [
            "https://swapi.co/api/films/2/",
            "https://swapi.co/api/films/6/",
            "https://swapi.co/api/films/3/",
            "https://swapi.co/api/films/1/",
            "https://swapi.co/api/films/7/"
          ],
          "species": ["https://swapi.co/api/species/1/"],
          "vehicles": [
            "https://swapi.co/api/vehicles/14/",
            "https://swapi.co/api/vehicles/30/"
          ],
          "starships": [
            "https://swapi.co/api/starships/12/",
            "https://swapi.co/api/starships/22/"
          ],
          "created": "2014-12-09T13:50:51.644000Z",
          "edited": "2014-12-20T21:17:56.891000Z",
          "url": "https://swapi.co/api/people/1/"
        ])
    
    // Run the test
    starWarsProvider!.run(timeout: 10) { (testCompleted) -> Void in
      self.starWarsClient!.fetchStarWarsCharacter(id: 3) { (response, statusCode) -> Void in
        XCTAssertEqual(statusCode, 200)
        testCompleted()
      }
    }
  }
  
  func test_API_returnsError() {
    starWarsProvider!.uponReceiving("an invalid request").withRequest(method: .GET, path: "/people/0/")
      .willRespondWith(status: 400, headers: ["Content-Type": "application/json"], body: ["error": "bar"])
    
    starWarsProvider!.run(timeout: 10) { (testCompleted) -> Void in
      self.starWarsClient!.fetchStarWarsCharacter(id: 0) { (response, statusCode) -> Void in
        XCTAssertEqual(statusCode, 400)
        testCompleted()
      }
    }
  }
  
}
