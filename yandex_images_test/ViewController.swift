
import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    private struct Item {
        var date: String
        var name: String
    }

    private var data = [Item]()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func addImage() {
        data.append(Item(date: "date", name: "name"))
        tableView.reloadData()
    }
    
    @IBAction private func clear() {
        data = [Item]()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        cell.dateLabel.text = item.date
        cell.nameLabel.text = item.name
        return cell
    }

}
