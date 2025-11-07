import SwiftUI

struct NoInternetErrorView: View {
    var body: some View {
        VStack {
            Image("No Internet")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 223, height: 223)
                .padding(.bottom, 16)
            Text("Нет интернета")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

//#Preview {
//    NoInternetErrorView()
//}
