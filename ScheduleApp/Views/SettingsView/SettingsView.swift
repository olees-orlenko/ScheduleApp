import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    
    // MARK: - Properties
    
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @State private var path = NavigationPath()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                
                // MARK: - Settings List
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Toggle("Тёмная тема", isOn: $isDarkModeEnabled)
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
                                Text("Пользовательское соглашение")
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
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 12))
                        .foregroundStyle(.primary)
                        .kerning(0.4)
                    Text("Версия 1.0 (beta)")
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
}

// MARK: - SettingsView_Preview

#Preview {
    SettingsView()
        .preferredColorScheme(.light)
}
