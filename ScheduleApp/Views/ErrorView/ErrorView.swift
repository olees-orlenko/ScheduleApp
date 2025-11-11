import SwiftUI

// MARK: - ErrorType

enum ErrorType {
    case noInternet
    case server
    
    var imageName: String {
        switch self {
        case .noInternet:
            return "No Internet"
        case .server:
            return "Server Error"
        }
    }
    
    var message: String {
        switch self {
        case .noInternet:
            return "Нет интернета"
        case .server:
            return "Ошибка сервера"
        }
    }
}

// MARK: - ErrorView

struct ErrorView: View {
    
    // MARK: - Properties
    
    let type: ErrorType
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Image(type.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 223, height: 223)
                .padding(.bottom, 16)
            
            Text(type.message)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - ErrorView_Previews

#Preview("No Internet") {
    ErrorView(type: .noInternet)
}

#Preview("Server Error") {
    ErrorView(type: .server)
}
