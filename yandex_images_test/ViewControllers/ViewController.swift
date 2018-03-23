
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: ViewControllerModel! {
        didSet {
            model.delegate = self
        }
    }
    
    private var newRow: Int?
    
    private let imagesCache = NSCache<Item.Token,UIImage>()
    
    @IBAction private func clear() {
        model.clickOnClearButton()
    }
    
    @IBAction private func addImage() {
        model.clickOnAddButton()
    }
    
    override func didReceiveMemoryWarning() {
        CellView.imagesCache.removeAllObjects()
    }
    
}

extension ViewController: ViewControllerModelDelegate {
    
    func addRow(_ row: Int) {
        
        // to fade in new row after scrolling: add as empty row, scroll to new row, reload with valid content
        
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
    
    func visibleRows() -> [Int]? {
        return tableView.indexPathsForVisibleRows?.map { $0.row }
    }
    
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if model.rowsCount > 0 {
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
        return model.rowsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        if let newRow = self.newRow, indexPath.row == newRow { } else {
            cell.configure(model.cellViewModel(forRowAt: indexPath.row))
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
