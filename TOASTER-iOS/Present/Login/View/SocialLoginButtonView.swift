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
        
        configuration.title = type.title
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = type.titleColor
        configuration.baseBackgroundColor = type.backgroundColor
        
        self.configuration = configuration
        clipsToBounds = true
    }
}
