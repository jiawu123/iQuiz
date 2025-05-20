import Foundation

class QuizFetcher {
    static let localFileName = "quizzes.json"
    
    // MARK: - Main Fetch Logic
    static func fetchQuizzes(from urlString: String, completion: @escaping ([Quiz]?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(loadFromLocal())
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("⚠️ No data from network. Loading from local.")
                completion(loadFromLocal())
                return
            }
            
            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                saveToLocal(data: data)
                completion(quizzes)
            } catch {
                print("❌ JSON decode error:", error)
                completion(loadFromLocal())
            }
        }
        task.resume()
    }
    
    // MARK: - Save raw Data to local
    private static func saveToLocal(data: Data) {
        if let url = getDocumentsDirectory()?.appendingPathComponent(localFileName) {
            do {
                try data.write(to: url)
                print("✅ Saved quizzes to local file.")
            } catch {
                print("❌ Failed to write data to disk:", error)
            }
        }
    }
    
    // MARK: - Load Data from local
    private static func loadFromLocal() -> [Quiz]? {
        if let url = getDocumentsDirectory()?.appendingPathComponent(localFileName),
           let data = try? Data(contentsOf: url) {
            return try? JSONDecoder().decode([Quiz].self, from: data)
        }
        return nil
    }
    
    // MARK: - File path
    private static func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    // MARK: - Extra helper (optional)
    static func saveQuizzesToDisk(_ quizzes: [Quiz]) {
        let fileURL = getLocalFileURL()
        do {
            let data = try JSONEncoder().encode(quizzes)
            try data.write(to: fileURL)
            print("✅ Quizzes saved with helper.")
        } catch {
            print("❌ Failed to save quizzes to disk:", error)
        }
    }

    static func loadQuizzesFromDisk() -> [Quiz]? {
        let fileURL = getLocalFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Quiz].self, from: data)
        } catch {
            print("⚠️ Failed to load quizzes from disk:", error)
            return nil
        }
    }

    private static func getLocalFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(localFileName)
    }
}
