import Foundation

struct SWCharacter {
  let name: String
  let height: String
  let mass: String
  let hairColor: String
  let skinColor: String
  let eyeColor: String
  let birthYear: String
  let gender: String
  let homeworld: String
  let films: [String]
  let species: [String]
  let vehicles: [String]?
  let starships: [String]?
  let created: String
  let edited: String
  let url: String
}

extension SWCharacter: Decodable {
  private enum CodingKeys: String, CodingKey {
    case name, height, mass, hairColor = "hair_color", skinColor = "skin_color", eyeColor = "eye_color",
    birthYear = "birth_year", gender, homeworld ,films, species, vehicles, starships, created, edited, url
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let name: String        = try container.decode(String.self, forKey: .name)
    let height: String      = try container.decode(String.self, forKey: .height)
    let mass: String        = try container.decode(String.self, forKey: .mass)
    let hairColor: String   = try container.decode(String.self, forKey: .hairColor)
    let skinColor: String   = try container.decode(String.self, forKey: .skinColor)
    let eyeColor: String    = try container.decode(String.self, forKey: .eyeColor)
    let birthYear: String   = try container.decode(String.self, forKey: .birthYear)
    let gender: String      = try container.decode(String.self, forKey: .gender)
    let homeworld: String   = try container.decode(String.self, forKey: .homeworld)
    let films: [String]     = try container.decode([String].self, forKey: .films)
    let species: [String]   = try container.decode([String].self, forKey: .species)
    let vehicles: [String]  = try container.decode([String].self, forKey: .vehicles)
    let starships: [String] = try container.decode([String].self, forKey: .starships)
    let created: String     = try container.decode(String.self, forKey: .created)
    let edited: String      = try container.decode(String.self, forKey: .edited)
    let url: String         = try container.decode(String.self, forKey: .url)
    
    self.init(name: name, height: height, mass: mass, hairColor: hairColor, skinColor: skinColor, eyeColor: eyeColor,
              birthYear: birthYear, gender: gender, homeworld: homeworld, films: films, species: species, vehicles: vehicles,
              starships: starships, created: created, edited: edited, url: url)
  }
}
