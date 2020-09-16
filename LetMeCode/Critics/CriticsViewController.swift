//
//  CriticsViewController.swift
//  LetMeCode
//
//  Created by Александр Осипов on 15.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class CriticsViewController: UIViewController {
    
    @IBOutlet weak var criticsCollectionView: UICollectionView!
    @IBOutlet weak var criticsSegmentedControl: UISegmentedControl!
    
    var reviewesVC: ReviewesViewController?
    let networking = Networking()
    var criticsResults: [CriticsResults] = []
    var query = "all"
    var offset = 0
    let imageCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.delegate = self
        networking.fetchTracks(type: .critics(query: query), typeModel: Critics.self)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
//        self.view.addGestureRecognizer(tapGesture)
        
        criticsCollectionView.refreshControl = myRefreshControl
        
    }
    
    @objc func tapGestureDone() {
        view.endEditing(true)
    }
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        criticsResults.removeAll()
        networking.fetchTracks(type: .critics(query: query), typeModel: Critics.self)
        sender.endRefreshing()
    }
    
    @IBAction func transitionReviewesVC(_ sender: UISegmentedControl) {
        if let reviewesVC = reviewesVC {
            reviewesVC.criticsVC = self
            reviewesVC.modalPresentationStyle = .fullScreen
            dismiss(animated: false, completion: nil)
            present(reviewesVC, animated: false)
            criticsSegmentedControl.selectedSegmentIndex = 1
        } else {
            let reviewesVC = storyboard?.instantiateViewController(withIdentifier: "ReviewesViewController") as? ReviewesViewController
            reviewesVC!.criticsVC = self
            reviewesVC!.modalPresentationStyle = .fullScreen
            dismiss(animated: false, completion: nil)
            present(reviewesVC!, animated: false)
            criticsSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionViewCell = sender as! UICollectionViewCell
        let indexPath = criticsCollectionView.indexPath(for: collectionViewCell)!
        
        let track = criticsResults[indexPath.row]
        
        if segue.identifier == "CriticsDescription" {
            let CDVC = segue.destination as! CriticsDescriptionViewController
            CDVC.critics = track
        }
    }
    
}

extension CriticsViewController: PresentModelProtocol {
    func presentModel<T>(response: ResultsType<T>) {
        switch response {
        case .success(let genericModel):
            DispatchQueue.main.async {
                let model = genericModel as! Critics
                for result in model.results {
                    self.criticsResults.append(result)
                }
                self.criticsCollectionView.reloadData()
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
            self?.networking.fetchTracks(type: .critics(query: self!.query), typeModel: Critics.self)
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
}

extension CriticsViewController: CriticsReusableViewDelegate {
    func reloadCollectionView(query: String) {
        criticsResults.removeAll()
        self.query = query
        networking.fetchTracks(type: .critics(query: query), typeModel: Critics.self)
    }
}

extension CriticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "CriticsSerch",
            for: indexPath) as! CriticsCollectionReusableView
        headerView.delegate = self
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return criticsResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = criticsCollectionView.dequeueReusableCell(withReuseIdentifier: "CriticsCell", for: indexPath) as! CriticsCollectionViewCell
        
        let track = criticsResults[indexPath.row]
        
        DispatchQueue.global().async {
            if let multimedia = track.multimedia, let resource = multimedia.resource, let imageString = resource.src {
                if let cachedImage = self.imageCache.object(forKey: imageString as NSString) {
                    DispatchQueue.main.async {
                        cell.criticsImage.image = cachedImage
                        cell.criticsImage.setShadow(from: cell.backView, cornerRadius: 5)
                        cell.criticsImage.setCornerRadius(cornerRadius: 5)
                    }
                } else {
                    if let image = try? UIImage(data: Data(contentsOf: URL(string: imageString)!)) {
                        self.imageCache.setObject(image, forKey: imageString as NSString)
                        DispatchQueue.main.async {
                            cell.criticsImage.image = image
                            cell.criticsImage.setShadow(from: cell.backView, cornerRadius: 5)
                            cell.criticsImage.setCornerRadius(cornerRadius: 5)
                        }
                    }
                }
            }  else {
                DispatchQueue.main.async {
                    cell.criticsImage.image = UIImage(systemName: "person.crop.square")
                    cell.criticsImage.image?.withTintColor(#colorLiteral(red: 0.6308528781, green: 0.9171262383, blue: 1, alpha: 1))
                    cell.criticsImage.setShadow(from: cell.backView, cornerRadius: 5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                }
            }
        }
        
        cell.nameLabel.text = track.display_name //"Soufra"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.bounds.width / 2) - 16
        return CGSize(width: w, height: w)
    }
    
}
