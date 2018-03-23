
import Foundation
import UIKit

class Item : NSObject, NSCoding {
    var date: Date!
    var name: String!
    var image: Data?
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
    func updateViewModel()
}

class DataModel {

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    weak var delegate: DataModelDelegate?
    
    private let imageDownloader = ImageDownloader()
    
    var items: [Item] = DataStorage.load() {
        didSet {
            DataStorage.save(items)
        }
    }

    func addImage() {
        let item = Item(date: Date(), name: randomName())
        item.image = UIImagePNGRepresentation(UIImage(named: "nature")!)
        items.append(item)
    }

    func updateName(forRowAt row: Int) {
        items[row].name = newNameInsteadOf(items[row].name)
        DataStorage.save(items)
    }
    
    private func newNameInsteadOf(_ oldname: String) -> String {
        var newname: String
        repeat {
            newname = randomName()
        } while (oldname == newname)
        return newname
    }
    
    func download(forItem item: Item) {
        imageDownloader.downloadItem(item)
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
