import SwiftUI

// MARK: - ScheduleCardView

struct ScheduleCardView: View {
    
    // MARK: - Properties
    
    let schedule: Сarrier

    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            carrierInfoSection
            timeSection
        }
        .padding(14)
        .background(Color("lightGray"))
        .cornerRadius(24)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    // MARK: - Views

    private var carrierInfoSection: some View {
        HStack {
            CarrierLogoView(
                logoName: schedule.carrierLogoName,
                carrierName: schedule.carrierName,
                transfer: schedule.transfer
            )
            Spacer()
            Text(schedule.date)
                .font(.system(size: 12, weight: .regular))
                .kerning(0.4)
                .foregroundColor(.black)
                .padding(.top, -15)
                .padding(.trailing, -7)
        }
    }
    
    private var timeSection: some View {
        HStack(alignment: .center) {
            departureTimeView
            Spacer().frame(width: 4)
            durationView
            Spacer().frame(width: 4)
            arrivalTimeView
        }
    }
    
    private var departureTimeView: some View {
        Text(schedule.departureTime)
            .font(.system(size: 17, weight: .regular))
            .kerning(-0.41)
            .foregroundColor(.black)
            .frame(width: 46, alignment: .leading)
    }
    
    private var durationView: some View {
        HStack(spacing: 4) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("gray"))
            Text(schedule.duration)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)
                .fixedSize()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("gray"))
        }
    }
    
    private var arrivalTimeView: some View {
        Text(schedule.arrivalTime)
            .font(.system(size: 17, weight: .regular))
            .kerning(-0.41)
            .foregroundColor(.black)
            .frame(width: 46, alignment: .trailing)
    }
}
