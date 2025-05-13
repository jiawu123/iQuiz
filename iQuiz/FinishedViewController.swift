import UIKit

class FinishedViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    var score: Int!
    var total: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        let percentage = Double(score) / Double(total)

        var message = ""
        switch percentage {
        case 1.0:
            message = "🎉 Perfect!"
        case 0.7...0.99:
            message = "👍 Almost!"
        default:
            message = "🧐 Try again!"
        }

        resultLabel.text = "\(message)\nYou got \(score!) out of \(total!) correct."
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        // Return to quiz list
        navigationController?.popToRootViewController(animated: true)
    }
}
