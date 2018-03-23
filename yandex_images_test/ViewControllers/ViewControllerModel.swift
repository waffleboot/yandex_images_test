
import Foundation

class ViewControllerModelImpl: ViewControllerModel {
    
    weak var delegate: ViewControllerDelegate!
    
    private let dataModel: DataModel

    init(_ dataModel: DataModel) {
        self.dataModel = dataModel
        self.dataModel.delegate = self
    }
    
    var cellsCount: Int {
        return dataModel.items.count
    }

    func clickOnClearButton() {
        dataModel.items = [Item]()
        delegate.updateTable()
    }

    func clickOnAddButton() {
        dataModel.addImage()
        delegate.addRow(dataModel.items.count-1)
    }
    
    func clickOnRow(_ row: Int) {
        dataModel.updateName(forRowAt: row)
        delegate.updateRow(row)
    }

    func cellViewModel(forRowAt row: Int) -> CellView.Model {
        let item = dataModel.items[row]
        let date = dataModel.dateFormatter.string(from: item.date)
        return CellView.Model(date: date, name: item.name, imageData: item.image)
    }

}

extension ViewControllerModelImpl : DataModelDelegate {

    func updateViewModel() {
        delegate.updateTable()
    }
    
}

