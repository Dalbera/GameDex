//
//  AddGameStepOneScreenFactory.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 18/08/2023.
//

import Foundation
import UIKit

struct AddGameStepOneScreenFactory: ScreenFactory {
    
    var viewController: UIViewController {
        let viewModel = AddGameStepOneViewModel()
        let layout = FormLayoutBuilder()
        let addGameController = CollectionViewController(
            viewModel: viewModel,
            layoutBuilder: layout
        )
        let containerController = ContainerViewController(childVC: addGameController)
        viewModel.containerDelegate = containerController
        let navigationController = UINavigationController(rootViewController: containerController)
        return navigationController
    }
}