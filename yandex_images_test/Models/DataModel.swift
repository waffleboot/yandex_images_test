
import Foundation

class Item : NSObject, NSCoding {
    
    class Token : NSObject { }

    var date: Date!
    var name: String!
    var image: Data?
    @objc let token = Token()
    init(date: Date, name: String) {
        super.init()
        self.date = date
        self.name = name
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        date = aDecoder.decodeObject(forKey: "date") as! Date
        name = aDecoder.decodeObject(forKey: "name") as! String
        if let imageData = aDecoder.decodeObject(forKey: "image") as? Data {
            self.image = imageData
        }
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}

protocol DataModelDelegate : class {
    func updateViewModelWithItem(_:Item)
}

class DataModel {

    weak var delegate: DataModelDelegate?
    
    private let imageSource = ImageSource()

    init() {
        imageSource.delegate = self
    }

    var items: [Item] = DataStorage.load() {
        didSet {
            DataStorage.save(items)
        }
    }

    func addItem() {
        let item = Item(date: Date(), name: randomName())
        needImageForItem(item)
        items.append(item)
    }

    func updateName(forRowAt row: Int) {
        items[row].name = newNameInsteadOf(items[row].name)
        DataStorage.save(items)
    }
    
    func needImageForItem(_ item: Item) {
        imageSource.updateImage(for: item);
    }
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

}

extension DataModel : ImageSourceDelegate {
    
    func imageSource(_ imageSource: ImageSource, didUpdate item: Item, withImageData imageData: Data) {
        item.image = imageData;
        DataStorage.save(items)
        OperationQueue.main.addOperation {
            self.delegate?.updateViewModelWithItem(item)
        }
    }
    
}

fileprivate let kNames = [
    "Ekoocwood",
    "Qaumery",
    "Igaaginia",
    "Agrauding",
    "Odremont",
    "Shona",
    "Isrark",
    "Ylalo",
    "Gukrose",
    "Qupholk"]

fileprivate func randomName() -> String {
    return kNames[Int(arc4random_uniform(UInt32(kNames.count)))];
}

fileprivate func newNameInsteadOf(_ oldname: String) -> String {
    var newname: String
    repeat {
        newname = randomName()
    } while (oldname == newname)
    return newname
}
