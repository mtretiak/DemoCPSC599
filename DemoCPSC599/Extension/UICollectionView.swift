//
//  UICollectionView.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-31.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func scrollToTheEnd(of section: Int) {
        let indexPath = IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
        scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
}
