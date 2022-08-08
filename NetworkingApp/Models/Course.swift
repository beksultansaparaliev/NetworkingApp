//
//  Course.swift
//  NetworkingApp
//
//  Created by Masaie on 7/8/22.
//

struct Course: Codable {
    let name: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    init(name: String, imageUrl: String, numberOfLessons: Int, numberOfTests: Int) {
        self.name = name
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
    }
    
    init(courseData: [String: Any]) {
        name = courseData["name"] as? String
        imageUrl = courseData["imageUrl"] as? String
        numberOfLessons = courseData["number_of_lessons"] as? Int
        numberOfTests = courseData["number_of_tests"] as? Int
    }
    
    init(courseJP: CourseJP) {
        self.name = courseJP.name
        self.imageUrl = courseJP.imageUrl
        self.numberOfLessons = Int(courseJP.numberOfLessons) ?? 0
        self.numberOfTests = Int(courseJP.numberOfTests) ?? 0
    }
    
    static func getCourses(from value: Any) -> [Course] {
        guard let coursesData = value as? [[String: Any]] else { return [] }
        return coursesData.compactMap { Course(courseData: $0) }
    }
}

struct CourseJP: Codable {
    let name: String
    let imageUrl: String
    let numberOfLessons: String
    let numberOfTests: String
}

struct WebsiteDescription: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
