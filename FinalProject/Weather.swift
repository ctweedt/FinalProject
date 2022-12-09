//
//  Weather.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 11/30/22.
//

import Foundation

struct Weather: Codable, Identifiable {
    let id = UUID().uuidString
    var temperature: String
    var wind: String
    var description: String
    
    enum CodeingKeys: CodingKey {
        case id, temperature, wind, description
    }
}
