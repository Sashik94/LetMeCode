//
//  ReviewesCollectionViewCell.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class ReviewesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var reviewesImage: UIImageView! {
        didSet {
            reviewesImage.setShadow(from: backView, cornerRadius: 5)
            reviewesImage.setCornerRadius(cornerRadius: 5)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var openingDateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewesImage.image = nil
    }
    
}
