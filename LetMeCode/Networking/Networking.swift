//
//  Networking.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

protocol PresentModelProtocol {
    func presentModel<T: Decodable>(response: ResultsType<T>)
}

class Networking {
    
    var delegate: PresentModelProtocol?
    var urlString = ""
    
    func fetchTracks<T: Decodable>(type: Endpoint, typeModel: T.Type) {
        
        switch type {
        case .reviews(let reviewer, let query, let openingDate, let offset):
            urlString = Endpoint.reviews(reviewer: reviewer, query: query, openingDate: openingDate, offset: offset).absoluteURL?.absoluteString ?? ""
        case .critics(let query):
            urlString = Endpoint.critics(query: query).absoluteURL?.absoluteString ?? ""
        }
        
        getData(from: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(typeModel, from: data)
                    self!.delegate?.presentModel(response: .success(model: tracks))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    self!.delegate?.presentModel(response: .failure(error: jsonError.localizedDescription))
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                self!.delegate?.presentModel(response: .failure(error: error.localizedDescription))
            }
        }
    }
    
    private func getData(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
