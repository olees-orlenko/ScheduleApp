import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    
    // MARK: - Properties
    
    @State private var isDarkModeEnabled = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 32) {
            
            // MARK: - Settings List
            List {
                Section {
                    Toggle("Тёмная тема", isOn: $isDarkModeEnabled)
                        .font(.system(size: 17))
                        .kerning(-0.41)
                        .tint(.blue)
                    HStack {
                        Text("Пользовательское соглашение")
                            .font(.system(size: 17))
                            .kerning(-0.41)
                        Spacer()
                        Image("Chevron")
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 19)
                    .listRowSeparator(.hidden)
                }
            }
            .padding(.top, 24)
            .scrollDisabled(true)
            .listStyle(.plain)
            
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

// MARK: - SettingsView_Preview

#Preview {
    SettingsView()
        .preferredColorScheme(.light)
}
