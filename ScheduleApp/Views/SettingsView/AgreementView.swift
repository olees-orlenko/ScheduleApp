import SwiftUI

// MARK: - AgreementView

struct AgreementView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationLeftButtonView(title: "Пользовательское соглашение", showBackButton: true, backAction: {
                    dismiss()
                })
                .padding(.vertical, 11)
                .background(Color(.systemBackground))
                ScrollView {
                    mainContent
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                }
                .background(Color(UIColor.systemBackground))
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
    }

    // MARK: - Views

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            Text(text1)
                .font(.system(size: 17))
                .kerning(-0.41)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text("1. ТЕРМИНЫ")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 16)

            Text(text2)
                .font(.system(size: 17))
                .kerning(-0.41)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Content
    
    private var text1: String {
        """
        Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer

        Российская Федерация, город Москва
        """
    }
    
    private var text2: String {
        """
        Понятия, используемые в Оферте, означают следующее:  Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.  Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
        """
    }
}

// MARK: - AgreementView_Preview

#Preview {
    AgreementView()
        .preferredColorScheme(.light)
}
