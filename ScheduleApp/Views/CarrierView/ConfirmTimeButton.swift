import SwiftUI

// MARK: - ConfirmTimeButton

struct ConfirmTimeButton: View {
    
    // MARK: - Properties
    
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        button
            .padding(.horizontal)
            .padding(.bottom, 24)
    }
    
    // MARK: - Views
    
    private var button: some View {
        Button(action: action) {
            Text("Уточнить время")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color("blue"))
                .cornerRadius(16)
        }
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
