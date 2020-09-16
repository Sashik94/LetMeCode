//
//  Critics.swift
//  LetMeCode
//
//  Created by Александр Осипов on 14.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

struct Critics: Decodable {
    var status: String?
    var copyright: String?
    var num_results: Int?
    var results: [CriticsResults] = []
}

struct CriticsResults: Decodable {
    var display_name: String?
    var sort_name: String?
    var status: String?
    var bio: String?
    var seo_name: String?
    var multimedia: CriticsMultimedia?
}

struct CriticsMultimedia: Decodable {
    var resource: CriticsResource?
}

struct CriticsResource: Decodable {
    var type: String?
    var src: String?
    var height: Int?
    var width: Int?
    var credit: String?
}
