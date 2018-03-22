
import UIKit

protocol ViewControllerModel {
    var cellsCount: Int { get }
    func clickOnRow(_: Int);
    func clickOnAddButton()
    func clickOnClearButton()
    func cellViewModel(forRowAt: Int) -> CellView.Model
    weak var delegate: ViewControllerDelegate! { get set }
}

protocol ViewControllerDelegate : class {
    func updateTable()
    func updateRow(_: Int)
}

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: ViewControllerModel! {
        didSet {
            model.delegate = self
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

extension ViewController: ViewControllerDelegate {
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func updateRow(_ row: Int) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        tableView.endUpdates()
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
