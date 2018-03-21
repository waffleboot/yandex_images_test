
import UIKit

protocol ViewControllerModel {
    var count: Int { get }
    func clear()
    func addImage()
    func cellViewModel(forRowAt row: Int) -> CellView.Model
}

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: ViewControllerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func addImage() {
        model.addImage()
        tableView.reloadData()
    }
    
    @IBAction private func clear() {
        model.clear()
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        cell.viewModel = model.cellViewModel(forRowAt: indexPath.row)
        return cell
    }

}
