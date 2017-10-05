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
    starWarsProvider!
      .uponReceiving("a request for a character")
      .withRequest(method: .GET,
                   path: "/people/1/",
                   headers: ["Authorization": Matcher.somethingLike("Bearer"),
                             "Accept": "application/json"])
      .willRespondWith(status: 200, headers: ["Content-Type": "application/json"], body: [
        "name": Matcher.somethingLike("Luke Skywalker"),
        "height": "172",
        "mass": "77",
        "hair_color": "blond",
        "skin_color": "fair",
        "eye_color": "blue",
        "birth_year": "19BBY",
        "gender": Matcher.term(matcher: "(male|female|n\\/a)", generate: "n/a"),
        "homeworld": "https://swapi.co/api/planets/1/",
        "films": Matcher.eachLike("https://swapi.co/api/films/2/"),
        "species": Matcher.eachLike("https://swapi.co/api/species/1/", min: 1),
        "vehicles": [
          "https://swapi.co/api/vehicles/14/",
          "https://swapi.co/api/vehicles/30/"
        ],
        "starships": [
          "https://swapi.co/api/starships/12/",
          "https://swapi.co/api/starships/22/"
        ],
        "created": "2014-12-09T13:50:51.644000Z",
        "edited": Matcher.term(matcher: "\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{,6}Z", generate: "2014-12-20T21:17:56.891000Z"),
        "url": Matcher.term(matcher: "^https?:\\/\\/*", generate: "https://swapi.co/api/people/1/")
      ])
    
    // Run the test
    starWarsProvider!.run(timeout: 10) { (testCompleted) -> Void in
      self.starWarsClient!.fetchStarWarsCharacter(id: 1) { (response, statusCode) -> Void in
        XCTAssertEqual(statusCode, 200)
        
        guard let swCharacter = response as? SWCharacter else {
          XCTFail()
          testCompleted()
          return
        }
        XCTAssertEqual(swCharacter.name, "Luke Skywalker")
        XCTAssertEqual(swCharacter.eyeColor, "blue")
        XCTAssertEqual(swCharacter.edited, "2014-12-20T21:17:56.891000Z")
        XCTAssertTrue(swCharacter.films.contains("https://swapi.co/api/films/2/"))
        XCTAssertTrue(swCharacter.species.count == 1)
        
        testCompleted()
      }
    }
  }
  
  func test_API_returnsError() {
    starWarsProvider!
      .uponReceiving("an invalid request")
      .withRequest(method: .GET,
                   path: "/people/0/",
                   headers: ["Authorization": Matcher.somethingLike("Bearer"),
                             "Accept": "application/json"])
      .willRespondWith(status: 404,
                       headers: ["Content-Type": "application/json"],
                       body: ["detail": Matcher.somethingLike("Not Found")])
    
    starWarsProvider!.run(timeout: 10) { (testCompleted) -> Void in
      self.starWarsClient!.fetchStarWarsCharacter(id: 0) { (response, statusCode) -> Void in
        XCTAssertEqual(statusCode, 404)
        XCTAssertNotNil(response)
        XCTAssertFalse(response is SWCharacter)
        
        guard let resp = response as? [String:String] else {
          XCTFail()
          testCompleted()
          return
        }
        
        XCTAssertEqual(resp, ["detail": "Not Found"])
        testCompleted()
      }
    }
  }
  
}
