//
//  Matcher+Extension.swift
//  GameDexTests
//
//  Created by Gabrielle Dalbera on 28/08/2023.
//

import Foundation
import SwiftyMocky
@testable import GameDex

extension Matcher {
    enum GetPlatformsEndpoint {
        static func matcher(lhs: GameDex.GetPlatformsEndpoint, rhs: GameDex.GetPlatformsEndpoint) -> Bool {
            lhs.path == rhs.path &&
            lhs.entryParameters?.count == rhs.entryParameters?.count &&
            lhs.method == rhs.method
        }
    }
}