//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Jia Wu on 5/12/25.
//

import Foundation
import UIKit
class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var quiz: Quiz!
    var currentIndex: Int!
    var score: Int!
    var selectedAnswer: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG - quiz: \(quiz?.title ?? "nil")")
            print("DEBUG - currentIndex: \(String(describing: currentIndex))")
            print("DEBUG - questions count: \(quiz?.questions.count ?? -1)")

        questionLabel.text = quiz.questions[currentIndex].question
        tableView.dataSource = self
        tableView.delegate = self
        addSwipeGestures()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.questions[currentIndex].choices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choiceCell", for: indexPath)
        cell.textLabel?.text = quiz.questions[currentIndex].choices[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswer = indexPath.row
    }

    @IBAction func submitTapped(_ sender: Any) {
        guard let choice = selectedAnswer else { return }
        performSegue(withIdentifier: "toAnswer", sender: choice)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswer",
           let dest = segue.destination as? AnswerViewController,
           let selected = sender as? Int {
            dest.quiz = quiz
            dest.currentIndex = currentIndex
            dest.userChoice = selected
            dest.correctAnswer = quiz.questions[currentIndex].correctIndex
            dest.score = score + (selected == quiz.questions[currentIndex].correctIndex ? 1 : 0)

            print("✅ Passed quiz: \(quiz.title)")
            print("✅ Passed question: \(quiz.questions[currentIndex].question)")
        }
    }
    func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc func handleSwipeRight() {
        submitTapped(UIButton())
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
