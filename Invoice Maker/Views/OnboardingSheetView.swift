//
//  OnboardingSheetView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/01/2025.
//

import SwiftUI

enum OnboardingTabItems: Hashable {
    case introduction, businessInfo
}

struct OnboardingSheetView: View {
    @AppStorage("isWelcomeSheetShowing") var isWelcomeSheetShowing = true
    @Environment(\.modelContext) private var context
    @State private var selectedTab: OnboardingTabItems = .introduction
    @State private var businessDetails: BusinessDetails

    var business: Business?

    init(business: Business? = nil) {
        self.business = business

        if let business {
            _businessDetails = State(initialValue: BusinessDetails(from: business))
        } else {
            _businessDetails = State(initialValue: BusinessDetails())
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            VStack(spacing: 30) {
                Spacer()

                VStack(spacing: 10) {
                    Image("AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Rectangle())
                        .cornerRadius(20)

                    Text("فاکتور ساز")
                        .font(.largeTitle.bold())
                }

                Text("در سریعترین زمان ممکن و فقط با در دست داشتن گوشی خود، کسب و کار خودتون رو مدیریت کنید.")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Spacer()
                Spacer()

                Button {
                    withAnimation {
                        selectedTab = .businessInfo
                    }
                } label: {
                    Text("ادامه")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .tag(OnboardingTabItems.introduction)
            .padding(30)

            VStack(spacing: 30) {
                HStack {
                    Button {
                        withAnimation {
                            selectedTab = .introduction
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                    }

                    Spacer()
                }

                Spacer()

                Text("اطلاعات کسب و کار")
                    .font(.largeTitle)

                Text("لطفا اطلاعات کسب و کار خود را وارد کنید. این اطلاعات بر روی فاکتورهای شما نمایش داده خواهد شد.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 10) {
                    TextField("نام کسب و کار*", text: $businessDetails.name)

                    Divider()

                    TextField("شماره تماس*", text: $businessDetails.phone)
                }

                Spacer()
                Spacer()

                Button {
                    if let business {
                        business.update(with: businessDetails)
                    } else {
                        let business = Business(from: businessDetails)

                        context.insert(business)
                    }

                    isWelcomeSheetShowing = false
                } label: {
                    Text("ذخیره و شروع")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .disabled(businessDetails.isInvalid)

                Spacer()
            }
            .tag(OnboardingTabItems.businessInfo)
            .padding(30)
        }
        .interactiveDismissDisabled()
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingSheetView()
}
