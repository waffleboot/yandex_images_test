
import UIKit

class CellView: UITableViewCell {

    struct Model {
        let date: String
        let name: String
    }

    var viewModel : Model! {
        didSet {
            dateLabel.text = viewModel.date
            nameLabel.text = viewModel.name
        }
    }
    
    @IBOutlet private var siteImage: UIImageView?
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

}

