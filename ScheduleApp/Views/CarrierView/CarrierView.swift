import SwiftUI

// MARK: - CarrierView

struct CarrierView: View {
    
    // MARK: - Properties
    
    let carrierCode: String
    @StateObject private var viewModel: CarrierViewModel
    
    // MARK: - Environment
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Init
    
    init(carrierCode: String) {
        self.carrierCode = carrierCode
        _viewModel = StateObject(wrappedValue: CarrierViewModel(carrierCode: carrierCode))
    }
    
    
    // MARK: - Body
    
    var body: some View {
        if let errorType = viewModel.errorType {
                    ErrorView(type: errorType)
                } else {
        VStack(spacing: 0) {
            navigationHeader
            ScrollView {
                VStack(spacing: 0) {
                    carrierLogoView()
                    carrierFullNameView()
                    carrierEmailBlock()
                    Spacer()
                    carrierPhoneBlock()
                    Spacer()
                        .padding(.bottom, 50)
                }
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.loadCarrierInfo()
        }
    }
}
    // MARK: - Views
    
    private var navigationHeader: some View {
        NavigationLeftButtonView(title: Constants.CarrierView.carrierTitle, showBackButton: true, backAction: {
            dismiss()
        })
    }
    
    private func carrierLogoView() -> some View {
        VStack {
            AsyncImage(url: viewModel.carrierLogoURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image("")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
            .frame(width: 343, height: 104)
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
    
    private func carrierFullNameView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.carrierFullName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 16)
                .padding(.bottom, 16)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func carrierEmailBlock() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.CarrierView.carrierEmail)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
                .kerning(-0.41)
            Text(viewModel.carrierEmail)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color("blue"))
                .kerning(0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func carrierPhoneBlock() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.CarrierView.carrierPhone)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
                .kerning(-0.41)
            Text(viewModel.carrierPhone)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color("blue"))
                .kerning(0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - CarrierView_Preview

#Preview{
    CarrierView(carrierCode: "680")
}
