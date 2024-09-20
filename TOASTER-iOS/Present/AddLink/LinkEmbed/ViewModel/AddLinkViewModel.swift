//
//  AddLinkViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 9/19/24.
//

import UIKit

protocol AddLinkViewModelInputs {
    // Textfield Text
}

protocol AddLinkViewModelOutputs {
    // Next Button Enabled
    // Next Button BackgroundColor
    // Textfield BorderColor
    // Textfield Error Message - Link effectiveness
}

protocol AddLinkViewModelType {
    var inputs: AddLinkViewModelInputs { get }
    var outputs: AddLinkViewModelOutpus { get }
}

final class AddLinkViewModel {
    
}
