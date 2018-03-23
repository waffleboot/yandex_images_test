
import UIKit

class CellView: UITableViewCell {

    struct ViewModel {
        let date: String
        let name: String
        let imageData: Data?
    }

    var viewModel : ViewModel! {
        didSet {
            if let imageData = viewModel.imageData {
                siteImage.image = UIImage(data: imageData)
            } else {
                siteImage.image = nil
            }
            dateLabel.text = viewModel.date
            nameLabel.text = viewModel.name
        }
    }
    
    @IBOutlet var siteImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func prepareForReuse() {
        siteImage.image = nil
        dateLabel.text = nil
        nameLabel.text = nil
    }

}

