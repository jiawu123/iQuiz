//
//   QuizFetcher.swift
//  iQuiz
//
//  Created by Jia Wu on 5/14/25.
//

import Foundation

class QuizFetcher {
    static func fetchQuizzes(from urlString: String, completion: @escaping ([Quiz]?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                completion(quizzes)
            } catch {
                print("JSON decode error:", error)
                completion(nil)
            }
        }.resume()
    }
}
