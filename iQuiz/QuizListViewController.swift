//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Jia Wu on 5/5/25.
//

import UIKit
class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    struct Quiz {
        let title: String
        let description: String
        let iconName: String
    }

    let quizzes = [
        Quiz(title: "Mathematics", description: "Test your math skills!", iconName: "math_icon"),
        Quiz(title: "Marvel Super Heroes", description: "How well do you know them?", iconName: "marvel_icon"),
        Quiz(title: "Science", description: "Explore science trivia!", iconName: "science_icon")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Title"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell
        let quiz = quizzes[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.descriptionLabel.text = quiz.description
        cell.iconImageView.image = UIImage(named: quiz.iconName)
        return cell
    }
    @objc func settingsTapped() {
        let alert = UIAlertController(title: nil, message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
