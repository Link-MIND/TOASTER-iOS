//
//  AddLinkViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 9/19/24.
//

import UIKit

protocol AddLinkViewModelInputs {
    func embedLinkText(_ text: String)}

protocol AddLinkViewModelOutputs {
    var isClearButtonHidden: Bool { get }
    var isNextButtonEnabled: Bool { get }
    var nextButtonBackgroundColor: UIColor { get }
    var textFieldBorderColor: UIColor { get }
    var linkEffectivenessMessage: String? { get }
}

protocol AddLinkViewModelType {
    var inputs: AddLinkViewModelInputs { get }
    var outputs: AddLinkViewModelOutputs { get }
}

final class AddLinkViewModel: AddLinkViewModelType, AddLinkViewModelInputs, AddLinkViewModelOutputs {
    
    // Input
    private var embedLink: String = "" {
        didSet {
            updateOutputs()
        }
    }
    
    // Output
    var isClearButtonHidden: Bool
    var isNextButtonEnabled: Bool
    var nextButtonBackgroundColor: UIColor
    var textFieldBorderColor: UIColor
    var linkEffectivenessMessage: String?
    
    init() {
        self.isClearButtonHidden = true
        self.isNextButtonEnabled = false
        self.nextButtonBackgroundColor = .gray200
        self.textFieldBorderColor = .clear
        self.linkEffectivenessMessage = nil
    }
    
    func embedLinkText(_ text: String) {
        embedLink = text
    }
    
    var inputs: AddLinkViewModelInputs { return self }
    var outputs: AddLinkViewModelOutputs { return self }
}

private extension AddLinkViewModel {
    func updateOutputs() {
        let isValid = isValidURL(embedLink)
        isClearButtonHidden = embedLink.isEmpty
        isNextButtonEnabled = !embedLink.isEmpty && isValid
        nextButtonBackgroundColor = isNextButtonEnabled ? .black850 : .gray200
        textFieldBorderColor = isValid ? .clear : UIColor.toasterError
        linkEffectivenessMessage = isValid ? nil : (embedLink.isEmpty ? "링크를 입력해주세요" : "유효하지 않은 형식의 링크입니다.")
    }
    
    func isValidURL(_ urlString: String) -> Bool {
        if (urlString.prefix(8) == "https://") || (urlString.prefix(7) == "http://") {
            return true
        } else {
            return false
        }
    }
}
