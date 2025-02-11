# myWeather App

## General information:

### Description:
Weather app that shows the weather for a city entered from the search bar

### Focus Areas:
1.) Handling All user cases and UI states like loading, empty, error, content
2.) Performance: Being sure to keep memory usage low, only do necessary server requests by taking advantage debouncing code
3.) Unit test and code documentation

### Time Spent:
5 hours, maybe a bit over because of unit test but close to deadline. 

### Getting Started:
This project support iOS 17.0 and app, all you need is Xcode that supports this versions and you should be able to run the project

## Usage:
I am leaving my API key in the project to make it easier on reviewers to just run the code.
The behavior should be as described in the code challenge details

## Architecture:
The project is developed with MVVM architecture.

## Structure:
The main App has a folder for each View inside you will find the corresponding Model, Views and ViewModel classes
Data Client folder is where the class used to make API requests can be found
Utils folder for constants and extensions
Response folder, used for response mocking on unit tests

## Dependencies:
Kingfisher
