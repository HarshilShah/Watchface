import UIKit

extension UIFont {
    
    class func smallCapsSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor
        
        let smallLettersToSmallCapsAttribute: [UIFontDescriptor.FeatureKey: Any] = [
            .featureIdentifier: kLowerCaseType,
            .typeIdentifier: kLowerCaseSmallCapsSelector ]
        
        let capitalLettersToSmallCapsAttribute: [UIFontDescriptor.FeatureKey: Any] = [
            .featureIdentifier: kUpperCaseType,
            .typeIdentifier: kUpperCaseSmallCapsSelector ]
        
        let newDescriptor = descriptor.addingAttributes([
            .featureSettings: [smallLettersToSmallCapsAttribute,
                               capitalLettersToSmallCapsAttribute]
        ])
        
        return UIFont(descriptor: newDescriptor, size: size)
        
    }
    
    class func centeredColonSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor
        
        let centeredColonAttribute: [UIFontDescriptor.FeatureKey: Any] = [
            .featureIdentifier: kStylisticAlternativesType,
            .typeIdentifier: kStylisticAltThreeOnSelector ]
        
        let newDescriptor = descriptor.addingAttributes( [
            .featureSettings: [centeredColonAttribute]
        ])
        
        return UIFont(descriptor: newDescriptor, size: size)
    }
    
}
