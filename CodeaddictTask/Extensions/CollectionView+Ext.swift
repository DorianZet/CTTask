//
//  CollectionView+Ext.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 19/01/2021.
//

import UIKit

extension UICollectionView {
    func scrollToTheTopOfHeader() {
        if let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
            var offsetY = attributes.frame.origin.y - self.contentInset.top
            offsetY -= self.safeAreaInsets.top
            self.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }
}
