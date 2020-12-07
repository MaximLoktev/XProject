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
    
    case firebaseSaveImageError(Error)
    case firebaseSaveProfileError(Error)
    case firebaseDeletePostError(Error)
    
    case fileDataStorageWriteError(Error)
    case firebaseFetchNewFeedError(Error)
    case firebaseFetchMyFeedPostError(Error)
    
    case firebaseParsedObjectsError
    
    case firebaseSaveImagePostError
    case firebaseSaveImagesPostError(Error)
    case firebaseSavePostError(Error)
    
    case createImageLocalError
    case storeImageLocalError(Error)
    case loadImageLocalError(Error)
    case loadImageLocalPathError
    
    case faildExtractOptionalValue
}
