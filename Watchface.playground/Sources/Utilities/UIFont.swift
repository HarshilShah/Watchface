import UIKit

extension UIFont {
    
    class func smallCapsSystemFont(ofSize size: CGFloat, weight: CGFloat = UIFontWeightRegular) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor
        
        let smallLettersToSmallCapsAttribute = [
            UIFontFeatureTypeIdentifierKey: kLowerCaseType,
            UIFontFeatureSelectorIdentifierKey: kLowerCaseSmallCapsSelector ]
        
        let capitalLettersToSmallCapsAttribute = [
            UIFontFeatureTypeIdentifierKey: kUpperCaseType,
            UIFontFeatureSelectorIdentifierKey: kUpperCaseSmallCapsSelector ]
        
        let newDescriptor = descriptor
            .addingAttributes( [UIFontDescriptorFeatureSettingsAttribute : [smallLettersToSmallCapsAttribute]] )
            .addingAttributes( [UIFontDescriptorFeatureSettingsAttribute : [capitalLettersToSmallCapsAttribute]] )
        
        return UIFont(descriptor: newDescriptor, size: size)
        
    }
    
}
