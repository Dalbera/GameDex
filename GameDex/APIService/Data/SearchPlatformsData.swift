//
//  PlatformsData.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 24/08/2023.
//

import Foundation

// MARK: - PlatformsData
struct SearchPlatformsData: Codable {
    let platforms: [RemotePlatform]
}

// MARK: - Platform
struct RemotePlatform: Codable {
    let platformID: Int
    let platformName: String

    enum CodingKeys: String, CodingKey {
        case platformID = "platform_id"
        case platformName = "platform_name"
    }
}