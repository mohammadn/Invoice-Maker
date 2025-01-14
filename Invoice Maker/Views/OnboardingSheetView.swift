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

                    Text("با فاکتور ساز به آسانی کسب و کار خود را مدیریت کنید.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    VStack(spacing: 10) {
                        FeatureView(label: "مدیریت مشتریان و محصولات",
                                    description: "افزودن، ویرایش و مدیریت محصولات و مشتریان برای دسترسی آسان وهمیشگی.",
                                    icon: "person.2.fill",
                                    color: .blue)
                        FeatureView(label: "صدور و مدیریت فاکتورها",
                                    description: "ساخت، ویرایش و مدیریت فاکتورها برای کنترل بهتر و دقیق امور مالی.",
                                    icon: "doc.text.fill",
                                    color: .orange)
                        FeatureView(label: "ذخیره فاکتورها با فرمت PDF",
                                    description: "ذخیره فاکتورها با فرمت PDF برای دسترسی، اشتراک‌گذاری و چاپ آسان.",
                                    icon: "square.and.arrow.down.fill",
                                    color: .green)
                    }

                    Spacer()
                }
                .padding(10)

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
                .padding(10)

                Spacer()
            }
            .tag(OnboardingTabItems.introduction)
            .padding(20)

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

                Text("برای شروع اطلاعات خود را وارد کنید. این اطلاعات بر روی فاکتورهای شما نمایش داده خواهد شد.")
                    .font(.headline)
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
                .padding(10)

                Spacer()
            }
            .tag(OnboardingTabItems.businessInfo)
            .padding(20)
        }
        .interactiveDismissDisabled()
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingSheetView()
}

struct FeatureView: View {
    let label: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.largeTitle.bold())
                .frame(width: 60, alignment: .center)

            VStack(alignment: .leading) {
                Text(label)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
            }

            Spacer()
        }
    }
}
