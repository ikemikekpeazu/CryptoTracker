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



