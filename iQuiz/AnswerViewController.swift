//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Jia Wu on 5/12/25.
//
import UIKit
import Foundation
class AnswerViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!

    var quiz: Quiz!
    var currentIndex: Int!
    var userChoice: Int!
    var correctAnswer: Int!
    var score: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG - quiz:", quiz?.title ?? "nil")
           print("DEBUG - currentIndex:", currentIndex ?? -1)
           print("DEBUG - userChoice:", userChoice ?? -1)
           print("DEBUG - correctAnswer:", correctAnswer ?? -1)
           print("DEBUG - score:", score ?? -1)
        guard let quiz = quiz else {
            print("❌ quiz is nil")
            return
        }
        guard let currentIndex = currentIndex else {
            print("❌ currentIndex is nil")
            return
        }
           let question = quiz.questions[currentIndex]
           print("DEBUG - question text:", question.question)
           print("DEBUG - choices:", question.choices)

           questionLabel.text = question.question
           resultLabel.text = userChoice == correctAnswer ? "✅ Correct!" : "❌ Wrong"
           correctAnswerLabel.text = "Correct Answer: \(question.choices[correctAnswer])"

           addSwipeGestures()
        
        addSwipeGestures()
    }

    @IBAction func nextTapped(_ sender: Any) {
        if currentIndex + 1 < quiz.questions.count {
            performSegue(withIdentifier: "nextQuestion", sender: nil)
        } else {
            performSegue(withIdentifier: "toFinished", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextQuestion",
           let dest = segue.destination as? QuestionViewController {
            dest.quiz = quiz
            dest.currentIndex = currentIndex + 1
            dest.score = score
        } else if segue.identifier == "toFinished",
                  let dest = segue.destination as? FinishedViewController {
            dest.score = score
            dest.total = quiz.questions.count
        }
    }

    func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextTapped))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
