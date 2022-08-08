//
//  coursesViewController.swift
//  NetworkingApp
//
//  Created by Masaie on 7/8/22.
//

import UIKit
import Alamofire

class CoursesViewController: UITableViewController {
    
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseCell
        let course = courses[indexPath.row]
        cell.configure(with: course)
        return cell
    }

}

// MARK: - Networking
extension CoursesViewController {
    func fetchCourses() {
        NetworkManager.shared.fetch(dataType: [Course].self, from: Link.coursesURL.rawValue) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofireGetButtonPressed() {
        NetworkManager.shared.fetchDataWithAlamofire(Link.coursesURL.rawValue) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    func alamofirePostButtonPressed() {
        let course = Course(
            name: "Notification",
            imageUrl: Link.courseImageURL.rawValue,
            numberOfLessons: 65,
            numberOfTests: 40
        )
        
        NetworkManager.shared.postDataWithAlamofire(Link.postRequest.rawValue, data: course) { result in
            switch result {
            case .success(let course):
                self.courses.append(course)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
