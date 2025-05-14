//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Jia Wu on 5/14/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var intervalTextField: UITextField! // Optional

    let defaultURL = "http://tednewardsandbox.site44.com/questions.json"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load stored settings
        let storedURL = UserDefaults.standard.string(forKey: "quizURL") ?? defaultURL
        urlTextField.text = storedURL

        intervalTextField.text = "\(UserDefaults.standard.integer(forKey: "refreshInterval"))"
    }

    @IBAction func checkNowTapped(_ sender: UIButton) {
        let urlString = urlTextField.text ?? defaultURL
           UserDefaults.standard.set(urlString, forKey: "quizURL")

           //  Validate and store interval safely
        if let input = intervalTextField.text, let interval = Int(input), interval > 0 {
               UserDefaults.standard.set(interval, forKey: "refreshInterval")
               print("✅ Saved interval: \(interval)")
           } else {
               showAlert("⚠️ Please enter a valid interval (number > 0)")
               return
           }

           QuizFetcher.fetchQuizzes(from: urlString) { quizzes in
               if let quizzes = quizzes {
                   DispatchQueue.main.async {
                       QuizManager.shared.quizzes = quizzes
                       self.showAlert("✅ Quizzes updated.")
                   }
               } else {
                   DispatchQueue.main.async {
                       self.showAlert("❌ Failed to fetch quizzes.")
                   }
               }
           }
       }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Settings", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
