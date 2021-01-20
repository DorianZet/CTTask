//
//  CTAvatarImageView.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

enum cornerRadius: CGFloat {
    case boxy = 0
    case smooth = 10
}

class CTAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    convenience init(cornerRadius: cornerRadius) {
        self.init(frame: .zero)
        layer.cornerRadius = cornerRadius.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
    }
    
    func downloadImage(from url: String) {
        let downloadTask = NetworkManager.shared.downloadImageTask(from: url) { (image) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
        downloadTask?.resume()
    }
}
