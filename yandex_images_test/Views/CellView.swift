
import UIKit

class CellView: UITableViewCell {

    struct Model {
        let date: String
        let name: String
        let imageData: Data?
    }

    var viewModel : Model! {
        didSet {
            if let imageData = viewModel.imageData {
                siteImage?.image = UIImage(data: imageData)
            } else {
                siteImage?.image = nil
            }
            dateLabel.text = viewModel.date
            nameLabel.text = viewModel.name
        }
    }
    
    @IBOutlet private var siteImage: UIImageView?
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

}
