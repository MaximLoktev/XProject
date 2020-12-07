//
//  FirebaseDecodable + Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 15.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase

extension DatabaseQuery {
    func makeSimpleRequest<U: Decodable>(entity: U.Type, completion: @escaping (Result<U, APIError>) -> Void) {
    self.observeSingleEvent(of: .value, with: { snapshot in
        guard let object = snapshot.children.allObjects as? [DataSnapshot] else {
            completion(.failure(.faildExtractOptionalValue))
            return
        }
        let dict = object.compactMap { $0.value as? [String: Any] }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            let parsedObjects = try JSONDecoder().decode(U.self, from: jsonData)
            completion(.success(parsedObjects))
        } catch {
            completion(.failure(.firebaseParsedObjectsError))
        }
    })
  }
}
