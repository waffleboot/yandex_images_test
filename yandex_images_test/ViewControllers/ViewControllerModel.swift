
import Foundation

protocol ViewControllerModel {
    var rowsCount: Int { get }
    func clickOnRow(_: Int);
    func clickOnAddButton()
    func clickOnClearButton()
    func cellViewModel(forRowAt: Int) -> CellView.ViewModel
    weak var delegate: ViewControllerModelDelegate! { get set }
}

protocol ViewControllerModelDelegate : class {
    func updateTable()
    func addRow(_: Int)
    func updateRow(_: Int)
    func visibleRows() -> [Int]?
}

class ViewControllerModelImpl: ViewControllerModel {
    
    weak var delegate: ViewControllerModelDelegate!
    
    private let dataModel: DataModel

    init(_ dataModel: DataModel) {
        self.dataModel = dataModel
        self.dataModel.delegate = self
    }
    
    var rowsCount: Int {
        return dataModel.items.count
    }

    func clickOnClearButton() {
        dataModel.items = [Item]()
        delegate.updateTable()
    }

    func clickOnAddButton() {
        dataModel.addItem()
        delegate.addRow(dataModel.items.count-1)
    }
    
    func clickOnRow(_ row: Int) {
        dataModel.updateName(forRowAt: row)
        delegate.updateRow(row)
    }

    func cellViewModel(forRowAt row: Int) -> CellView.ViewModel {
        let item = dataModel.items[row]
        let date = dataModel.dateFormatter.string(from: item.date)
        if item.image == nil {
            dataModel.needImageForItem(item)
        }
        return CellView.ViewModel(date: date, name: item.name, imageData: item.image)
    }
    
}

extension ViewControllerModelImpl : DataModelDelegate {

    func updateViewModelWithItem(_ item: Item) {
        guard let row = delegate.visibleRows()?.first(where: {
            dataModel.items[$0] == item
        }) else { return }
        delegate.updateRow(row)
    }
    
}

