//
//  WeatherSearch.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

import Kingfisher
import SwiftUI

struct WeatherSearch: View {
    
    var weather: CurrentWeather
    var city: String
    
    var body: some View {
        ZStack {
            Color.ui.cardColor
            HStack {
                VStack {
                    Text("\(city)")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(Color.ui.primaryTextColor)
                        .padding(.top, 16)
                    HStack {
                        Text("\(String(format: "%.0f", weather.temperature))")
                            .font(.system(size: 70, weight: .semibold))
                            .foregroundColor(Color.ui.primaryTextColor)
                        Image(systemName: Constants.degreeIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .offset(y: -20)
                            .foregroundColor(Color.ui.primaryTextColor)
                    }
                }
                .padding(.leading, 16)
                Spacer()
                if let url = URL(string: "https:\(weather.condition.icon)") {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.trailing, 16)
                }
            }
        }
        .cornerRadius(10)
        .frame(maxHeight: 75)
    }
}
