//
//  CriticsDescriptionViewController.swift
//  LetMeCode
//
//  Created by Александр Осипов on 16.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class CriticsDescriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var criticsDescriptionCollectionView: UICollectionView!
    
    let networking = Networking()
    var critics = CriticsResults()
    var reviewesResults: [ReviewesResults] = []
    var offset = 0
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networking.delegate = self
        networking.fetchTracks(type: .reviews(reviewer: critics.display_name ?? "", offset: String(offset)), typeModel: Reviewes.self)
        
        titleLabel.text = critics.display_name
    }
    @IBAction func backBatton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CriticsDescriptionViewController: PresentModelProtocol {
    func presentModel<T>(response: ResultsType<T>) {
        switch response {
        case .success(let genericModel):
            DispatchQueue.main.async {
                let model = genericModel as! Reviewes
                for result in model.results {
                    self.reviewesResults.append(result)
                }
                self.criticsDescriptionCollectionView.reloadData()
            }
            
        case .failure(let error):
            let stringError = error as! String
            print(error)
            DispatchQueue.main.async {
                self.errorAlert(with: stringError)
            }
        }
    }
    
    func errorAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: "Повторите попытку.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
          exit(0)
        })
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] (_) in
            self?.networking.fetchTracks(type: .reviews(reviewer: self?.critics.display_name ?? "", offset: "0"), typeModel: Reviewes.self)
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(closeAction)
        
        
        present(alertController, animated: true)
    }
    
}

extension CriticsDescriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewesResults.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = criticsDescriptionCollectionView.dequeueReusableCell(withReuseIdentifier: "CriticsDescriptionCell", for: indexPath) as! CriticsDescriptionCollectionViewCell
            
            cell.fillingCell(critics)
            
            return cell
            
        } else {
            let cell = criticsDescriptionCollectionView.dequeueReusableCell(withReuseIdentifier: "CriticsReviewesCell", for: indexPath) as! CriticsReviewesCollectionViewCell
            
            let track = reviewesResults[indexPath.row - 1]
            
            DispatchQueue.global().async {
                if let multimedia = track.multimedia, let imageString = multimedia.src {
                    if let cachedImage = self.imageCache.object(forKey: imageString as NSString) {
                        DispatchQueue.main.async {
                            cell.reviewesImage.image = cachedImage
                            cell.reviewesImage.setShadow(from: cell.backView, cornerRadius: 5)
                            cell.reviewesImage.setCornerRadius(cornerRadius: 5)
                        }
                    } else {
                        if let image = try? UIImage(data: Data(contentsOf: URL(string: imageString)!)) {
                            self.imageCache.setObject(image, forKey: imageString as NSString)
                            DispatchQueue.main.async {
                                cell.reviewesImage.image = image
                                cell.reviewesImage.setShadow(from: cell.backView, cornerRadius: 5)
                                cell.reviewesImage.setCornerRadius(cornerRadius: 5)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.reviewesImage.image = nil
                        cell.reviewesImage.image?.withTintColor(#colorLiteral(red: 0.6308528781, green: 0.9171262383, blue: 1, alpha: 1))
                        cell.reviewesImage.setShadow(from: cell.backView, cornerRadius: 5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                    }
                }
                
            }
            
            cell.titleLabel.text = track.display_title //"Soufra"
            cell.descriptionLabel.text = track.summary_short //"This documentary from Thomas Morgan, about a female entrepreneur establishing a business just south of Beirut, is a stirring tale of empowerment."
            cell.bylineLabel.text = track.byline //"ANDY WEBSTER"
            cell.openingDateLabel.text = APIConstants.convertDate(track.opening_date!, format: "yyyy/MM/dd") //"2017-12-22 17:44:01"
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.bounds.width) - 16
        if indexPath.row > 0 {
            return CGSize(width: w, height: w * (0.44))
        }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = critics.bio == "" ? "123456789" : critics.bio

        let width = w
        
        var height = label.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        
        height += (w + 16) * 0.33 + 16
        
        return CGSize(width: w, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = reviewesResults.count
        if indexPath.row == (count - 1) && count >= 20 {
            offset += 20
            networking.fetchTracks(type: .reviews(reviewer: critics.display_name ?? "", offset: String(offset)), typeModel: Reviewes.self)
        }
    }
    
}
