//
//  AddGameDetailsSectionTests.swift
//  GameDexTests
//
//  Created by Gabrielle Dalbera on 05/09/2023.
//

import XCTest
@testable import GameDex

final class AddGameDetailsSectionTests: XCTestCase {
    
    // MARK: Tests
    
    func test_init_GivenAddGameDetailsSection_ThenShouldSetPropertiesCorrectly() {
        // Given
        let section = AddGameDetailsSection(game: MockData.game)
        
        // Then
        XCTAssertEqual(section.cellsVM.count, 8)
        
        guard let gameCellVM = section.cellsVM.first as? ImageDescriptionCellViewModel else {
            XCTFail("Wrong type")
            return
        }
        
        XCTAssertEqual(gameCellVM.title, "The Legend of Zelda: The Minish Cap")
        XCTAssertEqual(gameCellVM.subtitle1, "Game Boy Advance")
        XCTAssertEqual(gameCellVM.subtitle2, "description")
        XCTAssertEqual(gameCellVM.imageStringURL, "imageURL")
        
        guard let formCellsVM = section.cellsVM.filter({ cellVM in
            return cellVM is (any CollectionFormCellViewModel)
        }) as? [any CollectionFormCellViewModel] else {
            return
        }
        
        for formCellVM in formCellsVM {
            guard let formType = formCellVM.formType as? AddGameFormType else {
                XCTFail("Wrong type")
                return
            }
            switch formType {
            case .yearOfAcquisition:
                guard let acquisitionYearCellVM = formCellVM as? TextFieldCellViewModel else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(acquisitionYearCellVM.placeholder, L10n.yearOfAcquisition)
            case .gameCondition(_):
                guard let gameConditionCellVM = formCellVM as? TextFieldCellViewModel,
                      let gameConditionCellVMFormType = gameConditionCellVM.formType as? AddGameFormType else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(gameConditionCellVM.placeholder, L10n.condition)
                XCTAssertEqual(
                    gameConditionCellVMFormType,
                    .gameCondition(
                        PickerViewModel(
                            data: [GameCondition.allCases.map { $0.value }]
                        )
                    )
                )
            case .gameCompleteness(_):
                guard let gameCompletenessCellVM = formCellVM as? TextFieldCellViewModel,
                      let gameCompletenessCellVMFormType = gameCompletenessCellVM.formType as? AddGameFormType  else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(gameCompletenessCellVM.placeholder, L10n.completeness)
                XCTAssertEqual(
                    gameCompletenessCellVMFormType,
                    .gameCompleteness(
                        PickerViewModel(
                            data: [GameCompleteness.allCases.map { $0.value }]
                        )
                    )
                )
            case .gameRegion(_):
                guard let gameRegionCellVM = formCellVM as? TextFieldCellViewModel,
                      let gameRegionCellVMFormType = gameRegionCellVM.formType as? AddGameFormType else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(gameRegionCellVM.placeholder, L10n.region)
                XCTAssertEqual(
                    gameRegionCellVMFormType,
                    .gameRegion(
                        PickerViewModel(
                            data: [GameRegion.allCases.map { $0.rawValue }]
                        )
                    )
                )
            case .storageArea:
                guard let storageAreaCellVM = formCellVM as? TextFieldCellViewModel else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(storageAreaCellVM.placeholder, L10n.storageArea)
            case .rating:
                guard let ratingCellVM = formCellVM as? StarRatingCellViewModel else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(ratingCellVM.title, L10n.personalRating)
            case .notes:
                guard let notesCellVM = formCellVM as? TextViewCellViewModel else {
                    XCTFail("Wrong type")
                    return
                }
                XCTAssertEqual(notesCellVM.title, L10n.otherDetails)
            }
        }
    }
}
