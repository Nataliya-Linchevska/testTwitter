//
//  TwitterTableViewDelegate.swift
//  testTwitter
//
//  Created by user on 10.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

protocol TwitterTableViewDelegate: UITableViewDelegate {
    func reloadTableCellAtIndex(cell: UITableViewCell, indexPath: NSIndexPath)
}
