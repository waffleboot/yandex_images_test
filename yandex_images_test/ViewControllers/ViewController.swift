
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
    func addRow(_: Int)
    func updateRow(_: Int)
}

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: ViewControllerModel! {
        didSet {
            model.delegate = self
        }
    }
    
    private var newRow: Int?
    
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
    
    func addRow(_ row: Int) {
        newRow = row
        tableView.beginUpdates()
        if row == 0 {
            tableView.insertSections(IndexSet(integer: 0), with: .none)
        }
        tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .none)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: false)
        newRow = nil
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
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

    func numberOfSections(in tableView: UITableView) -> Int {
        if model.cellsCount > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            label.text = "No items, click on Plus button"
            label.textColor = UIColor.black
            label.textAlignment = .center
            tableView.separatorStyle = .none
            tableView.backgroundView = label
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cellsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        if let newRow = self.newRow, indexPath.row == newRow { } else {
            cell.viewModel = model.cellViewModel(forRowAt: indexPath.row)
        }
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.clickOnRow(indexPath.row)
    }
    
}
