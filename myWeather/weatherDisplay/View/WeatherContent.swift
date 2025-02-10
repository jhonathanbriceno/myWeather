//
//  WeatherContent.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

import Kingfisher
import SwiftUI

struct WeatherContent: View {
    
    var weather: CurrentWeather
    var city: String
    
    var body: some View {
        VStack {
            if let url = URL(string: "https:\(weather.condition.icon)") {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125, height: 125)
                    .padding(.top, 75)
            }
            HStack {
                Text("\(city)")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(Color.ui.primaryTextColor)
                    .padding(.bottom, 4)
                Image(systemName: Constants.locationIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.ui.primaryTextColor)
            }
            HStack {
                Text("\(String(format: "%.0f", weather.temperature))")
                    .font(.system(size: 70, weight: .semibold))
                    .foregroundColor(Color.ui.primaryTextColor)
                VStack {
                    Image(systemName: Constants.degreeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .offset(y: -20)
                        .foregroundColor(Color.ui.primaryTextColor)
                }
            }
            .padding(.bottom, 4)
            ZStack {
                Color.ui.cardColor
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Humidity")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(Color.ui.secondaryTextColor)
                        Text("\(weather.humidity)%")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.ui.secondaryTextColor)
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("UV")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(Color.ui.secondaryTextColor)
                        Text("\(String(format: "%.0f", weather.uvIndex))")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.ui.secondaryTextColor)
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Feels Like")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(Color.ui.secondaryTextColor)
                        Text("\(String(format: "%.0f", weather.feelsLike))°")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.ui.secondaryTextColor)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .cornerRadius(10)
            .frame(maxHeight: 75)
            Spacer()
        }
    }
}

