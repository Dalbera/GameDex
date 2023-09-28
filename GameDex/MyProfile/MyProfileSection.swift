//
//  MyProfileSection.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 23/09/2023.
//

import Foundation

final class MyProfileSection: Section {
    
    init(
        userIsLoggedIn: Bool,
        myProfileDelegate: MyProfileViewModelDelegate?,
        logOutCallback: (() -> Void)?
    ) {
        super.init()
        self.position = 0
        
        if userIsLoggedIn {
            let logoutCellVM = LabelCellViewModel(
                primaryText: L10n.logout,
                cellTappedCallback: logOutCallback
            )
            self.cellsVM.append(logoutCellVM)
        } else {
            let loginCellVM = LabelCellViewModel(
                primaryText: L10n.login
            ) {
                let screenFactory = LoginScreenFactory(
                    myProfileDelegate: myProfileDelegate
                )
                Routing.shared.route(
                    navigationStyle: .push(
                        controller: screenFactory.viewController
                    )
                )
            }
            self.cellsVM.append(loginCellVM)
        }
        
        let collectionManagementCellVM = LabelCellViewModel(
            primaryText: L10n.collectionManagement
        )
        self.cellsVM.append(collectionManagementCellVM)
        
        let contactUsCellVM = LabelCellViewModel(
            primaryText: L10n.contactUs
        )
        self.cellsVM.append(contactUsCellVM)
    }
}
