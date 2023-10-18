//
//  EditProfileViewModel.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 18/10/2023.
//

import Foundation

final class EditProfileViewModel: CollectionViewModel {
    var searchViewModel: SearchViewModel?
    var isBounceable: Bool = false
    var progress: Float?
    var rightButtonItems: [AnyBarButtonItem]?
    let screenTitle: String? = L10n.editProfile
    var sections: [Section] = []
    
    weak var containerDelegate: ContainerViewControllerDelegate?
    weak var myProfileDelegate: MyProfileViewModelDelegate?
    weak var myCollectionDelegate: MyCollectionViewModelDelegate?
    
    private var alertDisplayer: AlertDisplayer
    private let cloudDatabase: CloudDatabase
    private let authenticationService: AuthenticationService
    private var credentialsConfirmed: Bool
    
    init(
        myProfileDelegate: MyProfileViewModelDelegate?,
        myCollectionDelegate: MyCollectionViewModelDelegate?,
        alertDisplayer: AlertDisplayer,
        authenticationService: AuthenticationService,
        cloudDatabase: CloudDatabase,
        credentialsConfirmed: Bool
    ) {
        self.myProfileDelegate = myProfileDelegate
        self.myCollectionDelegate = myCollectionDelegate
        self.authenticationService = authenticationService
        self.cloudDatabase = cloudDatabase
        self.alertDisplayer = alertDisplayer
        self.credentialsConfirmed = credentialsConfirmed
    }
    
    func loadData(callback: @escaping (EmptyError?) -> ()) {
        self.sections = [
            EditProfileSection(
                credentialsConfirmed: self.credentialsConfirmed,
                myProfileDelegate: self.myProfileDelegate,
                myCollectionDelegate: self.myCollectionDelegate,
                alertDisplayer: self.alertDisplayer,
                primaryButtonDelegate: self
            )
        ]
        callback(nil)
    }
}

extension EditProfileViewModel: PrimaryButtonDelegate {
    func didTapPrimaryButton() async {
        guard let firstSection = self.sections.first,
              let formCellsVM = firstSection.cellsVM.filter({ cellVM in
                  return cellVM is (any CollectionFormCellViewModel)
              }) as? [any CollectionFormCellViewModel] else {
            return
        }
        
        var email, password: String?
        
        for formCellVM in formCellsVM {
            guard let formType = formCellVM.formType as? UserAccountFormType else {
                return
            }
            switch formType {
            case .email:
                email = formCellVM.value as? String
            case .password:
                password = formCellVM.value as? String
            }
        }
        
        guard let email = email,
              let password = password else { return }
        
        if self.credentialsConfirmed {
            await self.handleUserDetailsUpdate(newEmail: email, newPassword: password)
        } else {
            await self.handleReauthentication(email: email, password: password)
            self.containerDelegate?.reloadSections()
        }
    }
}

private extension EditProfileViewModel {
    func displayAlert(alertType: AlertType) {
        let successText = credentialsConfirmed ? L10n.updateSuccessDescription : L10n.successAuthDescription
        let errorText = credentialsConfirmed ? L10n.updateErrorDescription : L10n.errorCredentialsDescription
        let warningText = L10n.warningUpdatePassword
        self.alertDisplayer.presentTopFloatAlert(
            parameters: AlertViewModel(
                alertType: alertType,
                description: (alertType == .success) ? successText : ((alertType == .warning) ? warningText : errorText)
            )
        )
    }
    
    func handleReauthentication(email: String, password: String) async {
        guard await self.authenticationService.reauthenticateUser(email: email, password: password) == nil else {
            self.displayAlert(alertType: .error)
            return
        }
        self.displayAlert(alertType: .success)
        self.credentialsConfirmed = true
    }
    
    func handleUserDetailsUpdate(newEmail: String, newPassword: String) async {
        guard await self.authenticationService.updateUserEmailAddress(to: newEmail, cloudDatabase: self.cloudDatabase) == nil else {
            self.displayAlert(alertType: .error)
            return
        }
        guard await self.authenticationService.updateUserPassword(to: newPassword) == nil else {
            self.displayAlert(alertType: .warning)
            return
        }
        self.displayAlert(alertType: .success)
        await self.myCollectionDelegate?.reloadCollection()
        self.myProfileDelegate?.reloadMyProfile()
        self.containerDelegate?.goBackToRootViewController()
    }
}
