import SwiftUI

// MARK: - ScheduleView

struct ScheduleView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - State
    
    @State private var path = NavigationPath()
    
    // MARK: - Properties
    
    let scheduleList = Сarrier.schedule
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                mainContent
                navigationLinkButton
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - Views
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            navigationHeader
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                routeTitle
                if scheduleList.isEmpty {
                    emptyScheduleView
                } else {
                    scheduleListView
                }
            }
            .padding(.bottom, 24)
            .background(Color(UIColor.clear).ignoresSafeArea())
        }
    }
    
    private var navigationHeader: some View {
        NavigationLeftButtonView(title: "", showBackButton: true, backAction: {
            dismiss()
        })
    }
    
    private var routeTitle: some View {
        Text("Москва (Ярославский вокзал) → Санкт Петербург\n(Балтийский вокзал)")
            .font(.system(size: 24, weight: .bold))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private var emptyScheduleView: some View {
        VStack {
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 221)
            Spacer()
        }
    }
    
    private var scheduleListView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(scheduleList) { schedule in
                    ScheduleCardView(schedule: schedule)
                }
            }
        }
        .background(Color.clear)
    }
    
    private var navigationLinkButton: some View {
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

// MARK: - ScheduleView_Preview

#Preview{
    ScheduleView()
}
