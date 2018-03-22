
import Foundation

class ViewControllerModelImpl: ViewControllerModel {
    
    private let dataModel: DataModel
    
    init(_ dataModel: DataModel) {
        self.dataModel = dataModel
    }

    var count: Int {
        return dataModel.items.count
    }

    func clear() {
        dataModel.items = [Item]()
    }

    func addImage() {
        dataModel.addImage()
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
