//
//  MainViewController.swift
//  NetworkingApp
//
//  Created by Masaie on 7/8/22.
//

import UIKit



enum UserAction: String, CaseIterable {
    case showImage = "Show Image"
    case fetchCourse = "Fetch Course"
    case fetchCourses = "Fetch Courses"
    case aboutSwiftBook = "About SwiftBook"
    case aboutSwiftBook2 = "About SwiftBook 2"
    case showCourses = "Show Courses"
    case postRequestWithDict = "POST RQST with Dict"
    case postRequestWithModel = "POST RQST with Model"
    case alamofireGet = "Alamofire GET"
    case alamofirePost = "Alamofire POST"
}

class MainViewController: UICollectionViewController {
    
    let userActions = UserAction.allCases

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
    
        let userAction = userActions[indexPath.item]
        cell.userActionLabel.text = userAction.rawValue
    
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
        case .postRequestWithDict: postRequestWithDict()
        case .postRequestWithModel: postRequestWithModel()
        case .alamofireGet: performSegue(withIdentifier: "alamofireGet", sender: nil)
        case .alamofirePost: performSegue(withIdentifier: "alamofirePost", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showImage" {
            let coursesVC = segue.destination as! CoursesViewController
            switch segue.identifier {
            case "showCourses": coursesVC.fetchCourses()
            case "alamofireGet": coursesVC.alamofireGetButtonPressed()
            case "alamofirePost": coursesVC.alamofirePostButtonPressed()
            default: break
            }
        }
    }

    // MARK: - Alert Controller
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
        NetworkManager.shared.fetch(dataType: Course.self, from: Link.courseURL.rawValue) { result in
            switch result {
            case .success(let course):
                self.successAlert()
                print(course)
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
    
    private func fetchCourses() {
        NetworkManager.shared.fetch(dataType: [Course].self, from: Link.coursesURL.rawValue) { result in
            switch result {
            case .success(let courses):
                self.successAlert()
                for course in courses {
                    print("Course: \(course.name ?? "")")
                }
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
        
    }
    
    private func fetchInfoAboutUs() {
        NetworkManager.shared.fetch(dataType: WebsiteDescription.self, from: Link.aboutUsURL.rawValue) { result in
            switch result {
            case .success(let websiteDescription):
                self.successAlert()
                print(websiteDescription)
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
    
    private func fetchInfoAboutUsWithEmptyFields() {
        NetworkManager.shared.fetch(dataType: WebsiteDescription.self, from: Link.aboutUsURL2.rawValue) { result in
            switch result {
            case .success(let websiteDescription):
                self.successAlert()
                print(websiteDescription)
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
    
    private func postRequestWithDict() {
        let course = [
            "name": "Networking",
            "imageUrl": "imageURL",
            "numberOfLessons": "10",
            "numberOfTests": "5"
        ]
        NetworkManager.shared.postRequest(with: course, to: Link.postRequest.rawValue) { result in
            switch result {
            case .success(let json):
                print(json)
                self.successAlert()
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
    
    private func postRequestWithModel() {
        let course = Course(
            name: "Notifications",
            imageUrl: Link.courseImageURL.rawValue,
            numberOfLessons: 10,
            numberOfTests: 5
        )
        
        NetworkManager.shared.postRequest(with: course, to: Link.postRequest.rawValue) { result in
            switch result {
            case .success(let course):
                print(course)
                self.successAlert()
            case .failure(let error):
                print(error)
                self.failedAlert()
            }
        }
    }
}
