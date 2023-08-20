//
//  ContainerViewController.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 18/08/2023.
//

import Foundation
import UIKit

protocol ContainerViewControllerDelegate: AnyObject {
    func configureBottomView(contentViewFactory: ContentViewFactory)
}

class ContainerViewController: UIViewController {
    
    // MARK: - Properties
    private let childVC: UIViewController
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.backgroundColor = .primaryBackgroundColor
        view.layoutMargins = .init(
            top: DesignSystem.paddingRegular,
            left: DesignSystem.paddingRegular,
            bottom: DesignSystem.paddingRegular,
            right: DesignSystem.paddingRegular
        )
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = DesignSystem.paddingRegular
        return view
    }()
    private let separatorView: UIView = {
        let view = UIView()
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private var bottomView = UIView()
    
    // MARK: - Init
    init(
        childVC: UIViewController
    ) {
        self.childVC = childVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(childVC)
        self.stackView.addArrangedSubview(childVC.view)
        self.view.addSubview(stackView)
        self.setupStackViewConstraints()
        self.childVC.didMove(toParent: self)
        self.view.backgroundColor = self.childVC.view.backgroundColor
//        self.childVC.navigationDelegate = self
        self.navigationController?.configure()
    }

    // MARK: - Methods
    
    private func setupStackViewConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension ContainerViewController: ContainerViewControllerDelegate {
    func configureBottomView(contentViewFactory: ContentViewFactory) {
        self.separatorView.removeFromSuperview()
        self.bottomView.removeFromSuperview()
        self.bottomView = contentViewFactory.bottomView
        self.stackView.addArrangedSubview(self.separatorView)
        self.stackView.addArrangedSubview(self.bottomView)
    }
}
