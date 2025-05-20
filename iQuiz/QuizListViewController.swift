import UIKit
import Network

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var quizzes: [Quiz] = []
    var refreshTimer: Timer?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        self.title = "iQuiz"

        // Settings button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )

        // Pull to refresh
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshQuizzes), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let sharedQuizzes = QuizManager.shared.quizzes {
            self.quizzes = sharedQuizzes
            self.tableView.reloadData()
        }
        startRefreshTimer()
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = quizzes[indexPath.row]
        performSegue(withIdentifier: "toQuestion", sender: selectedQuiz)
    }

    // MARK: - Pull to Refresh
    @objc func refreshQuizzes() {
        let url = UserDefaults.standard.string(forKey: "quizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        isNetworkAvailable { isAvailable in
            if !isAvailable {
                self.showAlert("No internet. Pull failed.")
                self.refreshControl.endRefreshing()
                return
            }
            QuizFetcher.fetchQuizzes(from: url) { quizzes in
                DispatchQueue.main.async {
                    if let quizzes = quizzes {
                        QuizManager.shared.quizzes = quizzes
                        self.quizzes = quizzes
                        self.tableView.reloadData()
                    } else {
                        self.showAlert("Failed to fetch quiz data.")
                    }
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    // MARK: - Settings
    @objc func settingsTapped() {
        performSegue(withIdentifier: "toSettings", sender: self)
    }

    // MARK: - Timer
    func startRefreshTimer() {
        refreshTimer?.invalidate()
        let interval = UserDefaults.standard.integer(forKey: "refreshInterval")
        guard interval > 0 else { return }

        refreshTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let url = UserDefaults.standard.string(forKey: "quizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
            QuizFetcher.fetchQuizzes(from: url) { quizzes in
                if let quizzes = quizzes {
                    DispatchQueue.main.async {
                        QuizManager.shared.quizzes = quizzes
                        self.quizzes = quizzes
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Alert Helper
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
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

// MARK: - Network Check
func isNetworkAvailable(completion: @escaping (Bool) -> Void) {
    let monitor = NWPathMonitor()
    monitor.pathUpdateHandler = { path in
        monitor.cancel()
        DispatchQueue.main.async {
            completion(path.status == .satisfied)
        }
    }
    let queue = DispatchQueue(label: "NetworkMonitor")
    monitor.start(queue: queue)
}
