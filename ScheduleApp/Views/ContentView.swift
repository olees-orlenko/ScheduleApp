import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
//            testFetchCopyright()
//            testFetchStations()
//            testFetchSearch()
//            testFetchStationScheduleSearch()
//            testFetchThread()
//            testFetchNearestCity()
        }
    }
}

#Preview {
    ContentView()
}
