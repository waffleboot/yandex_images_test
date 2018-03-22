
import Foundation

typealias Disposable = () -> ()

class Token {

    let disposable: Disposable
    
    init(_ disposable: @escaping Disposable) {
        self.disposable = disposable
    }
    
    deinit {
        disposable()
    }

}
