import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    
    // MARK: - Properties
    
    @State private var path = NavigationPath()
    @StateObject private var viewModel = SettingsViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if let errorType = viewModel.errorType {
                    ErrorView(type: errorType)
                } else {
                    mainContent
                }
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .task {
                await viewModel.checkAppDependencies()
            }
        }
    }
    
    // MARK: - Views
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            
            // MARK: - Settings List
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Toggle(Constants.SettingsView.darkTheme, isOn: $viewModel.isDarkModeEnabled)
                            .font(.system(size: 17))
                            .kerning(-0.41)
                            .tint(.blue)
                    }
                    .padding(.vertical, 19)
                    .padding(.horizontal, 16)
                    .background(Color(.systemBackground))
                    NavigationLink {
                        AgreementView()
                    } label: {
                        HStack {
                            Text(Constants.SettingsView.agreement)
                                .font(.system(size: 17))
                                .kerning(-0.41)
                            Spacer()
                            Image("Chevron")
                                .foregroundColor(.primary)
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 19)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                        .frame(height: 32)
                    
                }
                .background(Color(.systemBackground))
                .frame(maxWidth: .infinity)
            }
            Spacer()
            
            // MARK: - Footer Labels
            
            VStack(spacing: 16) {
                Text(Constants.SettingsView.appUseApiText)
                    .font(.system(size: 12))
                    .foregroundStyle(.primary)
                    .kerning(0.4)
                Text(Constants.SettingsView.appVersion)
                    .font(.system(size: 12))
                    .foregroundStyle(.primary)
                    .kerning(0.4)
            }
            .multilineTextAlignment(.center)
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

// MARK: - SettingsView_Preview

#Preview {
    SettingsView()
        .preferredColorScheme(.light)
}
