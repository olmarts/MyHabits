import UIKit

extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITextField {
    
    // Устанавливает внутренние отступы текста для красоты.
    func setPadding(left: CGFloat, right: CGFloat? = nil) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        if let rightPadding = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    func placeholderColor(_ color: UIColor?, alpha: Double = 0.6 ) {
        let color: UIColor = color ?? (self.textColor ?? .black)
        let alpha =  alpha < 1 ?  alpha : 1.0
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(alpha),
            NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}


