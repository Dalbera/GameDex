//
//  Equatables.swift
//  GameDexTests
//
//  Created by Gabrielle Dalbera on 28/08/2023.
//

import Foundation
@testable import GameDex

extension Platform: Equatable {
    public static func == (lhs: Platform, rhs: Platform) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title
    }
}

extension AddGameError: Equatable {
    public static func == (lhs: AddGameError, rhs: AddGameError) -> Bool {
        lhs.errorTitle == rhs.errorTitle &&
        lhs.imageName == rhs.imageName &&
        lhs.errorDescription == rhs.errorDescription &&
        lhs.errorAction == rhs.errorAction &&
        lhs.buttonTitle == rhs.buttonTitle
    }
}

extension ErrorAction: Equatable {
    public static func == (lhs: GameDex.ErrorAction, rhs: GameDex.ErrorAction) -> Bool {
        switch (lhs, rhs) {
        case (.refresh, .refresh):
            return true
        case (.navigate(style: _), .navigate(style: _)):
            return true
        default:
            return false
        }
    }
}
