
import UIKit

enum Signal {
    case UpdateTable
    case UpdateRow(Int)
}

protocol ViewControllerModel {
    var cellsCount: Int { get }
    var updateViewController: ((Signal) -> ())! { get set }
    func clickOnRow(_: Int);
    func clickOnAddButton()
    func clickOnClearButton()
    func cellViewModel(forRowAt: Int) -> CellView.Model
}

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: ViewControllerModel! {
        didSet {
            model.updateViewController = { [weak self] in
                self?.updateViewController($0)
            }
        }
    }
    
    private func updateViewController(_ signal: Signal) {
        switch signal {
        case .UpdateTable:
            tableView.reloadData()
        case .UpdateRow(let row):
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func clear() {
        model.clickOnClearButton()
    }
    
    @IBAction private func addImage() {
        model.clickOnAddButton()
    }
    
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cellsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        cell.viewModel = model.cellViewModel(forRowAt: indexPath.row)
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.clickOnRow(indexPath.row)
    }
    
}
