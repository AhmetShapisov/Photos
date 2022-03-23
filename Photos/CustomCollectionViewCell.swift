import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photos: UIImageView!
    
}

//import UIKit
//
//class LoanPaymentsTopCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet weak var label: UILabel!
//
//    let selectedLabelColor = UIColor.black
//    let unSelectedLabelColor = UIColor.clear.withAlphaComponent(0.45)
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//    }
//
//    override var isSelected: Bool {
//        didSet {
//            label.textColor = isSelected ? selectedLabelColor : unSelectedLabelColor
//        }
//    }
//}
