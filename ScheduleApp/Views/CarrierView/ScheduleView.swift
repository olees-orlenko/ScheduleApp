import SwiftUI

// MARK: - ScheduleView

struct ScheduleView: View {
    
    // MARK: - Properties
    
    let fromStationCode: String
    let toStationCode: String
    let fromStationName: String
    let toStationName: String
    @State private var path = NavigationPath()
    @StateObject private var viewModel: ScheduleViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Init
    
    init(fromStationCode: String,
         toStationCode: String,
         fromStationName: String,
         toStationName: String,
         selectedDepartureTimes: [Time],
         selectedTransferOption: Transfer?) {
        self.fromStationCode = fromStationCode
        self.toStationCode = toStationCode
        self.fromStationName = fromStationName
        self.toStationName = toStationName
        _viewModel = StateObject(wrappedValue: ScheduleViewModel(
            fromStationCode: fromStationCode,
            toStationCode: toStationCode,
            fromStationName: fromStationName,
            toStationName: toStationName,
            initialDepartureTimes: Set(selectedDepartureTimes),
            initialTransferOption: selectedTransferOption
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                if let errorType = viewModel.errorType {
                    ErrorView(type: errorType)
                } else {
                    mainContent
                    navigationLinkButton
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadSchedule()
        }
    }
    
    // MARK: - Views
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            navigationHeader
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                routeTitle
                if viewModel.scheduleList.isEmpty {
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
        Text(viewModel.routeTitle)
            .font(.system(size: 24, weight: .bold))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private var emptyScheduleView: some View {
        VStack {
            Text(Constants.ScheduleView.emptyScheduleText)
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
                ForEach(viewModel.scheduleList) { schedule in
                    ScheduleCardView(schedule: schedule)
                }
            }
        }
        .background(Color.clear)
    }
    
    private var navigationLinkButton: some View {
        NavigationLink {
            FilterView(
                fromStationCode: fromStationCode,
                toStationCode: toStationCode,
                fromStationName: fromStationName,
                toStationName: toStationName,
                onApplyFiltersAndNavigate: { fromCode, toCode, fromName, toName, newDepartureTimes, newTransferOption in
                    viewModel.updateFilters(
                        departureTimes: Set(newDepartureTimes),
                        transferOption: newTransferOption
                    )
                },
                initialDepartureTimes: viewModel.currentDepartureTimes,
                initialTransferOption: viewModel.currentTransferOption)
        } label: {
            ConfirmTimeButton(action: nil)
        }
    }
}

// MARK: - ScheduleView_Preview

#Preview {
    ScheduleView(
        fromStationCode: "s2006004",
        toStationCode: "s2000002",
        fromStationName: "Санкт-Петербург (Московский вокзал)",
        toStationName: "Москва (Ленинградский вокзал)",
        selectedDepartureTimes: [],
        selectedTransferOption: nil
    )
}
