import UIKit

class CustomCheckbox: UIButton {
    
    var checkedImage: UIImage? = nil
    var uncheckedImage: UIImage? = nil
    var bgColors: (checked: UIColor?, unchecked: UIColor?)
    
    var isChecked: Bool = false {
        didSet {
            self.backgroundColor = self.isChecked ? self.bgColors.checked : self.bgColors.unchecked
            self.setImage(self.isChecked ? self.checkedImage : self.uncheckedImage, for: .normal)
        }
    }
    
    func toggle() {
        self.isChecked = self.isChecked ? false : true
    }
}
