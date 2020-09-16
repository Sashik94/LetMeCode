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
    
    static func convertDate(_ openingDate: String, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: ((formatter.date(from: openingDate) ?? formatter.date(from: "0001/01/01"))!))
    }
}

enum Endpoint {
    case reviews (reviewer: String = "", query: String = "", openingDate: String = "0001-01-01", offset: String = "0")
    case critics (query: String = "all")
    
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
        case .reviews(let reviewer, let query, let openingDate, let offset):
            urlComponents.queryItems = [URLQueryItem(name: "reviewer", value: reviewer),
                                        URLQueryItem(name: "query", value: query),
                                        URLQueryItem(name: "opening-date", value: APIConstants.convertDate(openingDate)),
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
    
}

enum FetchType {
    case reviews
    case critics
}

enum ResultsType<T:Decodable> {
    case success(model: T)
    case failure(error: T)
}
