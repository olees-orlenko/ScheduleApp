import SwiftUI
import Combine

// MARK: - MainView

struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @State private var departureStationCode: String = ""
    @State private var departureStationName: String = Constants.MainView.from
    @State private var arrivalStationCode: String = ""
    @State private var arrivalStationName: String = Constants.MainView.to
    @State private var citySelectionForDeparture = false
    @State private var citySelectionForArrival = false
    @State private var isFindButtonTapped = false
    @State private var currentStoryIndex = 0
    @State private var showFullScreenStory = false
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    private var isFindButtonEnabled: Bool {
        !departureStationCode.isEmpty && !arrivalStationCode.isEmpty
    }
    @State private var stories: [Story] = [ .story1, .story2, .story3, .story4 ]
    @State private var fullScreenConfig = StoryConfiguration()
    
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
            .fullScreenCover(isPresented: $citySelectionForDeparture) {
                CitySelectionView(
                    selectedStationCode: $departureStationCode,
                    selectedStationName: $departureStationName
                )
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
            }
            .fullScreenCover(isPresented: $citySelectionForArrival) {
                CitySelectionView(
                    selectedStationCode: $arrivalStationCode,
                    selectedStationName: $arrivalStationName
                )
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
            }
            .fullScreenCover(isPresented: $showFullScreenStory) {
                FullScreenStoryView(
                    stories: stories,
                    currentStoryIndex: $currentStoryIndex,
                    showFullScreenStory: $showFullScreenStory,
                    onStoryMarkedSeen: { index in
                        if index >= 0 && index < self.stories.count {
                            self.stories[index].isSeen = true
                        }
                    }, configuration: self.fullScreenConfig
                )
            }
        }
    }
    
    // MARK: - Views
    
    private var storiesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories.indices, id: \.self) { index in
                    StoryView(
                        story: stories[index],
                        showFullScreenStory: $showFullScreenStory,
                        currentIndex: index,
                        onStoryTap: { tappedIndex in
                            self.currentStoryIndex = tappedIndex
                            self.showFullScreenStory = true
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
                    cityButton(title: departureStationName) {
                        citySelectionForDeparture = true
                    }
                    cityButton(title: arrivalStationName) {
                        citySelectionForArrival = true
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
            let cityCode = departureStationCode
            let cityName = departureStationName
            departureStationCode = arrivalStationCode
            departureStationName = arrivalStationName
            arrivalStationCode = cityCode
            arrivalStationName = cityName
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
            if isFindButtonEnabled {
                NavigationLink(
                    destination: ScheduleView(fromStationCode: departureStationCode,
                                              toStationCode: arrivalStationCode,
                                              fromStationName: departureStationName,
                                              toStationName: arrivalStationName)
                    .toolbar(.hidden, for: .tabBar),
                    isActive: $isFindButtonTapped
                ) {
                    EmptyView()
                }
                .hidden()
                Button(action: {
                    isFindButtonTapped = true
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
