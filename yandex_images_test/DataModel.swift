
import Foundation

class Item : NSObject, NSCoding {
    var date: String!
    var name: String!
    var image: Data?
    init(date: String, name: String) {
        super.init()
        self.date = date
        self.name = name
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        date = aDecoder.decodeObject(forKey: "date") as! String
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

class DataModel {

    var items: [Item] = DataStorage.load() {
        didSet {
            DataStorage.save(items)
        }
    }

    func addImage() {
        items.append(Item(date: "date", name: randomName()))
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
