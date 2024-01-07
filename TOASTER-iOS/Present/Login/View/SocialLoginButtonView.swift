//
//  SocialLoginButtonView.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 12/30/23.
//

import UIKit

final class SocialLoginButtonView: UIButton {

    // MARK: - Properties
    
    var loginType: SocialLoginType
    
    // MARK: - Life Cycle
    
    init(type: SocialLoginType) {
        self.loginType = type
        super.init(frame: .zero)
        setupSocialButton(type: loginType)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension SocialLoginButtonView {
    func setupSocialButton(type: SocialLoginType) {
        var configuration = UIButton.Configuration.filled()
        
        var titleAttr = AttributedString.init("\(type.title)")
        titleAttr.font = .suitBold(size: 16)
        configuration.attributedTitle = titleAttr
        
        configuration.image = type.logoImage
        configuration.imagePadding = 4
        
        configuration.background.cornerRadius = 12
        configuration.baseForegroundColor = type.titleColor
        configuration.baseBackgroundColor = type.backgroundColor
        
        self.configuration = configuration
        clipsToBounds = true
    }
}
