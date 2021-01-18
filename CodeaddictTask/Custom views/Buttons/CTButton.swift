//
//  CTButton.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

enum buttonCornerRadius: CGFloat {
    case smooth = 10
    case verySmooth = 17
}

class CTButton: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -5, dy: -5).contains(point)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String, cornerRadius: buttonCornerRadius, font: UIFont) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        layer.cornerRadius = cornerRadius.rawValue
        titleLabel?.font = font
    }
    
    private func configure() {
        setTitleColor(.systemBlue, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addTarget(self, action: #selector(buttonUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonCancel), for: .touchDragExit)
        self.addTarget(self, action: #selector(buttonDragInside), for: .touchDragInside)
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    @objc func buttonUp(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 1)
    }

    @objc func buttonDown(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 0.6)
    }

    @objc func buttonCancel(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 1)
    }

    @objc func buttonDragInside(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 0.6)
    }
    
    private func animateButtonAlpha(buttonAnimated button: UIButton, toAlpha alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            button.alpha = alpha
        }
    }
}
