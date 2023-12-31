//
//  Navigator+NavigationStyle.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 18/08/2023.
//

import Foundation
import UIKit

protocol Navigator {
    var lastNavigationStyle: NavigationStyle? { get set }
    func visibleViewController() -> UIViewController?
    func visibleViewController(_ rootViewController: UIViewController?) -> UIViewController?
    @discardableResult func route(navigationStyle: NavigationStyle,
                                  fromController: UIViewController?,
                                  animated: Bool) -> Navigator
}

enum NavigationStyle {
    case push(screenFactory: ScreenFactory)
    case pop
    case present(screenFactory: ScreenFactory, screenSize: ScreenSize = .full, completionBlock: (() -> Void)?)
    case dismiss(completionBlock: (() -> Void)?)
    case selectTab(index: Int, completionBlock: (() -> Void)?)
    case url(appURL: URL, appLauncher: AppLauncher, alertDisplayer: AlertDisplayer, alertViewModel: AlertViewModel)
}
