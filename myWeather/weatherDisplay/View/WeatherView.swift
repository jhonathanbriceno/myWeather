//
//  ContentView.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

import Kingfisher
import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            switch viewModel.viewState {
            case .error:
                Text("Something went wrong")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(Color.ui.primaryTextColor)
            case .searchResult(let weather, let city):
                VStack {
                    WeatherSearch(weather: weather, city: city)
                        .onTapGesture {
                            viewModel.selectedWeather(weather: weather, city: city)
                        }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 64)
            case .content(let weather, let city):
                WeatherContent(weather: weather, city: city)
                    .padding(.horizontal, 32)
            case .empty:
                Text("No City Selected")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(Color.ui.primaryTextColor)
                    .padding(.bottom, 8)
                Text("Please search for a city")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.ui.primaryTextColor)
            case .loading:
                ProgressView()
            }
        }
        .searchable(text: $viewModel.searchableCity, prompt: "Search Location")
        .onChange(of: viewModel.debouncedSearch) { _, newState in
            Task {
                await viewModel.fetchData(city: newState)
            }
        }
    }
}
