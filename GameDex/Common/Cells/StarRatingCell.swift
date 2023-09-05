//
//  StarRatingCell.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 04/09/2023.
//

import Foundation
import UIKit
import Cosmos

class StarRatingCell: UICollectionViewCell, CellConfigurable {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryColor
        label.textAlignment = .left
        label.font = Typography.headline.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starRatingView: CosmosView = {
        let view = CosmosView()
        view.rating = 5
        view.settings.fillMode = .full
        view.settings.starSize = DesignSystem.sizeTiny
        view.settings.starMargin = DesignSystem.paddingSmall
        view.settings.filledColor = UIColor.systemYellow
        view.settings.emptyBorderColor = UIColor.systemYellow
        view.settings.filledBorderColor = UIColor.systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override public func prepareForReuse() {
        // Ensures the reused view is as good as new
        self.starRatingView.prepareForReuse()
      }
    
    func configure(cellViewModel: CellViewModel) {
        guard let cellVM = cellViewModel as? StarRatingCellViewModel else {
            return
        }
        setupViews()
        setupConstraints()
        self.label.text = cellVM.title
    }
    
    private func setupViews() {
        self.backgroundColor = .primaryBackgroundColor
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.starRatingView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: DesignSystem.paddingSmall
            ),
            self.label.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: DesignSystem.paddingSmall
            ),
            self.label.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -DesignSystem.paddingSmall
            ),
            self.label.bottomAnchor.constraint(
                equalTo: self.starRatingView.topAnchor,
                constant: DesignSystem.paddingSmall
            ),

            self.starRatingView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: DesignSystem.paddingSmall
            ),
            self.starRatingView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -DesignSystem.paddingSmall
            ),
            self.starRatingView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -DesignSystem.paddingSmall
            )
        ])
    }
    
    func cellPressed(cellViewModel: CellViewModel) {}
    
}
