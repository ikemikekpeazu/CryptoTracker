# 📱 Crypto Tracker App

---

 Crypto Tracker is a real-time cryptocurrency tracker where users can monitor live market data, manage a personal portfolio, and view detailed price history via custom charts.
 <p align="center">
<img width="250" alt="CryptoHomeScreen" src="https://github.com/user-attachments/assets/51efcf19-ceb4-41f1-af2b-fb5a43e00467" hspace="30"/>
<img width="250" alt="CryptoDetailView" src="https://github.com/user-attachments/assets/7b49dd51-7721-4229-b7aa-f565ff7e7ab4" hspace="30" />
<img width="250" alt="AddHoldingScreen" src="https://github.com/user-attachments/assets/4d418c23-d30e-47e5-800f-695936a2e817" hspace="30"/>
</p>

## 💻 Technologies/Architecture

- `Swift`
- `SwiftUI`
- `Combine`: Handles all asynchronous data streams and network requests
- `Core Data` : Manages the persistence of user-specific portfolio data
- `FileManager`: Used for efficient local caching of coin images
- `Swift Concurrency` for pull to refresh feature
- `Swift Charts` for dynamic price chart
- `URLSession`: Utilized for high-performance networking with JSON decoding.
- `Multi-threading`: Heavy tasks are offloaded to background threads to ensure app efficiency and smooth UI.
- `MVVM Architecture`: Clean separation of concerns between Data, Logic, and UI.
- `LocalAuthentication` for FaceID to access portfolio holdings

## 🚀 Features

- **Live Market Data:** Fetches real-time cryptocurrency prices, market cap, and volume using the CoinGecko API.
- **Global Market Stats:** A top-level dashboard displaying global market data such as Total Market Cap, 24h Volume, and BTC Dominance.
- **Portfolio Management:** Users can track their own holdings by adding coin amounts; the app automatically calculates total portfolio value and profit/loss margins.
- **Persistent Storage:** Utilizes Core Data to save user portfolio data locally, ensuring information is retained even after the app is closed.
- **CoinDetailView:** Users can tap on a coin in order to gain more info regarding that coin
  - Interactive price chart that allows users to see price data on a given coin over 1D, 1W, 1M, 3M, 6M, YTD, 1Y, 2Y, 5Y, and 10Y time frames
  - scrubbing feature that allows users to drag their finger acoss the chart to get more accurate date/price info
  - Overview section which contains a paragraph description of the coin along with some market statistics
  - Additional Details section which has other price info, such as 24h High's and Lows, along with links to the coins website and reddit page
- **Image Caching:** Implements a custom FileManager-based caching system to download and store coin logos locally, reducing API calls and improving performance.
- **Advanced Search & Filtering:**
  - Search coins by name or symbol
  - Sort coin data by price, rank, or holdings
  - Pull to refresh feature to allow users to update coin market data in real-time
- **FaceID**: Implements LocalAuthentication framework to offer users FaceID to secure their portfolio holdings

## Setup Instructions
1. Clone the Repository
2. Open the Project in Xcode
3. Select an iOS Simulator and Run
4. For face ID on the simulator, make sure that FaceID is enrolled by going to Features ->FaceID -> Enrolled. To then unlock with FaceID, go to Features -> FaceID -> Matching Face. (To disable FaceID in the app, you can just change the hasAuthenticated @State variable in the HomeView to true.)

## Requirements
- Xcode 26+
- iOS 17+
- Swift 6

## 🎥 Live Demo

## 🧩 Architecture Deep Dive

To go into the architecture more in depth, this app uses MVVM architecture but with a slight wrinkle. With plain MVVM, the file breakdown within the app would consist solely of models that represent the data, views that display the UI, and then a view model(or multiple) that handle the business logic in the app and how the data in the app must be manipulated in order to be presented in the view. However, this crypto app adds a Data Service layer, in which data is retrieved from the internet. This app requires a lot of networking – retrieving live coin information from the internet, updated prices, updated market data – so separating that logic from the view model within the app, which is focusing more on manipulating data presented within the UI, makes for much cleaner architecture. In addition, not only is the app pulling all this information from the internet, it’s doing so repeatedly – whenever the user pulls to refresh, or clicks on a coin to view it in more detail, or clicks the different time interval toggles on the chart – which makes separating these networking concerns from the view model much more important.

So to walk through it, here’s some code from the CoinDataService, the main Data Service within the app: 

<img width="700" alt="CoinDataServiceScreenShot" src="https://github.com/user-attachments/assets/653edfd2-cb35-47c4-9528-cab2d74d7c4f" />

As seen above, this data service is downloading all the crypto coins needed from the app from the internet and converting them into an array of coinModels.

<img width="619" height="396" alt="HomeViewModelScreenShot1" src="https://github.com/user-attachments/assets/5ea18a71-67b4-4bf9-a939-450887a2b3d5" />

Then, in the view model(above), you create a singleton of the CoinDataService.(There’s also other data services listed as this was done multiple times) then create subscribers in the viewModel that listen to it.

So what happens is on the init you addSubscribers and then the publishers get created. So you have a publisher for the coinDataService.allCoins, which represents when the coins get downloaded from the internet. Then you have a publisher for the searchText for when the user is typing in the search bar. And then a publisher for the sortOption, which monitors when the user aims to filter and organize the listed coins by different criteria such as price and market cap size. So this creates a publisher subscriber dynamic where when any of these published values change, the subscription listens to these changes and the pipeline will activate. The .combineLatest makes sure that all three of these publishers are connected and move together. The debounce is there so that the pipeline will wait a bit while the user is typing into the search bar. Then it maps using a filter and sort coin function which can then be inserted into the map closure since the function has the same closure type. And finally these returnedCoins are then passed into the allCoins of the viewModel, and then these correct updated coins of the viewModel are shown in the list in the view UI.

<img width="512" height="229" alt="RemainingPublishers" src="https://github.com/user-attachments/assets/e802f7b6-2359-416d-b483-8f2b71c24e7d" />

As seen above, a similar pattern exists for the other data services/publishers. So what these two pipelines do is that they take the updated data from the prior pipeline and make it the publisher of the next pipeline and then the subscription listens to it. This connects all the publisher subscribers together and makes one large pipeline where the first publisher/subscriber fires, allCoins is changed, then since allCoins changed that makes the next publisher/subscriber fire, then that ultimately changes portfolioCoins, which is connected to the last publisher through .combineLatest, so then the last publisher/subscriber fires, all combining to successfully pull/update the necessary data then reflect it within the view.


## 📈 Feature Deep Dive: Price Chart on Detail View

By far the hardest feature to build on the app was the price chart on the Coin DetailView.

<p>
 <img width="300" alt="ChartScreen1" src="https://github.com/user-attachments/assets/b38e33bf-e262-4b37-9b78-5ea4dc3302a3" hspace="30"/>
 <img width="300" alt="ChartScreen2" src="https://github.com/user-attachments/assets/1f32924f-3ea6-462f-8309-3070589535bc" hspace="30"/>
</p>

This feature allows the user to see a chart of the price history of a given crypto coin across different time intervals, including 1 day, 1 week, 1 month, 3 month, 6 month, year-to-date, 1 year, 2 years, 5 years, and 10 years. In addition, the user can hold their finger down on any point in the chart and get the exact coin price at that date and time – and drag to see how it changed over time.
