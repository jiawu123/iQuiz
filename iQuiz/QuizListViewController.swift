//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Jia Wu on 5/5/25.
//

import UIKit


class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Quiz Data
    let quizzes: [Quiz] = [
        Quiz(
            title: "Mathematics",
            description: "Test your math skills!",
            iconName: "math_icon",
            questions: [
                QuizQuestion(question: "What is 8 + 5?", choices: ["12", "13", "14", "15"], correctIndex: 1),
                QuizQuestion(question: "What’s the square root of 64?", choices: ["6", "8", "10", "12"], correctIndex: 1),
                QuizQuestion(question: "Which is a prime number?", choices: ["4", "9", "13", "15"], correctIndex: 2)
            ]
        ),
        Quiz(
            title: "Marvel Super Heroes",
            description: "How well do you know them?",
            iconName: "marvel_icon",
            questions: [
                QuizQuestion(question: "Who is Iron Man?", choices: ["Steve Rogers", "Tony Stark", "Bruce Banner", "Peter Parker"], correctIndex: 1),
                QuizQuestion(question: "Who can lift Thor’s hammer?", choices: ["Loki", "Hulk", "Captain America", "Iron Man"], correctIndex: 2),
                QuizQuestion(question: "What is Spider-Man’s real name?", choices: ["Peter Parker", "Clark Kent", "Barry Allen", "Bruce Wayne"], correctIndex: 0)
            ]
        ),
        Quiz(
            title: "Science",
            description: "Explore science trivia!",
            iconName: "science_icon",
            questions: [
                QuizQuestion(question: "What planet is known as the Red Planet?", choices: ["Earth", "Venus", "Mars", "Jupiter"], correctIndex: 2),
                QuizQuestion(question: "What gas do plants absorb?", choices: ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"], correctIndex: 1),
                QuizQuestion(question: "What is H2O?", choices: ["Oxygen", "Water", "Salt", "Hydrogen"], correctIndex: 1)
            ]
        )
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "iQuiz"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
    }

    // MARK: - TableView
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = quizzes[indexPath.row]
        performSegue(withIdentifier: "toQuestion", sender: selectedQuiz)
    }

    // MARK: - Settings
    @objc func settingsTapped() {
        let alert = UIAlertController(title: nil, message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestion",
           let questionVC = segue.destination as? QuestionViewController,
           let selectedQuiz = sender as? Quiz {
            questionVC.quiz = selectedQuiz
            questionVC.currentIndex = 0
            questionVC.score = 0
        }
    }
}
