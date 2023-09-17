//
//  EditGameDetailsSection.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 14/09/2023.
//

import Foundation

final class EditGameDetailsSection: Section {
    
    init(savedGame: SavedGame, editDelegate: EditFormDelegate) {
        super.init()
        self.position = 0
        
        let gameCellVM = ImageDescriptionCellViewModel(
            imageStringURL: savedGame.game.imageURL,
            title: savedGame.game.title,
            subtitle1: savedGame.game.platform.title,
            subtitle2: savedGame.game.description
        )
        self.cellsVM.append(gameCellVM)
        
        let yearOfAcquisitionCellVM = TextFieldCellViewModel(
            placeholder: L10n.yearOfAcquisition,
            formType: AddGameFormType.yearOfAcquisition,
            value: savedGame.acquisitionYear,
            editDelegate: editDelegate
        )
        self.cellsVM.append(yearOfAcquisitionCellVM)
        
        let conditionCellVM = TextFieldCellViewModel(
            placeholder: L10n.condition,
            formType: AddGameFormType.gameCondition(
                PickerViewModel(
                    data: [GameCondition.allCases.map { $0.value }]
                )
            ),
            value: savedGame.gameCondition,
            editDelegate: editDelegate
        )
        self.cellsVM.append(conditionCellVM)
        
        let completenessCellVM = TextFieldCellViewModel(
            placeholder: L10n.completeness,
            formType: AddGameFormType.gameCompleteness(
                PickerViewModel(
                    data: [GameCompleteness.allCases.map { $0.value }]
                )
            ),
            value: savedGame.gameCompleteness,
            editDelegate: editDelegate
        )
        self.cellsVM.append(completenessCellVM)
        
        let regionCellVM = TextFieldCellViewModel(
            placeholder: L10n.region,
            formType: AddGameFormType.gameRegion(
                PickerViewModel(
                    data: [GameRegion.allCases.map { $0.rawValue }]
                )
            ),
            value: savedGame.gameRegion,
            editDelegate: editDelegate
        )
        self.cellsVM.append(regionCellVM)
        
        let storageAreaCellVM = TextFieldCellViewModel(
            placeholder: L10n.storageArea,
            formType: AddGameFormType.storageArea,
            value: savedGame.storageArea,
            editDelegate: editDelegate
        )
        self.cellsVM.append(storageAreaCellVM)
        
        let personalRatingCellVM = StarRatingCellViewModel(
            title: L10n.personalRating,
            formType: AddGameFormType.rating,
            value: savedGame.rating,
            editDelegate: editDelegate
        )
        self.cellsVM.append(personalRatingCellVM)
        
        let otherDetailsCellVM = TextViewCellViewModel(
            title: L10n.otherDetails,
            formType: AddGameFormType.notes,
            value: savedGame.notes,
            editDelegate: editDelegate
        )
        self.cellsVM.append(otherDetailsCellVM)
    }

}
