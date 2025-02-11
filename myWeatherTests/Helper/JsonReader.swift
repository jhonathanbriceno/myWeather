//
//  JsonReader.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

import Foundation

struct JsonReader {
    static func mockJsonResponse<T: Decodable>(type: T.Type, fileName: String) throws -> T? {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("jsonReader Error: \(error)")
            throw error
        }
    }
}
