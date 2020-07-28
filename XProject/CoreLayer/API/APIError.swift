//
//  APIError.swift
//  XProject
//
//  Created by Максим Локтев on 05.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal enum APIError: Error {
    case writingDataObjectError(Error)
    case readingCoreDataObjectError(Error)
    
    case createCoreDataObjectError(Error)
    case fetchCoreDataObjectError(Error)
    case deleteCoreDataObjectsError(Error)
    case updateCoreDataObjectError(Error)
    
    case firebase(Error)
    
    case faildExtractOptionalValue
}
