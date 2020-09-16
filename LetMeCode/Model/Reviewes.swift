//
//  Reviews.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

struct Reviewes: Decodable {
    var status: String?
    var copyright: String?
    var num_results: Int?
    var results: [ReviewesResults] = []
}

struct ReviewesResults: Decodable {
    var display_title: String?
    var mpaa_rating: String?
    var critics_pick: Int?
    var byline: String?
    var headline: String?
    var summary_short: String?
    var publication_date: String?
    var opening_date: String?
    var date_updated: String?
    var link: ReviewesLink?
    var multimedia: ReviewesMultimedia?
}

struct ReviewesLink: Decodable {
    var type: String?
    var url: String?
    var suggested_link_text: String?
}

struct ReviewesMultimedia: Decodable {
    var type: String?
    var src: String?
    var width: Int?
    var height: Int?
}
