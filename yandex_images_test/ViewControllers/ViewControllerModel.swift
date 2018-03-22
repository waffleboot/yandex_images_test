
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
        delegate.updateTable()
    }
    
    func clickOnRow(_ row: Int) {
        dataModel.updateName(forRowAt: row)
        delegate.updateRow(row)
    }

    func cellViewModel(forRowAt row: Int) -> CellView.Model {
        return CellView.Model(item: dataModel.items[row])
    }

}

extension ViewControllerModelImpl : DataModelDelegate {

    func updateViewModel() {
        delegate.updateTable()
    }
    
}

extension CellView.Model {
    init(item: Item) {
        date = item.date
        name = item.name
        imageData = item.image
    }
}
