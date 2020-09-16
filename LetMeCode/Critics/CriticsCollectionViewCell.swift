//
//  CriticsCollectionViewCell.swift
//  LetMeCode
//
//  Created by Александр Осипов on 15.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class CriticsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var criticsImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
