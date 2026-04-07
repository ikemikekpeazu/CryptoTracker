//
//  MarketDataModel.swift
//  CryptoTracker
//
//  Created by Ikem Ikekpeazu on 3/23/26.
//

import Foundation

// JSON data:
/*
URL: https://api.coingecko.com/api/v3/global?x_cg_demo_api_key=
 
 JSON Response:
 {
   "data": {
     "active_cryptocurrencies": 18025,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1481,
     "total_market_cap": {
       "btc": 35334838.07916636,
       "eth": 1165038962.3622537,
       "ltc": 44948495626.3012,
       "bch": 5266639554.689482,
       "bnb": 3934752629.634676,
       "eos": 31783493840960.26,
       "xrp": 1763786926870.167,
       "xlm": 15097652444519.248,
       "link": 274579103993.7816,
       "dot": 1762518375553.9504,
       "yfi": 952156551.6067336,
       "sol": 27615816128.155018,
       "usd": 2489126264181.0938,
       "aed": 9141316205205.064,
       "ars": 3477448906588095.5,
       "aud": 3571415787730.882,
       "bdt": 304654991172373.3,
       "bhd": 939792023177.9496,
       "bmd": 2489126264181.0938,
       "brl": 13023606439448.318,
       "cad": 3423606491911.281,
       "chf": 1962374875028.8264,
       "clp": 2265528051869706,
       "cny": 17161281028396.55,
       "czk": 52557901068183.8,
       "dkk": 16055561359322.025,
       "eur": 2148870171246.3308,
       "gbp": 1857567724549.2175,
       "gel": 6757977807251.667,
       "hkd": 19502682627051.027,
       "huf": 836397451853263.2,
       "idr": 42163442907436136,
       "ils": 7754499507116.57,
       "inr": 233239725906758.66,
       "jpy": 394823548598598.5,
       "krw": 3734173260015258.5,
       "kwd": 763056591042.2992,
       "lkr": 779710038041151.5,
       "mmk": 5226692220790103,
       "mxn": 44435165199796.8,
       "myr": 9825825927854.865,
       "ngn": 3408982875109217,
       "nok": 24311535178378.105,
       "nzd": 4265526070381.6274,
       "php": 149638803623774.8,
       "pkr": 693118141813107.2,
       "pln": 9162847147390.232,
       "rub": 203909260898609.2,
       "sar": 9344535940791.602,
       "sek": 23334998673288.316,
       "sgd": 3183512839847.1655,
       "thb": 81243836699738.81,
       "try": 110382788333122.28,
       "twd": 79680309460777.28,
       "uah": 109022075102166.22,
       "vef": 249236212832.4529,
       "vnd": 65610879197549430,
       "zar": 42179426881524.1,
       "xdr": 1752740661059.4949,
       "xag": 37121360519.50097,
       "xau": 573245778.6409056,
       "bits": 35334838079166.36,
       "sats": 3533483807916636
     },
     "total_volume": {
       "btc": 1819120.1264889392,
       "eth": 59978931.2697189,
       "ltc": 2314053707.1659803,
       "bch": 271138925.03011614,
       "bnb": 202570270.31755364,
       "eos": 1636288617106.1272,
       "xrp": 90803877191.08781,
       "xlm": 777262467229.2782,
       "link": 14135974622.815416,
       "dot": 90738569201.6853,
       "yfi": 49019246.74779712,
       "sol": 1421726818.6029806,
       "usd": 128146043131.68767,
       "aed": 470616343401.1228,
       "ars": 179027204840685.2,
       "aud": 183864839707.64734,
       "bdt": 15684351654174.877,
       "bhd": 48382691898.75686,
       "bmd": 128146043131.68767,
       "brl": 670485726873.6162,
       "cad": 176255271374.4015,
       "chf": 101027649338.11678,
       "clp": 116634684077168.14,
       "cny": 883502894371.4207,
       "czk": 2705803700725.585,
       "dkk": 826577859091.4623,
       "eur": 110628863473.71536,
       "gbp": 95631932046.01395,
       "gel": 347916507102.53186,
       "hkd": 1004043726135.3289,
       "huf": 43059697486131.26,
       "idr": 2170672677858043,
       "ils": 399219775470.30316,
       "inr": 12007726729726.064,
       "jpy": 20326439930425.72,
       "krw": 192243975135001.75,
       "kwd": 39283938398.27763,
       "lkr": 40141296808783.3,
       "mmk": 269082342828349.1,
       "mxn": 2287626255926.466,
       "myr": 505856505262.3369,
       "ngn": 175502413371002.84,
       "nok": 1251614705287.3342,
       "nzd": 219599260857.22028,
       "php": 7703755674947.667,
       "pkr": 35683343418241.164,
       "pln": 471724806674.212,
       "rub": 10497725775538.5,
       "sar": 481078570800.5232,
       "sek": 1201340321499.8672,
       "sgd": 163894688492.04834,
       "thb": 4182622774796.7197,
       "try": 5682764172425.735,
       "twd": 4102128734825.8506,
       "uah": 5612711472049.236,
       "vef": 12831263298.775885,
       "vnd": 3377801550908154,
       "zar": 2171495570236.9338,
       "xdr": 90235189585.56606,
       "xag": 1911094481.100542,
       "xau": 29512033.733227655,
       "bits": 1819120126488.9392,
       "sats": 181912012648893.9
     },
     "market_cap_percentage": {
       "btc": 56.6100361203516,
       "eth": 10.358312887188301,
       "usdt": 7.396922035503914,
       "xrp": 3.477809315669057,
       "bnb": 3.4653303629962413,
       "usdc": 3.160283610330008,
       "sol": 2.0721188109895228,
       "trx": 1.1792594550301083,
       "steth": 0.7870975552918726,
       "figr_heloc": 0.6551405691592029
     },
     "market_cap_change_percentage_24h_usd": 2.753669924092754,
     "volume_change_percentage_24h_usd": 80.78567652544885,
     "updated_at": 1774323679
   }
 }
 
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
    
    
    
}






