//
//  MyCollectionSectionTests.swift
//  GameDexTests
//
//  Created by Gabrielle Dalbera on 16/09/2023.
//

import XCTest
@testable import GameDex

final class MyCollectionSectionTests: XCTestCase {
    
    func test_init_ThenShouldSetPropertiesCorrectly() {
        // Given
        let section = MyCollectionSection(
            platforms: MockData.platforms,
            myCollectionDelegate: MyCollectionViewModelDelegateMock()
        )
        
        // Then
        XCTAssertEqual(section.cellsVM.count, MockData.platforms.count)
        
        guard let collectionCellVM = section.cellsVM.first as? LabelCellViewModel else {
            XCTFail("Cell View Models are not correct")
            return
        }
        
        XCTAssertEqual(collectionCellVM.primaryText, "SNES")
        XCTAssertEqual(collectionCellVM.secondaryText, "2 \(L10n.games)")
    }
    
    func test_cellTappedCallback_ThenLastNavigationStyleIsCorrect() {
        // Given
        let platforms = MockData.platforms
        let myCollectionDelegate = MyCollectionViewModelDelegateMock()
        let section = MyCollectionSection(
            platforms: platforms,
            myCollectionDelegate: myCollectionDelegate
        )
        
        for (index, cellVM) in section.cellsVM.enumerated() {
            
            // When
            cellVM.cellTappedCallback?()
            
            // Then
            let expectedNavigationStyle: NavigationStyle = .push(
                screenFactory: MyCollectionByPlatformsScreenFactory(
                    platform: platforms[index],
                    myCollectionDelegate: myCollectionDelegate
                )
            )
            XCTAssertEqual(Routing.shared.lastNavigationStyle, expectedNavigationStyle)
        }
    }
}
