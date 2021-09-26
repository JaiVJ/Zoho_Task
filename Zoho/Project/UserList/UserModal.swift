//
//  File.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation


struct UserModal: Codable {
    let results: [ResultData]?
    let info: Info?

    enum CodingKeys: String, CodingKey {
        case results = "results"
        case info = "info"
    }
}

// MARK: - Info
struct Info: Codable {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?

    enum CodingKeys: String, CodingKey {
        case seed = "seed"
        case results = "results"
        case page = "page"
        case version = "version"
    }
}

// MARK: - Result
struct ResultData: Codable {
    let gender: Gender?
    let name: Name?
    let location: Location?
    let email: String?
    let dob: Dob?
    let registered: Dob?
    let phone: String?
    let cell: String?
    let picture: Picture?

    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case name = "name"
        case location = "location"
        case email = "email"
        case dob = "dob"
        case registered = "registered"
        case phone = "phone"
        case cell = "cell"
        case picture = "picture"
    }
}

// MARK: - Dob
struct Dob: Codable {
    let date: String?
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case age = "age"
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}


// MARK: - Location
struct Location: Codable {
    let street: Street?
    let city: String?
    let state: String?
    let country: String?
    let postcode: Postcode?
    let coordinates: Coordinates?

    enum CodingKeys: String, CodingKey {
        case street = "street"
        case city = "city"
        case state = "state"
        case country = "country"
        case postcode = "postcode"
        case coordinates = "coordinates"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude: String?
    let longitude: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

enum Postcode: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Street
struct Street: Codable {
    let number: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case name = "name"
    }
}

// MARK: - Name
struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case first = "first"
        case last = "last"
    }
}

// MARK: - Picture
struct Picture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case large = "large"
        case medium = "medium"
        case thumbnail = "thumbnail"
    }
}
