
import Foundation

class Item : NSObject, NSCoding {
    var date: String!
    var name: String!
    init(date: String, name: String) {
        super.init()
        self.date = date
        self.name = name
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(name, forKey: "name")
    }
}

class DataModel {
    
    var items: [Item] = DataStorage.load() {
        didSet {
            DataStorage.save(items)
        }
    }

}
