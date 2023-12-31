//
//  ContentViewFactory.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 18/08/2023.
//

import Foundation
import UIKit

protocol ContentViewFactory {
    var contentView: UIView { get }
    var position: Position { get }
}
