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

For this feature, I took a lot of inspiration from the stock charts that I would see when I would research/google stocks. Here’s an example of what the google stock chart looks like when you google a ticker: 
<p>
<img width="236" height="512" alt="AppleStockScreen1" src="https://github.com/user-attachments/assets/bcec93e8-a076-49c9-b96f-fcd5e89047c1" hspace="30"/>
<img width="236" height="512" alt="AppleStockScreen2" src="https://github.com/user-attachments/assets/cdd6f390-c2f2-4e8c-9f01-0391072f4330" hspace="30"/>
<p>

This feature has been very helpful for me whenever researching stocks, because you really key into how the stock moves more precisely, which really helps with analysis. Thus, it was a feature that I thought would be great to add to the crypto app.

So to create the feature, I first needed to figure out how I was going to retrieve all the price data for the coins. The issue I ran into was that the CoinGecko API, the api that I was using, didn’t have any endpoints that gave precise enough price data. It was sufficient for pulling prices of individual coins and updating them periodically, and it did have an endpoint that gave interval prices for the past 7 days, but nothing quite in depth enough to create charts for all the different time frames.

So I googled a bit and found an API by Twelvedata that had enough info. I used Postman to mess around with the endpoints a bit, just to see exactly how the JSON came back. Here’s a sample output that I added to my CoinChartModel file for reference:

<img width="512" height="295" alt="ModelofData" src="https://github.com/user-attachments/assets/3a51810c-23ba-471f-b275-c217a35267fa" />

I used this to create a model of the data. The ChartPoint struct isn’t coming directly from the downloaded data from the API, but rather, is a struct that I created to represent an individual chart point that I used later within the data service, view model, and view. All the key names of the properties that I needed were one word and lowercase so I didn’t need an enum with CodingKeys:

<img width="512" height="340" alt="CoinChartModelScreen" src="https://github.com/user-attachments/assets/990f1792-d996-4c8b-b4cb-3c0cc6023241" />

Then, keeping consistent with the architecture in the rest of the app,  I created a CoinChartDataService to pull the chart data from the internet. The use of a data service here instead of just plugging this information into the view model was especially important here, as the exact endpoint for the url changed based on the timeframe selected – so having this logic in it’s own file was much cleaner. Also, I wanted to create in such a way that the data service published an array of chartpoints based on the network call, so that all the viewModel has to handle is an array of clean easy to manipulate chart points, all the more in depth networking logic abstracted away.

<img width="512" height="275" alt="CoinChartDataServiceScreenshot" src="https://github.com/user-attachments/assets/2d8c52b4-a161-4463-9056-7158924330e8" />

So here in my CoinChartDataService, similar to the other data services in the app, I download data from the URL, but then I also map the data into chart points that just represent dates and values in order to make the chart data easier to manipulate for the viewModel and view. One obstacle that I had to overcome here was that, for this feature, the actual data that you pull for the coin varies based on the time interval that the user selects. Start date and end date change, which is an obvious one. But you also have to change the time interval range depending on the time interval selected. For example, if you’re pulling data for a 1 day chart, having chart prices for every 5-10 minutes makes sense. But if you have a 5 year or 10 year chart, pulling data every 5-10 minutes across that time frame would very easily become too slow and costly(the API actually didn’t even do it at a certain point). So I tweaked around in Postman and also a bit in Xcode to see what interval ranges worked best depending on the time frame. Once I figured it out, I then made a ChartRange enum that had all the different time frame cases( 1D, 1W, 1M etc.) and I created startDate, endDate, and interval variables based on those cases, and then those variables got plugged into a createURL function that I created, which gave me a dynamic API call:

<p>
<img width="350" alt="ChartRangeEnum" src="https://github.com/user-attachments/assets/25284f71-b263-44c8-b5ca-e6703d600f3d" hspace="10" />
<img width="350" alt="StartDateProperty" src="https://github.com/user-attachments/assets/274d4fb2-a4f2-4f5f-ad9c-4921191f8869" />
</p>
<img width="512" height="100" alt="CreateURL" src="https://github.com/user-attachments/assets/0c0df988-1cab-4e6a-8ff0-e31ed1ac005f" />

And this URL ultimately flowed into my network call.

Then, in my ChartViewModel file, I created a view model for the chart. In the viewModel, I created an instance of the CoinChartDataService where I pass in the coin and range. And then I addSubscribers, which creates a pipeline from the ChartDataService publisher into chartPoints for the view. To account for when the user changes time intervals, I have a Published variable for the selected range that’s initially set to the .oneDay case in the enum – and when the selectedRange changes by the user pressing the new time interval in the view, updateChart will run, which will update the ChartDataService and rerun the publisher subscriber pipeline.

<img width="512" height="436" alt="ChartVMCode" src="https://github.com/user-attachments/assets/1356014d-c3ca-49df-8be1-84901ff1411d" />

Finally, in my view file, titled ChartView2, I had the UI for the chart. I used the Swift Charts framework to build it out. Due to all the Data Service and view model steps prior, all I had to do to display the chart was Chart(vm.chartPoints).

In ChartView2:

<img width="512" height="141" alt="ChartLinemark" src="https://github.com/user-attachments/assets/4c097831-cf3b-4e18-afe0-350b3d78e307" />

LineMark creates individual “line marks”(or coordinates) that are then connected into a line. Due to the architecture as well, the exact x and y coordinates are easily accessible through point.date and point.value. I added some modifiers to the line as well just for styling. Above the chart, I have a Picker that the user can toggle to select what price timeframe they’d like to look at. The selection in the picker pipes to a selectedRange published variable that I created in my viewModel, and the adjustments to the chart happen accordingly.

Chart and Picker:

<img width="246" height="263" alt="ChartAndPicker" src="https://github.com/user-attachments/assets/6df55e1c-9de9-4cc0-a3b3-83a398ee7b8d" />
<img width="512" height="91" alt="PickerCode" src="https://github.com/user-attachments/assets/0f9af85d-97ec-4905-bcf6-dfa6f87d7600" />

One of the details that you’ll notice within most stock charts like this in various applications is that, if the stock has a positive price delta for that interval, the line on the chart is green, and then if the stock has a negative price delta for that interval, the line on the chart is red. So I implemented that feature as well through adding a foregroundStyle with a ternary operator. I had a computed property priceChange in my ChartViewModel that would get the price delta between the first and last chartpoint in the array, and then I just had the ternary operator check for whether it was > 0(I’ll explain the Color blue change condition later).

In ChartViewModel:

<img width="512" height="81" alt="PriceChange" src="https://github.com/user-attachments/assets/17958004-368c-4a51-a3b9-06704c0a2599" />

I then had some modifiers on the chart for the axis and formatting. I tweaked around with this a lot. I used computed properties in the viewModel as well to get min and max values of the data, along with setting padding. To decide how many axis lines I wanted, along with what they should say, I used the chartRange enum that I had to create stride and count variables that iterated through all the possibilities. For example, for the 1d interval chart each label had the hour on it. And then for the longer interval charts like 1Y, it just said the month. And then for 10Y, all I put was the year.

<p>
 <img height="300" alt="Bitcoin1Y" src="https://github.com/user-attachments/assets/fd21c7fa-7908-4129-a0ed-9e193e5a3f74" hspace="20" />
 <img height="300" alt="USDC10Y" src="https://github.com/user-attachments/assets/3d5c2e2d-f449-4daf-8f31-22ba39f2b810" hspace="20"/>
</p>

<p>
 <img width="512" height="497" alt="ChartAxes" src="https://github.com/user-attachments/assets/d5ae98a3-8f5d-4471-9413-e72894bcc3a8" hspace="10"/>
 <img width="411" height="512" alt="ChartComputedProperties" src="https://github.com/user-attachments/assets/26da58af-d33d-4e88-8541-a9cc11cda8a1" hspace="10"/>
</p>

The final main element to this chart that I added was to allow users to be able to press on point in the line chart and get more accurate price and time data. I did this through creating an optional selectedDate variable that monitored whether the user has pressed on the chart or not. I put this variable in as a binding into the chartXSelection modifier which checks whether or not the user presses on the chart. So when selectedDate has a value, I create a vertical blue line at that point in the X axis. And then to get the exact point on the chart that the user is pressing, I used the .min(by:   on the ChartPoints array to find the chartpoint that had a date that was closest to the selectedDate. And then from there, I made do “points” – two dots. One smaller one that was blue and a larger one that was black. And this gave the effect of a blue dot that had a blue outline to it. I thought that this made the dot look nicer and made it look more visible as one scrubbed it across the line. I also used this selectedDate logic and point to put exact date and price data laid out nicely in between the picker timeframe toggle and the line chart. I added the selectedDate var to my ternary operator for the foregroundStyle of the chart so that I could make the chart turn blue when the user pressed on it.

<img width="300" alt="ChartScreen2" src="https://github.com/user-attachments/assets/1f32924f-3ea6-462f-8309-3070589535bc" hspace="30"/>

After completing the chart implementation, I inserted it into the DetailView, passing in the viewModel coin.
<p>
<img width="477" height="512" alt="DetailViewStruct" src="https://github.com/user-attachments/assets/9922a9f8-fe26-4d84-9f81-f3a1e6a33959" hspace="20" />
<img width="236" height="512" alt="DetailViewScreen" src="https://github.com/user-attachments/assets/2cd99208-c4f8-42e9-8fba-321bc4b612aa" hspace="20"/>
</p>



