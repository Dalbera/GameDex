//
//  AddGameDetailsSectionTests.swift
//  GameDexTests
//
//  Created by Gabrielle Dalbera on 05/09/2023.
//

import XCTest
@testable import GameDex

final class AddGameDetailsSectionTests: XCTestCase {
    
    func test_init_GivenAddGameDetailsSection_ThenShouldSetPropertiesCorrectly() {
        // Given
        let game = Game(
            title: "The Legend of Zelda: The Minish Cap",
            description: "description",
            id: "id",
            platform: "Game Boy Advance",
            image: "imageURL"
        )
        
        let section = AddGameDetailsSection(game: game)
        
        // Then
        XCTAssertEqual(section.cellsVM.count, 9)
        
        guard let gameCellVM = section.cellsVM.first as? ImageDescriptionCellViewModel,
              let yearOfAcquisitionCellVM = section.cellsVM[1] as? TextFieldCellViewModel,
              let purchasePriceCellVM = section.cellsVM[2] as? TextFieldCellViewModel,
              let conditionCellVM = section.cellsVM[3] as? TextFieldCellViewModel,
              let completenessCellVM = section.cellsVM[4] as? TextFieldCellViewModel,
              let regionCellVM = section.cellsVM[5] as? TextFieldCellViewModel,
              let storageAreaCellVM = section.cellsVM[6] as? TextFieldCellViewModel,
              let personalRatingCellVM = section.cellsVM[7] as? StarRatingCellViewModel,
              let otherDetailsCellVM = section.cellsVM.last as? TextViewCellViewModel else {
            XCTFail("Cell View Models are not correct")
            return
        }
        
        XCTAssertEqual(gameCellVM.title, "The Legend of Zelda: The Minish Cap")
        XCTAssertEqual(gameCellVM.subtitle1, "Game Boy Advance")
        XCTAssertEqual(gameCellVM.subtitle2, "description")
        XCTAssertEqual(gameCellVM.imageStringURL, "imageURL")
        
        XCTAssertEqual(yearOfAcquisitionCellVM.placeholder, L10n.yearOfAcquisition)
        XCTAssertEqual(yearOfAcquisitionCellVM.textFieldType, .year)
        
        XCTAssertEqual(purchasePriceCellVM.placeholder, L10n.purchasePrice)
        XCTAssertEqual(purchasePriceCellVM.textFieldType, .price)
        
        XCTAssertEqual(conditionCellVM.placeholder, L10n.condition)
        XCTAssertEqual(
            conditionCellVM.textFieldType,
            .picker(
                PickerViewModel(
                    data: [
                        Condition.mint.value,
                        Condition.good.value,
                        Condition.acceptable.value,
                        Condition.poor.value
                    ]
                )
            )
        )
        
        XCTAssertEqual(completenessCellVM.placeholder, L10n.completeness)
        XCTAssertEqual(
            conditionCellVM.textFieldType,
            .picker(
                PickerViewModel(
                    data: [
                        Completeness.complete.value,
                        Completeness.noNotice.value,
                        Completeness.loose.value,
                        Completeness.sealed.value
                    ]
                )
            )
        )
        
        XCTAssertEqual(regionCellVM.placeholder, L10n.region)
        XCTAssertEqual(
            conditionCellVM.textFieldType,
            .picker(
                PickerViewModel(
                    data: [
                        Region.pal.rawValue,
                        Region.ntscu.rawValue,
                        Region.ntscj.rawValue,
                        Region.ntscc.rawValue
                    ]
                )
            )
        )
        
        XCTAssertEqual(storageAreaCellVM.placeholder, L10n.storageArea)
        XCTAssertEqual(storageAreaCellVM.textFieldType, .text)
        
        XCTAssertEqual(personalRatingCellVM.title, L10n.personalRating)
        XCTAssertEqual(personalRatingCellVM.rating, .zero)
        
        XCTAssertEqual(otherDetailsCellVM.title, L10n.otherDetails)
    }
}