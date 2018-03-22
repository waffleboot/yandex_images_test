
import UIKit

protocol ViewControllerModel {
    var cellsCount: Int { get }
    func clickOnClearButton()
    func clickOnAddButton()
    func clickOnRow(_: Int);
    func cellViewModel(forRowAt: Int) -> CellView.Model
}

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var model: ViewControllerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func addImage() {
        model.clickOnAddButton()
        tableView.reloadData()
    }
    
    @IBAction private func clear() {
        model.clickOnClearButton()
        tableView.reloadData()
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
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
}
