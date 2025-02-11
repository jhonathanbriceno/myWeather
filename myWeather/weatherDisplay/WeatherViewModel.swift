//
//  WeatherViewModel.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

import Foundation

protocol WeatherProtocol {
    func loadWeatherFromDefaults()
    func selectedWeather(weather: CurrentWeather, city: String)
    func fetchData(city: String, isDefaults: Bool) async
}

class WeatherViewModel: ObservableObject, WeatherProtocol {
    
    enum ViewState: Equatable {
        static func == (lhs: WeatherViewModel.ViewState, rhs: WeatherViewModel.ViewState) -> Bool {
            return lhs.value == rhs.value
        }
        
        var value: String? {
            return String(describing: self).components(separatedBy: "(").first
        }
        
        case error
        case content(weather: CurrentWeather, city: String)
        case searchResult(weather: CurrentWeather, city: String)
        case empty
        case loading
    }
    
    let dataClient: RequestingProtocol
    let weatherDefaults: UserDefaults
    @Published var viewState: ViewState = .loading
    @Published var searchableCity = ""
    @Published var debouncedSearch = ""
    
    /// ViewModel Initializer
    ///
    /// - dataClient: injectable dataClient for mocking requests
    /// - userDefaults: Injectable UserDefaults property for easy unit testing
    init(dataClient: RequestingProtocol = DataClient(), userDefaults: UserDefaults = UserDefaults.standard) {
        self.dataClient = dataClient
        self.weatherDefaults = userDefaults
        self.setupSearchDebounce()
        self.loadWeatherFromDefaults()
    }
    
    /// Method used to fetch city name from defaults and load the data
    ///
    func loadWeatherFromDefaults() {
        if let cityName = weatherDefaults.string(forKey: Constants.cityName) {
            Task {
                await fetchData(city: cityName, isDefaults: true)
            }
        } else {
            viewState = .empty
        }
    }
    
    /// Method used by the view from user data search of a city, also used on app launch to pass proper default state
    ///
    /// - isDefaults: used to know if the UI should display content or search styles
    /// - city: city name
    @MainActor
    func fetchData(city: String, isDefaults: Bool = false) async {
        guard !city.isEmpty else { return }
        do {
            let state = try await loadWeather(city: city, isDefaults: isDefaults)
            viewState = state
        } catch {
            viewState = .error
        }
    }
    
    /// Update the UI from search to content with correct city and data, it also saves to defaults
    ///
    /// - weather: current weather details
    /// - city: city name
    func selectedWeather(weather: CurrentWeather, city: String) {
        weatherDefaults.set(city, forKey: Constants.cityName)
        viewState = .content(weather: weather, city: city)
        searchableCity = ""
    }
    
    /// Handles server request for weather
    ///
    /// - city: city name used on the request
    /// - isDefaults: Boolean used to send proper state to UI
    /// - returns: UI state based on response it could be empty, error, content, or search types
    private func loadWeather(city: String, isDefaults: Bool) async throws -> ViewState {
        guard let url = URL(string: buildUrlString(city)) else {
            return .error
        }
        
        if let weather: Weather = try await dataClient.requestData(requestDetails: URLRequestDetails(url: url)) {
            if let cityName = weather.location?.name, let currentWeather = weather.current {
                if isDefaults {
                    return .content(weather: currentWeather, city: cityName)
                } else {
                    return .searchResult(weather: currentWeather, city: cityName)
                }
            } else if let error = weather.error, error.code == 1006 {
                return .empty
            }
        }
        return .error
    }
    
    /// Helper method use to debounced search bar and limit the amount of server requests
    ///
    func setupSearchDebounce() {
        debouncedSearch = self.searchableCity
        $searchableCity
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .assign(to: &$debouncedSearch)
    }
    
    /// Helper method use to build the URL
    ///
    /// - city: city name used to build the URL Request
    func buildUrlString(_ city: String) -> String {
        return "\(Constants.weatherUrl)?key=\(Constants.apiKey)&q=\(city)"
    }
}
