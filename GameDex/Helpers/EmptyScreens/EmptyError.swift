//
//  EmptyError.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 16/08/2023.
//

import Foundation

protocol EmptyError: LocalizedError {
    var errorTitle: String? { get }
    var errorDescription: String? { get }
    var imageName: String? { get }
    var buttonTitle: String? { get }
    var errorAction: ErrorAction? { get }
}

enum ErrorAction {
    case refresh
    case navigate(style: NavigationStyle)
}

extension EmptyError {
    var errorTitle: String? {
        return nil
    }
    
    var errorDescription: String? {
        return nil
    }

    var imageName: String? {
        return nil
    }

    var buttonTitle: String? {
        return nil
    }
    
    var errorAction: ErrorAction? {
        return nil
    }
}
