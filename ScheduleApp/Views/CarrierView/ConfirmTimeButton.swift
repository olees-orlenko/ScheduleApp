import SwiftUI

struct ConfirmTimeButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Уточнить время")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color("blue"))
                .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
    }
}
