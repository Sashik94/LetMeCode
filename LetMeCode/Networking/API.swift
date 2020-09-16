//
//  API.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

struct APIConstants {
    static let apiKey: String = "b5h3GstMLTTxse7TxGYL9xqIAAD97E3R"
}

enum Endpoint {
    case reviews (query: String, openingDate: String, offset: String)
    case critics (query: String)
    
    var baseURL: URL { URL(string: "https://api.nytimes.com/svc/movies/v2/")! }
    
    func path() -> String {
        switch self {
        case .reviews:
            return "reviews/search.json"
        case .critics:
            return "critics/"
        }
    }
    
    var absoluteURL: URL? {
        let queryURL = baseURL.appendingPathComponent(self.path())
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else {
            return nil
        }
        switch self {
        case .reviews(let query, let openingDate, let offset):
            urlComponents.queryItems = [URLQueryItem(name: "query", value: query),
                                        URLQueryItem(name: "opening-date", value: convertDate(openingDate)),
                                        URLQueryItem(name: "offset", value: offset),
                                        URLQueryItem(name: "api-key", value: APIConstants.apiKey)
                                       ]
        case .critics(let query):
            urlComponents.path += "\(query).json"
            urlComponents.queryItems = [URLQueryItem(name: "api-key", value: APIConstants.apiKey)]
        }
        return urlComponents.url
    }
    
    func convertDate(_ openingDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: ((formatter.date(from: openingDate) ?? formatter.date(from: "0001/01/01"))!))
    }
    
//    init? (index: Int, query: String = "", openingDate: String = "0001-01-01", offset: String = "0") {
//        switch index {
//        case 0: self = .reviews (query: query, openingDate: openingDate, offset: offset)
//        case 1: self = .critics (query: query)
//        default: return nil
//        }
//    }
    
}

enum FetchType {
    case reviews
    case critics
}

enum ResultsType<T:Decodable> {
    case success(model: T)
    case failure(error: T)
}
