
import Foundation

class ViewControllerModelImpl: ViewControllerModel {
    
    var updateViewController: ((Signal) -> ())!
    
    private let dataModel: DataModel

    init(_ dataModel: DataModel) {
        self.dataModel = dataModel
        dataModel.updateViewModel = { [weak self] in
            self?.updateViewController(.UpdateTable)
        }
    }
    
    deinit {
        dataModel.updateViewModel = nil
    }

    var cellsCount: Int {
        return dataModel.items.count
    }

    func clickOnClearButton() {
        dataModel.items = [Item]()
        updateViewController(.UpdateTable)
    }

    func clickOnAddButton() {
        dataModel.addImage()
        updateViewController(.UpdateTable)
    }
    
    func clickOnRow(_ row: Int) {
        dataModel.updateName(forRowAt: row)
        updateViewController(.UpdateRow(row))
    }

    func cellViewModel(forRowAt row: Int) -> CellView.Model {
        return CellView.Model(item: dataModel.items[row])
    }

}

extension CellView.Model {
    init(item: Item) {
        date = item.date
        name = item.name
        imageData = item.image
    }
}
