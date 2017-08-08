import UIKit

extension UILabel {
    func set(text: String, withLineHeight lineHeight: CGFloat) {
        let attributedText = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        attributedText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
        self.attributedText = attributedText
    }
}
