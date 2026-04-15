#Crypto Tracker App

---

 Crypto Tracker is a real-time cryptocurrency tracker where users can monitor live market data, manage a personal portfolio, and view detailed price history via custom charts.

##Technologies/Architecture

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
