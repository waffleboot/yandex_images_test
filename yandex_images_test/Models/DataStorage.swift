
import Foundation

struct DataStorage {

    static func load() -> [Item] {
        guard let data = UserDefaults.standard.object(forKey: "items") as? Data else {
            print("Strange UserDefaults error");
            return [Item]()
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! [Item]
    }
    
    static func save(_ items: [Item]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: items)
        UserDefaults.standard.set(data, forKey: "items")
    }
    
}
