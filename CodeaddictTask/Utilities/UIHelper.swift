//
//  UIHelper.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

enum UIHelper {
    static func configureCollectionViewLayout(in view: UIView) -> UICollectionViewCompositionalLayout {
        let collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(92))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            let contentInsets = DeviceTypes.isSmallerIphone() ?NSDirectionalEdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16) : NSDirectionalEdgeInsets(top: 9, leading: 20, bottom: 9, trailing: 20)
            section.contentInsets = contentInsets
            section.interGroupSpacing = 9

            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(22))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
        
        return collectionViewLayout
    }
}
