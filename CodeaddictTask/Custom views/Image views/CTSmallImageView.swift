//
//  CTSmallImageView.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

enum placeholderImage: String {
    case star = "starIcon"
    case starFull = "starIconFull"
    case forward = "forwardIcon"
    case share = "shareIcon"
}

class CTSmallImageView: UIImageView {
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    convenience init(image: placeholderImage) {
        self.init(frame: .zero)
        self.image = UIImage(named: image.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
}
