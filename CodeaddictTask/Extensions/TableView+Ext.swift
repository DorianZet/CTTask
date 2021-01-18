//
//  TableView+Ext.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 17/01/2021.
//

import UIKit

extension UITableView {
    func removeSeparatorsOfEmptyCellsAndLastCell() {
        tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
    }
}
