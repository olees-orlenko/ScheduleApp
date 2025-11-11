import SwiftUI
import UIKit

struct ScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @State private var path = NavigationPath()
    let scheduleList = Сarrier.schedule
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    NavigationLeftButtonView(title: "", showBackButton: true, backAction: {
                        dismiss()
                    })
                    Spacer()
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // MARK: - Route Title
                        Text("Москва (Ярославский вокзал) → Санкт Петербург\n(Балтийский вокзал)")
                            .font(.system(size: 24, weight: .bold))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        if scheduleList.isEmpty {
                            Text("Вариантов нет")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 221)
                            Spacer()
                        } else {
                            // MARK: - List of Variants
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(Сarrier.schedule) { schedule in
                                        ScheduleCardView(schedule: schedule)
                                    }
                                }
                            }
                            .background(Color.clear)
                        }
                    }
                    .background(Color(UIColor.clear).ignoresSafeArea())
                    .navigationBarHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                    NavigationLink {
                        FilterView()
                    } label: {
                        ConfirmTimeButton {
                            path.append("GoToFilterView")
                        }
                        .navigationDestination(for: String.self) { route in
                            if route == "GoToFilterView" {
                                FilterView()
                            }
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview{
    ScheduleView()
}
