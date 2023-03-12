//
//  AnyCodable.swift
//  On The Map
//
//  Created by Can Yıldırım on 27.02.2023.
//

import Foundation

enum AnyCodable {
    
    case string(value: String)
    case int(value: Int)
    case double(value: Double)
    
    func toString() -> String? {
        switch self {
        case .string(value: let value):
            return value
        case .int(value: let value):
            return "\(value)"
        case .double(value: let value):
            return String(value)
        }
    }
    
    enum AnyCodableError:Error {
        case missingValue
    }
}

extension AnyCodable: Codable {
    
    enum CodingKeys: String, CodingKey {
        case string, int, double
    }
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(value: int)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(value: string)
            return
        }
        
       
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(value: double)
            return
        }
        
        throw AnyCodableError.missingValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .int(let value):
            try container.encode(value, forKey: .int)

        case .double(let value):
            try container.encode(value, forKey: .double)
        }
    }
}
