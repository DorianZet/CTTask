//
//  CTEmptyStateView.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 15/01/2021.
//

import UIKit

class CTEmptyStateView: UIView {
    
    let messageLabel = CTTitleLabel(textAlignment: .center, fontSize: 28, weight: .semibold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        addSubviews(messageLabel)
        configureMessageLabel()
    }
    
    private func configureMessageLabel() {
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 2
                
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
