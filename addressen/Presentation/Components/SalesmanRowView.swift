import SwiftUI

struct SalesmanRowView: View {
    let salesman: Salesman
    let isExpanded: Bool
    let onToggleExpansion: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                CircleInitialView(text: salesman.firstLetter)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(salesman.name)
                        .font(.bodyRegular16)
                        .foregroundColor(.primary)
                    
                    if isExpanded {
                        Text(salesman.formattedAreas)
                            .font(.captionRegular14)
                            .foregroundColor(.postalCodeText)
                            .fixedSize(horizontal: false, vertical: true)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .top)),
                                removal: .opacity.combined(with: .move(edge: .top))
                            ))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                        .animation(.easeInOut(duration: AppConfiguration.shared.animationDuration), value: isExpanded)
                    Spacer()
                }
                .frame(height: 40)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: AppConfiguration.shared.animationDuration)) {
                    onToggleExpansion()
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
            .accessibilityHint(isExpanded ? LocalizedString.accessibilityCollapseHint : LocalizedString.accessibilityExpandHint)
            
            Divider()
                .background(Color.separatorColor)
                .padding(.leading, 16)
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct CircleInitialView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.circleBackground)
                .overlay(
                    Circle()
                        .stroke(Color(UIColor.systemGray3), lineWidth: 1)
                )
            
            Text(text)
                .font(.bodyRegular16)
                .foregroundColor(.primary)
        }
        .frame(width: 40, height: 40)
    }
}