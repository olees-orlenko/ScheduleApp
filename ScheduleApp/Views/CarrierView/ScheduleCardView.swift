import SwiftUI

struct ScheduleCardView: View {
    let schedule: Сarrier

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: Логотип перевозчика + Дата
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
                    .foregroundColor(.primary)
                    .padding(.top, -15)
                    .padding(.trailing, -7)
            }

            // MARK: Время отправления
            HStack(alignment: .center) {
                Text(schedule.departureTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                    .frame(width: 46, alignment: .leading)
                Spacer().frame(width: 4)

                // MARK: Длительность
                HStack(spacing: 4) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("gray"))
                    Text(schedule.duration)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                        .fixedSize()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("gray"))
                }
                Spacer().frame(width: 4)
                
                // MARK: Время прибытия
                Text(schedule.arrivalTime)
                    .font(.system(size: 17, weight: .regular))
                    .kerning(0.4)
                    .foregroundColor(.primary)
                    .frame(width: 46, alignment: .trailing)
            }
        }
        .padding(14)
        .background(Color("lightGray"))
        .cornerRadius(24)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
