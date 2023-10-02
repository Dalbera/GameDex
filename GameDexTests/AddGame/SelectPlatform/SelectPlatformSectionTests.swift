//
//  SelectPlatformSectionTests.swift
//  GameDexTests
//
//  Created by Gabrielle Dalbera on 28/08/2023.
//

import XCTest
@testable import GameDex

final class SelectPlatformSectionTests: XCTestCase {

    func test_init_GivenSelectPlatformSection_ThenShouldSetPropertiesCorrectly() {
        // Given
        let section = SelectPlatformSection(
            platforms: MockData.platforms,
            gameDetailsDelegate: GameDetailsViewModelDelegateMock()
        )
        
        // Then
        XCTAssertEqual(section.cellsVM.count, 5)
        
        guard let platform1CellVM = section.cellsVM.first as? LabelCellViewModel,
              let platform2CellVM = section.cellsVM[1] as? LabelCellViewModel,
              let platform3CellVM = section.cellsVM[2] as? LabelCellViewModel,
              let platform4CellVM = section.cellsVM[3] as? LabelCellViewModel,
              let platform5CellVM = section.cellsVM.last as? LabelCellViewModel else {
            XCTFail("Cell View Models are not correct")
            return
        }
        
        XCTAssertEqual(platform1CellVM.primaryText, "Atari 2600")
        XCTAssertEqual(platform2CellVM.primaryText, "Dreamcast")
        XCTAssertEqual(platform3CellVM.primaryText, "Game Boy Color")
        XCTAssertEqual(platform4CellVM.primaryText, "Jaguar")
        XCTAssertEqual(platform5CellVM.primaryText, "SNES")
    }
    
    func test_cellTappedCallback_ThenLastNavigationStyleIsCorrect() {
        // Given
        let gameDetailsDelegate = GameDetailsViewModelDelegateMock()
        let section = SelectPlatformSection(
            platforms: MockData.platforms,
            gameDetailsDelegate: gameDetailsDelegate
        )
        
        for (index, cellVM) in section.cellsVM.enumerated() {
            
            // When
            cellVM.cellTappedCallback?()
            
            // Then
            let expectedNavigationStyle: NavigationStyle = .push(
                screenFactory: SearchGameByTitleScreenFactory(
                    platform: MockData.platforms[index],
                    gameDetailsDelegate: gameDetailsDelegate
                )
            )
            
            XCTAssertEqual(Routing.shared.lastNavigationStyle, expectedNavigationStyle)
        }
    }
}
