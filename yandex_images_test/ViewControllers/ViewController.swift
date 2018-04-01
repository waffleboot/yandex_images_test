
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: DataModel! {
        didSet {
            model.delegate = self
        }
    }
    
    private var newRow: Int?
    private let cellConfigurator = CellViewConfigurator()
    
    @IBAction private func clear() {
        model.items = [Item]()
        updateTable()
    }
    
    @IBAction private func addImage() {
        model.addItem()
        addRow(model.items.count-1)
    }
    
    override func didReceiveMemoryWarning() {
        cellConfigurator.didReceiveMemoryWarning()
    }
    
}

extension ViewController {
    
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
    
    func updateRow(_ indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }

    func updateTable() {
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if model.items.count > 0 {
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
        return model.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        if let newRow = newRow, indexPath.row == newRow { } else {

            let item = model.items[indexPath.row]
            if item.image == nil {
                model.needImageForItem(item)
            }
            cellConfigurator.configure(cell, forItem: item)

        }
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.updateName(forRowAt: indexPath.row)
        updateRow(indexPath)
    }
    
}

extension ViewController: DataModelDelegate {

    func didUpdateItem(_ item: Item) {
        let visibleRows = tableView.indexPathsForVisibleRows?.map { $0.row }
        guard let row = visibleRows?.first(where: {
            model.items[$0] == item
        }) else { return }
        updateRow(IndexPath(row: row, section: 0))
    }

}
