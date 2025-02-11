//
//  WeatherViewModelTest.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

@testable import myWeather
import Combine
import XCTest

class WeatherViewModelTest: XCTestCase {
    
    var sut: WeatherViewModel!
    var mockDataClient: RequestingProtocol!
    var mockUserDefaults: UserDefaults!
    var cancellables: Set<AnyCancellable>!
    
    class MockDataClient: RequestingProtocol {
        
        enum RequestType {
            case success
            case error
            case empty
        }
        
        var type: RequestType = .success
        
        func requestData<T>(requestDetails: URLRequestDetails) async throws -> T where T : Decodable {
            do {
                let response = try JsonReader.mockJsonResponse(type: T.self, fileName: "weather")
                return response!
            } catch {
                throw error
            }
        }
    }
    
    override func setUpWithError() throws {
        mockUserDefaults = UserDefaults(suiteName: name)
        mockUserDefaults.removeObject(forKey: Constants.cityName)
        mockDataClient = MockDataClient()
        sut = WeatherViewModel(dataClient: mockDataClient, userDefaults: mockUserDefaults)
        cancellables = []
    }
    
    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: name)
    }
    
    func testViewStateForNotSavedDefaults() {
        let expectation = expectation(description: "data fetching")
        var result: WeatherViewModel.ViewState = .loading
        sut.$viewState.sink { viewState in
            if viewState == .empty  {
                result = viewState
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(result, .empty)
    }
    
    func testSelectedWeather() {
        let mockCondition = WeatherCondition(text: "test", icon: "http://icon")
        let mockWeather = CurrentWeather(temperature: 89.0, condition: mockCondition, humidity: 80, uvIndex: 10.0, feelsLike: 98.0)
        sut.selectedWeather(weather: mockWeather, city: "miami")
        let savedCity = mockUserDefaults.string(forKey: Constants.cityName)
        XCTAssertEqual(savedCity, "miami")
    }
    
    func testSuccessfulResponse() async {
        await sut.fetchData(city: "tokyo", isDefaults: false)
        var testWeather: CurrentWeather?
        var testCity: String?
        switch sut.viewState {
        case .searchResult(let weather, let city):
            testWeather = weather
            testCity = city
        default:
            break
        }
        
        XCTAssertEqual(testCity, "Tokyo")
        XCTAssertEqual(testWeather?.temperature, 36.3)
        XCTAssertEqual(testWeather?.humidity, 60)
        XCTAssertEqual(testWeather?.feelsLike, 31.2)
    }
}
