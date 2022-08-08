//
//  MainViewController.swift
//  NetworkingApp
//
//  Created by Masaie on 7/8/22.
//

import UIKit

enum Link: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case courseURL = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    case coursesURL = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case aboutUsURL = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case aboutUsURL2 = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
}

enum UserAction: String, CaseIterable {
    case showImage = "Show Image"
    case fetchCourse = "Fetch Course"
    case fetchCourses = "Fetch Courses"
    case aboutSwiftBook = "About SwiftBook"
    case aboutSwiftBook2 = "About SwiftBook 2"
    case showCourses = "Show Courses"
}

class MainViewController: UICollectionViewController {
    
    let userActions = UserAction.allCases

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        switch userAction {
        case .showImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchCourse: fetchCourse()
        case .fetchCourses: fetchCourses()
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutUsWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourses" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.fetchCourses()
        }
    }

    // MARK: - Private Methods
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "You can see the results in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchCourse() {
        guard let url = URL(string: Link.courseURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let course = try JSONDecoder().decode(Course.self, from: data)
                self.successAlert()
                print(course)
            } catch let error {
                self.failedAlert()
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchCourses() {
        guard let url = URL(string: Link.coursesURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                self.successAlert()
                print(courses)
            } catch let error {
                self.failedAlert()
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchInfoAboutUs() {
        guard let url = URL(string: Link.aboutUsURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let aboutUs = try JSONDecoder().decode(AboutUs.self, from: data)
                self.successAlert()
                print(aboutUs)
            } catch let error {
                self.failedAlert()
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchInfoAboutUsWithEmptyFields() {
        guard let url = URL(string: Link.aboutUsURL2.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let aboutUs = try JSONDecoder().decode(AboutUs.self, from: data)
                self.successAlert()
                print(aboutUs)
            } catch let error {
                self.failedAlert()
                print(error)
            }
        }.resume()
    }
}
