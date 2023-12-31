//
//  ButtonViewModel.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 17/08/2023.
//

import Foundation

struct ButtonViewModel {
    let isEnabled: Bool
    let buttonTitle: String    
    
    init(isEnabled: Bool = true, buttonTitle: String) {
        self.isEnabled = isEnabled
        self.buttonTitle = buttonTitle
    }
}
