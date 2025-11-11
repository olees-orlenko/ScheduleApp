import SwiftUI

// MARK: - CarrierLogoView

struct CarrierLogoView: View {
    
    // MARK: - Properties
    
    let logoName: String
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
    
    private  var logoImage: some View {
        Image(logoName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 38, height: 38)
            .cornerRadius(12)
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
        logoName: "carrierLogo",
        carrierName: "Аэрофлот",
        transfer: "С пересадкой в Казани"
    )
    .padding()
}
