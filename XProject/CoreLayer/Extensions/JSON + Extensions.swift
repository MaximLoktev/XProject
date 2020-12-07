//
//  JSON + Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 11.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

extension JSONEncoder {
    func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type,
                              withJSONObject object: Any,
                              options opt: JSONSerialization.WritingOptions = []) throws -> T {
        
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
