//
//  Model.swift
//  PokedexApp
//
//  Created by 김기태 on 5/13/25.
//

import Foundation

struct PokemonResponse: Decodable {
    let results: [PokemonSummary]
}

struct PokemonSummary: Decodable {
    let name: String
    let url: String
}

struct Details: Decodable {
    let id: Int
    let name: String
    let types: [Types]
    let height: Int
    let weight: Int
}

struct Types: Decodable {
    let type: PokeType
}

struct PokeType: Decodable {
    let name: String
}
