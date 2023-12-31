//
//  MyCollectionViewModel.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 16/08/2023.
//

import Foundation

// sourcery: AutoMockable
protocol MyCollectionViewModelDelegate: AnyObject {
    func reloadCollection() async
}

final class MyCollectionViewModel: ConnectivityDisplayerViewModel {
    lazy var searchViewModel: SearchViewModel? = SearchViewModel(
        placeholder: L10n.searchCollection,
        activateOnTap: true,
        delegate: self
    )
    var isBounceable: Bool = true
    var progress: Float?
    var rightButtonItems: [AnyBarButtonItem]? = [.add]
    let screenTitle: String? = L10n.myCollection
    var sections: [Section] = []
    var platforms: [Platform] = []
    
    weak var containerDelegate: ContainerViewControllerDelegate?
    weak var myCollectionDelegate: MyCollectionViewModelDelegate?
    
    private let localDatabase: LocalDatabase
    private let cloudDatabase: CloudDatabase
    let authenticationService: AuthenticationService
    let connectivityChecker: ConnectivityChecker
    
    init(
        localDatabase: LocalDatabase,
        cloudDatabase: CloudDatabase,
        authenticationService: AuthenticationService,
        connectivityChecker: ConnectivityChecker
    ) {
        self.localDatabase = localDatabase
        self.cloudDatabase = cloudDatabase
        self.authenticationService = authenticationService
        self.connectivityChecker = connectivityChecker
    }
    
    func loadData(callback: @escaping (EmptyError?) -> ()) async {
        self.displayInfoWarningIfNeeded()
        guard let userId = self.authenticationService.getUserId(),
              self.connectivityChecker.hasConnectivity() else {
            let platformsFetched = self.localDatabase.fetchAllPlatforms()
            switch platformsFetched {
            case .success(let platforms):
                guard let emptyError = self.handleDataSuccess(platforms: CoreDataConverter.convert(platformsCollected: platforms)) else {
                    callback(nil)
                    return
                }
                callback(emptyError)
            case .failure:
                callback(MyCollectionError.fetchError)
            }
            return
        }
        let platformsFetched = await self.cloudDatabase.getUserCollection(userId: userId)
        switch platformsFetched {
        case .success(let platforms):
            guard let emptyError = self.handleDataSuccess(platforms: platforms) else {
                callback(nil)
                return
            }
            callback(emptyError)
        case .failure:
            callback(MyCollectionError.fetchError)
        }
    }
    
    func didTapRightButtonItem() {
        self.presentAddGameMethods()
    }
}

extension MyCollectionViewModel {
    private func presentAddGameMethods() {
        Routing.shared.route(
            navigationStyle: .present(
                screenFactory: SelectPlatformScreenFactory(
                    delegate: self
                ),
                completionBlock: nil)
        )
    }
    
    private func updateListOfCollections(with list: [Platform]) {
        self.sections = [
            MyCollectionSection(
                platforms: list,
                myCollectionDelegate: self
            )
        ]
    }
    
    private func handleSectionCreation() {
        guard !self.platforms.isEmpty else {
            self.sections = []
            return
        }
        self.sections = [
            MyCollectionSection(
                platforms: self.platforms,
                myCollectionDelegate: self
            )
        ]
    }
    
    private func handleSearchIconDisplay() {
        self.rightButtonItems?.removeAll()
        guard !self.platforms.isEmpty else {
            self.rightButtonItems = [.add]
            return
        }
        self.rightButtonItems = [.add, .search]
    }
    
    private func handleDataSuccess(platforms: [Platform]) -> EmptyError? {
        guard !platforms.isEmpty else {
            self.platforms = []
            self.handleFetchEmptyCollection()
            return MyCollectionError.emptyCollection(myCollectionDelegate: self)
        }
        self.platforms = platforms
        self.handleSearchIconDisplay()
        self.handleSectionCreation()
        return nil
    }
    
    private func handleFetchEmptyCollection() {
        self.handleSearchIconDisplay()
        self.handleSectionCreation()
    }
}

// MARK: - MyCollectionViewModelDelegate
extension MyCollectionViewModel: MyCollectionViewModelDelegate {
    func reloadCollection() {
        self.containerDelegate?.reloadSections()
    }
}

// MARK: - SearchViewModelDelegate
extension MyCollectionViewModel: SearchViewModelDelegate {
    func cancelButtonTapped(callback: @escaping (EmptyError?) -> ()) {
        self.updateListOfCollections(with: self.platforms)
        self.handleSearchIconDisplay()
        callback(nil)
    }
    
    func updateSearchTextField(with text: String, callback: @escaping (EmptyError?) -> ()) {
        guard text != "" else {
            self.updateListOfCollections(with: self.platforms)
            callback(nil)
            return
        }
        self.rightButtonItems = []
        self.containerDelegate?.reloadNavBar()
        let matchingCollections = self.platforms.filter({
            $0.title.localizedCaseInsensitiveContains(text)
        })
        self.updateListOfCollections(with: matchingCollections)
        
        if matchingCollections.isEmpty {
            callback(MyCollectionError.noItems)
        } else {
            callback(nil)
        }
    }
}
