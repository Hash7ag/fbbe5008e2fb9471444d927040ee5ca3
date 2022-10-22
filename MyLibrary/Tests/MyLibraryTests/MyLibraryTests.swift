import XCTest
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(8)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() async throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(0)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

    func testWeatherDataModule() async throws {
        // Given
        let jsonData = """
            {
                "main": {
                    "temp": 289.73
                }
            }
        """.data(using: .utf8)!
    
        // When
        let weatherObject = try JSONDecoder().decode(Weather.self, from: jsonData)

        // Then
        XCTAssertNotNil(weatherObject)
        XCTAssert(weatherObject.main.temp == 289.73)
    }

    func testWeatherServiceCallSuccess() async throws{
        // Given
        var temperature: Int?
        let weatherService = WeatherServiceImpl()
        
        // When
        temperature = try await weatherService.getTemperature()
        
        // Then
        XCTAssertNotNil(temperature)
        XCTAssert(temperature == 289)
    }

    func testWeatherServiceCallFail () async throws {
        // Given
        var temperature: Int?
        let weatherService = WeatherServiceImpl(ServiceCallSuccess: false)
        
        // When
        do {
            temperature = try await weatherService.getTemperature()
        }
        catch {
            temperature = nil
        }

        // Then
        XCTAssertNil(temperature)
    }
}
