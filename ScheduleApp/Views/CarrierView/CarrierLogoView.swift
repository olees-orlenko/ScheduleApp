import SwiftUI

// MARK: - CarrierLogoView

struct CarrierLogoView: View {
    
    // MARK: - Properties
    
    let logoURLString: String
    let carrierName: String
    let transfer: String?
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 8) {
            logoImage
            carrierInfo
        }
    }
    
    // MARK: - Views
    
    private var logoImage: some View {
        AsyncImage(url: URL(string: logoURLString)) { phase in
            switch phase {
            case .empty:
                Color.clear
                    .frame(width: 38, height: 38)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)
            case .failure:
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private var carrierInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(carrierName)
                .font(.system(size: 17, weight: .regular))
                .kerning(-0.41)
                .foregroundColor(Color("black"))
            
            if let transfer = transfer {
                Text(transfer)
                    .font(.system(size: 12, weight: .regular))
                    .kerning(0.4)
                    .foregroundColor(.red)
            }
        }
        
    }
}

// MARK: - CarrierLogoView_Preview

#Preview {
    CarrierLogoView(
        logoURLString: "https://yastat.net/s3/rasp/media/data/company/logo/aeroflot.png",
        carrierName: "Аэрофлот",
        transfer: "С пересадкой в Казани"
    )
    .padding()
}
