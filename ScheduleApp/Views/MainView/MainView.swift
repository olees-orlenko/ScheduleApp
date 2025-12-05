import SwiftUI
import Combine

// MARK: - MainView

struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @State private var fullScreenConfig = StoryConfiguration()
    @StateObject private var viewModel = MainViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        storiesSection
                        routeSelectionSection
                            .padding(.top, 20)
                        findButtonSection
                    }
                }
                .background(Color(.systemBackground).ignoresSafeArea())
                .navigationBarHidden(true)
            }
            .fullScreenCover(isPresented: $viewModel.citySelectionForDeparture) {
                CitySelectionView(
                    selectedStationCode: $viewModel.departureStationCode,
                    selectedStationName: $viewModel.departureStationName
                )
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
            }
            .fullScreenCover(isPresented: $viewModel.citySelectionForArrival) {
                CitySelectionView(
                    selectedStationCode: $viewModel.arrivalStationCode,
                    selectedStationName: $viewModel.arrivalStationName
                )
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
            }
            .fullScreenCover(isPresented: $viewModel.showFullScreenStory) {
                FullScreenStoryView(
                    stories: viewModel.stories,
                    currentStoryIndex: $viewModel.currentStoryIndex,
                    showFullScreenStory: $viewModel.showFullScreenStory,
                    onStoryMarkedSeen: { index in
                        viewModel.markStoryAsSeen(index: index)
                    }, configuration: self.fullScreenConfig
                )
            }
        }
    }
    
    // MARK: - Views
    
    private var storiesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.stories.indices, id: \.self) { index in
                    StoryView(
                        story: viewModel.stories[index],
                        showFullScreenStory: $viewModel.showFullScreenStory,
                        currentIndex: index,
                        onStoryTap: { tappedIndex in
                            viewModel.handleStoryTap(index: tappedIndex)
                        }
                    )
                    .padding(.vertical, 2)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 140)
        .padding(.vertical, 24)
    }
    
    private var routeSelectionSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("blue"))
                .frame(width: 343, height: 128)
            
            HStack(spacing: -32) {
                VStack {
                    cityButton(title: viewModel.departureStationName) {
                        viewModel.citySelectionForDeparture = true
                    }
                    cityButton(title: viewModel.arrivalStationName) {
                        viewModel.citySelectionForArrival = true
                    }
                }
                .frame(width: 259, height: 96)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                )
                swapButton
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
    
    private var swapButton: some View {
        Button {
            viewModel.swapStations()
        } label: {
            Image("Сhange")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
        .padding(.trailing, -32)
        .padding(.leading, 16)
        .frame(width: 84, height: 128)
    }
    
    private var findButtonSection: some View {
        Group {
            if viewModel.isFindButtonEnabled {
                NavigationLink(
                    destination: ScheduleView(fromStationCode: viewModel.departureStationCode,
                                              toStationCode: viewModel.arrivalStationCode,
                                              fromStationName: viewModel.departureStationName,
                                              toStationName: viewModel.arrivalStationName,
                                              selectedDepartureTimes: [],
                                              selectedTransferOption: nil)
                    .toolbar(.hidden, for: .tabBar),
                    isActive: $viewModel.isFindButtonTapped
                ) {
                    EmptyView()
                }
                .hidden()
                Button(action: {
                    viewModel.isFindButtonTapped = true
                }) {
                    Text(Constants.MainView.findButton)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 60)
                        .background(Color("blue"))
                        .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 16)
            }
        }
    }
    
    private func cityButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(title == Constants.MainView.from || title == Constants.MainView.to ? Color("gray") : .black)
                .kerning(-0.41)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - MainView_Preview

#Preview {
    MainView()
        .preferredColorScheme(.light)
        .padding()
}
