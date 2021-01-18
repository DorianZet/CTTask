//
//  CTUniversalLabel.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 17/01/2021.
//

import UIKit

class CTUniversalLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, alpha: CGFloat, textStyle: UIFont.TextStyle, textColor: UIColor) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.alpha = alpha
        self.font = UIFont.preferredFont(forTextStyle: textStyle)
        self.textColor = textColor
    }
    
    private func configure() {
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
