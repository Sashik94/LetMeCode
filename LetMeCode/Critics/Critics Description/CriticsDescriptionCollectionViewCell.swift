//
//  CriticsDescriptionCollectionViewCell.swift
//  LetMeCode
//
//  Created by Александр Осипов on 16.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class CriticsDescriptionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var criticsImageView: UIImageView!
    @IBOutlet weak var criticsNameLabel: UILabel!
    @IBOutlet weak var criticsStatusLabel: UILabel!
    @IBOutlet weak var criticsBioLabel: UILabel!
    
    func fillingCell(_ critic: CriticsResults) {
        
        DispatchQueue.global().async {
            if let multimedia = critic.multimedia, let resource = multimedia.resource, let imageString = resource.src {
                if let image = try? UIImage(data: Data(contentsOf: URL(string: imageString)!)) {
                    DispatchQueue.main.async {
                        self.criticsImageView.image = image
                        self.criticsImageView.setShadow(from: self.backView, cornerRadius: 5)
                        self.criticsImageView.setCornerRadius(cornerRadius: 5)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.criticsImageView.image = UIImage(systemName: "person.crop.square")
                    self.criticsImageView.image?.withTintColor(#colorLiteral(red: 0.6308528781, green: 0.9171262383, blue: 1, alpha: 1))
                    self.criticsImageView.setShadow(from: self.backView, cornerRadius: 5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                }
            }
            
            DispatchQueue.main.async {
                self.criticsNameLabel.text = critic.display_name
                self.criticsStatusLabel.text = critic.status
                self.criticsBioLabel.text = critic.bio?.replacingOccurrences(of: "<br/>", with: "")
            }
        }
    }
    
}
