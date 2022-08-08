//
//  Course.swift
//  NetworkingApp
//
//  Created by Masaie on 7/8/22.
//

struct Course: Decodable {
    let name: String?
    let imageUrl: String?
    let number_of_lessons: Int?
    let number_of_tests: Int?
}

struct AboutUs: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
