
import Foundation

class ViewControllerModelImpl: ViewControllerModel {
    
    private let dataModel: DataModel
    
    init(_ dataModel: DataModel) {
        self.dataModel = dataModel
    }

    var cellsCount: Int {
        return dataModel.items.count
    }

    func clickOnClearButton() {
        dataModel.items = [Item]()
    }

    func clickOnAddButton() {
        dataModel.addImage()
    }
    
    func clickOnRow(_ row: Int) {
        dataModel.updateName(forRowAt: row)
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
