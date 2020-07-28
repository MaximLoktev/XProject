//
//  ProfileFirebaseService.swift
//  XProject
//
//  Created by Максим Локтев on 27.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase

protocol ProfileFirebaseService {
    
}

class ProfileFirebaseServiceImpl: ProfileFirebaseService {
    
    private let databaseReference: DatabaseReference
    
    init(databaseReference: DatabaseReference) {
        self.databaseReference = databaseReference
    }
}
