import SwiftUI

// MARK: - ConfirmTimeButton

struct ConfirmTimeButton: View {
    
    // MARK: - Properties
    
    let action: (() -> Void)?
    var showCircle: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        if let action = action {
            Button(action: action) {
                button
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        } else {
            button
                .padding(.horizontal)
                .padding(.bottom, 24)
        }
    }
    
    // MARK: - Views
    
    private var button: some View {
        Text(Constants.ConfirmTimeButton.timeButton)
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.white)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                if showCircle {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: -94.5, y: 0)
                }
            }
            .background(Color("blue"))
            .cornerRadius(16)
    }
}

// MARK: - ConfirmTimeButton_Preview

#Preview {
    ConfirmTimeButton {
        print("Кнопка нажата")
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
