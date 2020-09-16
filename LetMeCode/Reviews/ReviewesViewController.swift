//
//  ViewController.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class ReviewesViewController: UIViewController{

    @IBOutlet weak var reviewesCollectionView: UICollectionView!
    
    let networking = Networking()
    var reviewesResults: [ReviewesResults] = []
    var query = ""
    var openingDate = "0001-01-01"
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.delegate = self
        networking.fetchTracks(type: .reviews(query: query, openingDate: openingDate, offset: String(offset)), typeModel: Reviewes.self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
        self.view.addGestureRecognizer(tapGesture)
        
        reviewesCollectionView.refreshControl = myRefreshControl
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
        reviewesResults.removeAll()
        networking.fetchTracks(type: .reviews(query: query, openingDate: openingDate, offset: "0"), typeModel: Reviewes.self)
        sender.endRefreshing()
    }
    
}

extension ReviewesViewController: PresentModelProtocol {
    func presentModel<T>(response: ResultsType<T>) where T : Decodable {
        switch response {
        case .success(let genericModel):
            let model = genericModel as! Reviewes
            for result in model.results {
                reviewesResults.append(result)
            }
            DispatchQueue.main.async {
                self.reviewesCollectionView.reloadData()
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
            self?.networking.fetchTracks(type: .reviews(query: self!.query, openingDate: self!.openingDate, offset: "0"), typeModel: Reviewes.self)
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(closeAction)
        
        
        present(alertController, animated: true)
    }
    
}

extension ReviewesViewController: ReviewesReusableViewDelegate {
    func reloadCollectionView(query: String, openingDate: String) {
        reviewesResults.removeAll()
        networking.fetchTracks(type: .reviews(query: query, openingDate: openingDate, offset: "0"), typeModel: Reviewes.self)
    }
}

extension ReviewesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "ReviewesSerch",
            for: indexPath) as! ReviewesCollectionReusableView
        headerView.delegate = self
        headerView.addDate()
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewesResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reviewesCollectionView.dequeueReusableCell(withReuseIdentifier: "ReviewesCell", for: indexPath) as! ReviewesCollectionViewCell
        
        let track = reviewesResults[indexPath.row]
        
        DispatchQueue.global().async {
            if let multimedia = track.multimedia, let imageString = multimedia.src {
                if let image = try? UIImage(data: Data(contentsOf: URL(string: imageString)!)) {
                    DispatchQueue.main.async {
                        cell.reviewesImage.image = image
                    }
                }
            }
        }
        
        cell.titleLabel.text = track.display_title //"Soufra"
        cell.descriptionLabel.text = track.summary_short //"This documentary from Thomas Morgan, about a female entrepreneur establishing a business just south of Beirut, is a stirring tale of empowerment."
        cell.bylineLabel.text = track.byline //"ANDY WEBSTER"
        cell.openingDateLabel.text = track.opening_date //"2017-12-22 17:44:01"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.bounds.width) - 16
        return CGSize(width: w, height: w * (0.44))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = reviewesResults.count
        print(count)
        if indexPath.row == (count - 1) {
            offset += 20
            networking.fetchTracks(type: .reviews(query: query, openingDate: openingDate, offset: String(offset)), typeModel: Reviewes.self)
        }
    }
    
}
