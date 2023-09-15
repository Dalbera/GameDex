//
//  MyCollectionSection.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 13/09/2023.
//

import Foundation

final class MyCollectionSection: Section {
    
    var gamesCollection: [SavedGame]
    
    init(gamesCollection: [SavedGame]) {
        self.gamesCollection = gamesCollection
        super.init()
        self.position = 0
        
        // Create new array of platforms
        var platformsArray = [String]()
        // Get all platforms from fetched collection
        for item in gamesCollection {
            platformsArray.append(item.game.platform)
        }
        
        // Remove duplicates platforms using set
        var uniquePlatforms = Array(Set(platformsArray))
        uniquePlatforms.sort()
        
        // Check all games in collection and add those on the corresponding platform in an array that we will pass to the cell
        for platform in uniquePlatforms {
            var gameArrayByPlatform = [SavedGame]()
            gamesCollection.forEach {
                if $0.game.platform == platform {
                    gameArrayByPlatform.append($0)
                }
            }
            
            let labelCellVM = LabelCellViewModel(
                text: platform,
                screenFactory: MyCollectionByPlatformsScreenFactory(
                    gamesCollection: gameArrayByPlatform
                )
            )
            self.cellsVM.append(labelCellVM)
        }
    }
}