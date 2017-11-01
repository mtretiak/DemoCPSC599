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
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
}
