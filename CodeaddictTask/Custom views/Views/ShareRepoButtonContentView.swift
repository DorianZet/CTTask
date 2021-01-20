//
//  ShareRepoButtonContentView.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 17/01/2021.
//

import UIKit

class ShareRepoButtonContentView: UIView {
    
    let shareImageView = CTSmallImageView(image: .share)
    let shareImage = Images.share
    let titleLabel = CTBlueLabel(textAlignment: .left, fontSize: 17, weight: .semibold)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configure() {
        addSubviews(shareImageView, titleLabel)
        titleLabel.text = "Share Repo"
        shareImageView.image = shareImage
        
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            shareImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            shareImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shareImageView.heightAnchor.constraint(equalToConstant: 18),
            shareImageView.widthAnchor.constraint(equalToConstant: 18),
           
            titleLabel.centerYAnchor.constraint(equalTo: shareImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: shareImageView.trailingAnchor, constant: 9),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
}
