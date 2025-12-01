import SwiftUI

// MARK: - FilterView

struct FilterView: View {

    @StateObject private var viewModel = FilterViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLeftButtonView(title: "", showBackButton: true, backAction: {
                dismiss()
            })
            
            // MARK: - Filters
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(Constants.FilterView.departureTime)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    ForEach(Time.allCases) { time in
                        FilterCheckboxView(
                            title: time.rawValue,
                            isSelected: viewModel.selectedDepartureTime.contains(time)
                        ) {
                            viewModel.toggleDepartureTime(time)
                        }
                    }
                    .padding(.horizontal, 16)
                    Text(Constants.FilterView.showTransfers)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    ForEach(Transfer.allCases) { option in
                        FilterButtonView(
                            title: option.rawValue,
                            isSelected: viewModel.selectedTransfer == option
                        ) {
                            viewModel.selectTransferOption(option)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 95)
            }
            
            // MARK: - Apply Button

            if viewModel.showApplyButton {
                Button(action: {
                    Task {
                        await viewModel.applyFilters()
                        if viewModel.errorMessage == nil {
                             dismiss()
                        }
                    }
                }) {
                    Text(Constants.FilterView.applyButton)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color("blue"))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    FilterView()
}
