import SwiftUI

struct SearchFieldView: View {
    @Binding var text: String
    let placeholder: String
    let onClear: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.searchPlaceholder)
                .font(.system(size: 16))
            
            TextField(placeholder, text: $text)
                .font(.bodyRegular16)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isFocused)
                .keyboardType(.numberPad)
                .foregroundColor(.primary)
                .accessibilityLabel(LocalizedString.searchAccessibilityLabel)
                .accessibilityHint(LocalizedString.searchAccessibilityHint)
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > 5 {
                        text = String(newValue.prefix(5))
                    }
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.searchPlaceholder)
                        .font(.system(size: 16))
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel(LocalizedString.searchClearAccessibilityLabel)
                .accessibilityHint(LocalizedString.searchClearAccessibilityHint)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.searchBackground)
        .cornerRadius(10)
        .onAppear {
            isFocused = false
        }
    }
}
