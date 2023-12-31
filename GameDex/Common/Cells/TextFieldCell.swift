//
//  TextFieldCell.swift
//  GameDex
//
//  Created by Gabrielle Dalbera on 17/08/2023.
//

import Foundation
import UIKit
import DTTextField

final class TextFieldCell: UICollectionViewCell, CellConfigurable {
    
    private lazy var textField: DTTextField = {
        let textField = DTTextField()
        textField.configure()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: self.contentView.frame.size.width,
                    height: DesignSystem.sizeBig
                )
            )
        )
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private var cellVM: TextFieldCellViewModel?
    private var pickerData: [[String]]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(textField)
        self.contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.textField.dtLayer.backgroundColor = UIColor.primaryBackgroundColor.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textField.inputView = nil
        self.textField.isSecureTextEntry = false
        self.textField.rightView = nil
        self.textField.text = nil
        self.pickerData = nil
    }
    
    func configure(cellViewModel: CellViewModel) {
        guard let cellVM = cellViewModel as? TextFieldCellViewModel else {
            return
        }
        self.cellVM = cellVM
        self.textField.placeholder = cellVM.placeholder
        self.textField.text = cellVM.value

        if let keyboardType = cellVM.formType.keyboardType {
            self.textField.keyboardType = keyboardType
        } else if let inputVM = cellVM.formType.inputPickerViewModel {
            self.pickerData = inputVM.data
            self.textField.inputView = pickerView
        }
        
        if cellVM.formType.enableSecureTextEntry {
            self.textField.isSecureTextEntry = true
            self.textField.enableEntryVisibilityToggle()
        }
        
        self.textField.autocorrectionType = .no
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func storeEntry(cellViewModel: CellViewModel?, with text: String) {
        guard let cellVM = self.cellVM else {
            return
        }
        cellVM.value = text
    }
}

// MARK: TextFieldDelegate

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        self.storeEntry(cellViewModel: self.cellVM, with: text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let data = self.pickerData,
              let firstValue = data.first?.first else {
            return
        }
        self.storeEntry(cellViewModel: self.cellVM, with: firstValue)
        textField.text = firstValue
    }
}

// MARK: - PickerView DataSource

extension TextFieldCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let data = self.pickerData else {
            return .zero
        }
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let data = self.pickerData else {
            return .zero
        }
        return data[component].count
    }
}

// MARK: - PickerView Delegate

extension TextFieldCell: UIPickerViewDelegate {
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let data = self.pickerData else {
            return nil
        }
        return data[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let data = self.pickerData else {
            return
        }
        self.textField.text = data[component][row]
    }
}
