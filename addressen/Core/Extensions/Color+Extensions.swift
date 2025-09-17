import SwiftUI

extension Color {
    static let appAccent = Color(
        light: Color(red: 0, green: 50/255, blue: 127/255, opacity: 0.94),
        dark: Color(red: 30/255, green: 80/255, blue: 180/255, opacity: 0.94)
    )
    
    static let searchBackground = Color(
        light: Color(red: 118/255, green: 118/255, blue: 128/255, opacity: 0.12),
        dark: Color(red: 142/255, green: 142/255, blue: 147/255, opacity: 0.16)
    )
    
    static let circleBackground = Color(
        light: Color(red: 118/255, green: 118/255, blue: 128/255, opacity: 0.12),
        dark: Color(red: 142/255, green: 142/255, blue: 147/255, opacity: 0.16)
    )
    
    static let postalCodeText = Color(
        light: Color(red: 153/255, green: 153/255, blue: 153/255),
        dark: Color(red: 174/255, green: 174/255, blue: 178/255)
    )
    
    static let separatorColor = Color(
        light: Color(red: 198/255, green: 197/255, blue: 201/255),
        dark: Color(red: 84/255, green: 84/255, blue: 88/255, opacity: 0.6)
    )
    
    static let searchPlaceholder = Color(
        light: Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6),
        dark: Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)
    )
}

extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}