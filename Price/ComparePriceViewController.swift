//
//  ComparePriceViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit
import SkeletonView
import ContextMenuSwift
import RealmSwift

class ComparePriceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{
    
    let realm = try! Realm()
    
    let token = "JYYQLVJZXWIGERFAUHEYFUJSCKAMJKFZXJMBJHSQYHGQBZMHGDZDQRZKQTGHXNTU"
    let base = "https://api.priceapi.com/v2/jobs/"
    
    struct checkingRequest: Decodable{
        let job_id: String
        let status: String
//        let successful: Int
        init() {
            job_id = ""
            status = ""
        }
    }
    
    struct initialRequestJSON: Decodable{ //struct for the initial JSON parsing
        let job_id: String
        let status: String
    }
    
    struct returnJSON: Decodable {
        let job_id: String
        let status: String
        var results: [Result]?
    }

    struct Result: Decodable {
        var content: Content?
    }
    
    struct Content: Codable{
        var search_results: [searchResults]?
    }
    
    struct searchResults: Codable {
        var url: String?
        var name: String?
        var min_price: String?
        var image_url: String?
    }
    
    var productNames: [String] = [] /// 本番
    var productUrl: [String] = [] /// 本番
    var productPrice: [String] = [] /// 本番
    var productImageUrl: [String] = [] /// 本番
    
    let iphonePhysicalShopName: [String] = ["Apple Kyoto",
                                        "Apple Shinsaibashi",
                                        "Rakuten Mobile Kyoto Shijo",
                                        "Softbank Kyotoshijodori",
                                        "BIC CAMERA Nanba Store",
                                        "Yodobashi Camera Multimedia Kyoto",
                                        "Docomo Kyoto Station",
                                        "EDION KYOTO SHIJO KAWARAMACHI"]
    let iphonePhysicalUrl: [String] = ["https://maps.app.goo.gl/BNiJY6aFBs1EzBRP7?g_st=ic",
                                       "https://maps.app.goo.gl/8yx6jMp6Pcy1cdHW9?g_st=ic",
                                       "https://goo.gl/maps/ccyBQgwTUKyEUayD9",
                                       "https://goo.gl/maps/tq2EdLAEjDDC3kd76",
                                       "https://goo.gl/maps/s1vwm4XCE1dgktv78",
                                       "https://goo.gl/maps/8dBz96rHDs6hbDUb7",
                                       "https://goo.gl/maps/ZGC2q87FNLSWfv7p9",
                                       "https://goo.gl/maps/Xqvdb7NBjDQRdq3t5"]
    let iphonePhysicalPrice: [String] = ["119800", "119800", "120910", "140400", "119800", "119800", "119800", "119790"]
    let iphonePhysicalImageUrl: [String] = ["https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                            "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                           "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                            "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                            "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                            "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                            "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308",
                                            "https://network.mobile.rakuten.co.jp/assets/img/product/iphone/iphone-14/pht-device-02.png?230308"]
    
    let rolandPhysicalShopName: [String] = ["BIC CAMERA Nanba Store",
                                            "Yodobashi Camera Multimedia Kyoto",
                                            "HARD OFF",
                                            "Tenrigakki",
                                            "BIGBOSS Kyoto",
                                            "JEUGIA Sanjo Main Store Piano Salon",
                                            "Asahido Gakki",
                                            "Watanabe Gakki Kyoto"]
    let rolandPhysicalUrl: [String] = ["https://goo.gl/maps/s1vwm4XCE1dgktv78",
                                       "https://goo.gl/maps/wAXy4iWCqYYfUvBB8",
                                       "https://maps.app.goo.gl/49jQMGS9gWC62wNH6?g_st=ic",
                                       "https://goo.gl/maps/MHtA9bSeoftciWFD7",
                                       "https://maps.app.goo.gl/rQpFhcvPXZxGTzoV9?g_st=ic",
                                       "https://goo.gl/maps/7AXGXfu6gBZC7cHM9",
                                       "https://goo.gl/maps/JE1zREtoAHtuofz69",
                                       "https://goo.gl/maps/vEsm3TXNBWXN14Ss9"]
    let rolandPhysicalPrice: [String] = ["88000",
                                         "90000",
                                         "98000",
                                         "92000",
                                         "95000",
                                         "93000",
                                         "96000",
                                         "89000"]
    let rolandPhysicalImageUrl: [String] = ["https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg",
                                            "https://electronicemporium.in/wp-content/uploads/2021/05/2000.jpeg"]

    
    let sampleName: [String] = ["Casio",
                                "Casio",
                                "Casio",
                                "Armitron Sport",
                                "Poounur",
                                "Amazon Essentials",
                                "Timex",
                                "LYMFHCH",
                                "Amazon Essentials",
                                "Fossil",
                                "Apple",
                                "Garmin",
                                "GRV",
                                "Casio",
                                "Apple",
                                "Anne Klein",
                                "Invicta",
                                "Armitron Sport",
                                "Michael Kors",
                                "Apple",
                                "Anne Klein",
                                "Timex",
                                "Fossil",
                                "Fossil",
                                "SAMSUNG",
                                "Anne Klein",
                                "Timex",
                                "Casio",
                                "Anne Klein",
                                "Fossil",
                                "Google",
                                "Timex",
                                "Beeasy",
                                "EURANS",
                                "Timex",
                                "Ben Stiller",
                                "Anne Klein",
                                "TORJALPH",
                                "BUREI",
                                "Timex",
                                "Timex",
                                "WM Welly Merck",
                                "Timex",
                                "Ddidbi",
                                "AGPTEK",
                                "Timex",
                                "BY BENYAR",
                                "PALADA",
                                "BY BENYAR",
                                "PALADA",
                                "Michael Kors",
                                "Woneligo",
                                "Timex",
                                "Casio",
                                "Timex",
                                "Bulova",
                                "GOLDEN HOUR",
                                "Gabb",
                                "Anne Klein",
                                "Bethany James",
                                "Disney Mickey Mouse Adult Classic Cardiff Articulating Hands Analog Quartz Leather Strap Watch",
                                "BEN NEVIS",
                                "PJYUBVOR",
                                "Casio",
                                "Amazfit",
                                "Timex",
                                "Invicta",
                                "Anne Klein",
                                "PASOY",
                                "Amazon Renewed",
                                "Anne Klein",
                                "Garmin",
                                "Casio",
                                "CakCity",
                                "Casio",
                                "Rgthuhu",
                                "Timex",
                                "Timex",
                                "ENGERWALL",
                                "Anne Klein",
                                "Casio",
                                "Citizen",
                                "Amazfit",
                                "Casio",
                                "CRRJU",
                                "Richard Dormer",
                                "SKMEI",
                                "Nerunsa",
                                "Anne Klein",
                                "Timex",
                                "Citizen",
                                "YUINK",
                                "Tensky",
                                "Timex",
                                "MAXTOP",
                                "Anne Klein",
                                "Nine West",
                                "Amazfit",
                                "ENGERWALL",
                                "Nine West",
                                "Fossil",
                                "SAMSUNG",
                                "Anne Klein",
                                "ATIMO",
                                "Timex",
                                "BY BENYAR",
                                "MILOUZ",
                                "Timex",
                                "L LAVAREDO",
                                "Tissot",
                                "Invicta",
                                "KALINCO",
                                "Fitbit",
                                "Amazon Renewed",
                                "Anne Klein",
                                "Emporio Armani",
                                "Casio",
                                "OLEVS",
                                "Upgrade 2.01-in HD Large Screen Smart Watch for Women Men Bluetooth Call Blood Glucose True Oxygen Heart Rate Temperature Reminder Information Sleep Monitoring (Black,",
                                "GOLDEN HOUR",
                                "GOLDEN HOUR",
                                "Alex Collins",
                                "Anne Klein",
                                "XCZAP",
                                "SAMSUNG",
                                "Nine West",
                                "CNBRO",
                                "MAXTOP",
                                "Timex",
                                "Anne Klein",
                                "Ben Ripley",
                                "Invicta",
                                "Anne Klein",
                                "Lutron",
                                "Casio",
                                "EIGIIS",
                                "Nine West",
                                "Geneva",
                                "Timex",
                                "SKG",
                                "Anne Klein",
                                "Apple",
                                "Nine West",
                                "Anne Klein",
                                "Anne Klein",
                                "Apple",
                                "Nine West",
                                "Anne Klein",
                                "Timex",
                                "Freestyle",
                                "Quican",
                                "Anne Klein",
                                "Stuhrling Original",
                                "BRIGADA",
                                "SAMSUNG",
                                "Anne Klein",
                                "OLEVS",
                                "GOLDEN HOUR",
                                "Iaret",
                                "Citizen",
                                "Amazfit",
                                "Fossil",
                                "Anne Klein",
                                "BUREI",
                                "Zombazi",
                                "Anne Klein",
                                "AMAZTIM",
                                "Timex",
                                "Fossil",
                                "JrTrack",
                                "Timex",
                                "Invicta",
                                "TYKOIT",
                                "Fossil",
                                "L LAVAREDO",
                                "Blake Pierce",
                                "Fossil",
                                "Garmin",
                                "Casio",
                                "YUINK",
                                "TOOBUR",
                                "Orient",
                                "Fossil",
                                "OLEVS",
                                "JoJo Siwa",
                                "Popglory",
                                "Amazon Essentials",
                                "CIGA Design",
                                "TOOBUR",
                                "Nine West",
                                "BIDEN",
                                "Unknown",
                                "Fossil",
                                "Zombazi",
                                "AMAZTIM",
                                "Anne Klein",
                                "Invicta",
                                "Accutime",
                                "JrTrack",
                                "Anne Klein",
                                "CRRJU",
                                "Fossil",
                                "TYKOIT",
                                "Timex",
                                "YOSUDA",
                                "Anne Klein",
                                "Garmin",
                                "TOOBUR",
                                "Casio",
                                "Bulova",
                                "Artist Unknown",
                                "JoJo Siwa",
                                "Timex",
                                "Popglory",
                                "Citizen",
                                "Fossil",
                                "BRIGADA",
                                "TOOBUR",
                                "Timex",
                                "Timex",
                                "Amazon Renewed",
                                "Amazon Renewed",
                                "Amazon Essentials",
                                "Unknown",
                                "HUAKUA",
                                "Anne Klein",
                                "Bethany James",
                                "Citizen",
                                "Citizen",
                                "Aptkdoe",
                                "Timex",
                                "Citizen",
                                "Amazon Renewed",
                                "Choiknbo",
                                "Hasbro",
                                "Geneva",
                                "Cvutgf",
                                "Timex",
                                "Charlie Catrall",
                                "MVMT",
                                "OLEVS",
                                "OLEVS",
                                "Colesma",
                                "OLEVS",
                                "Amazpro",
                                "Amazon Renewed",
                                "Charlie Catrall",
                                "Amazon Essentials",
                                "Unknown",
                                "MOLOCY",
                                "OLEVS",
                                "KXAITO",
                                "AHWOO",
                                "GOLDEN HOUR",
                                "Anne Klein",
                                "Citizen",
                                "Gydom",
                                "Timex",
                                "FANMIS",
                                "GOLDEN HOUR",
                                "OLEVS",
                                "GOLDEN HOUR",
                                "RUIMEN",
                                "Citizen",
                                "Timex",
                                "Citizen",
                                "Fitbit",
                                "Hasbro",
                                "Geneva",
                                "Amazon Renewed",
                                "Citizen",
                                "VRPEFIT",
                                "Timex",
                                "Timex",
                                "Popglory",
                                "MVMT",
                                "TOZO",
                                "Nine West",
                                "Anne Klein",
                                "ASWEE",
                                "Anne Klein",
                                "BUREI",
                                "Amazon Renewed",
                                "Swatch",
                                "HENGTO",
                                "Casio",
                                "Unknown",
                                "NETGEAR",
                                "FTTMWTAG",
                                "Skagen",
                                "Alex Collins",
                                "Armitron Sport",
                                "KOSPET",
                                "Anne Klein",
                                "Nine West",
                                "Casio",
                                "Bysku",
                                "Timex",
                                "OTOSAGOW",
                                "Amazon Essentials",
                                "VTech",
                                "AMIHUSEl",
                                "Timex",
                                "Amazpro",
                                "Amazon Essentials",
                                "MOLOCY",
                                "Timex",
                                "Casio",
                                "OLEVS",
                                "PASOY",
                                "Fossil",
                                "EIGIIS",
                                "Amazon Renewed",
                                "Ben Stiller",
                                "SAMSUNG",
                                "Gosasa",
                                "Gydom",
                                "Iaret"] /// sample
    let sampleUrl: [String] = ["https://www.amazon.com/Casio-AE-1500WH-8BVCF-10-Year-Battery/dp/B08VNH56LY/", "https://www.amazon.com/Casio-Classic-Quartz-Metal-Casual/dp/B01MZF6LL2/", "https://www.amazon.com/Casio-F108WH-Illuminator-Collection-Digital/dp/B0053HBJBE/", "https://www.amazon.com/Armitron-Sport-45-7012RSG-Chronograph/dp/B015RASNI8/", "https://www.amazon.com/Fitness-Activity-Smartwatch-Pedometer-Waterproof/dp/B0C6KGDPVJ/", "https://www.amazon.com/Amazon-Essentials-Silver-Tone-Black-Strap/dp/B07YQFST6X/", "https://www.amazon.com/Timex-TW4B15500-Expedition-Scout-Slip-Thru/dp/B07FFBHM7F/", "https://www.amazon.com/LYMFHCH-Military-Waterproof-Luminous-Stopwatch/dp/B07K77NTDZ/", "https://www.amazon.com/Amazon-Essentials-Digital-Chronograph-Gold-Tone/dp/B07YQFN2DQ/", "https://www.amazon.com/Fossil-Minimalist-Quartz-Stainless-Leather/dp/B06W2JSJ4H/", "https://www.amazon.com/Apple-Watch-Silver-Aluminum-Always/dp/B0BDHZQ6Y6/", "https://www.amazon.com/Garmin-V%C3%ADvoactive-Smartwatch-Features-Monitoring/dp/B07W7W8WBH/", "https://www.amazon.com/GRV-Android-Waterproof-Smartwatch-Calories/dp/B09J8SKX9G/", "https://www.amazon.com/Casio-MQ24-7B2-Analog-Watch-Black/dp/B000GB0G7A/", "https://www.amazon.com/Apple-Watch-Smart-Midnight-Aluminum/dp/B0BDHVMTPD/", "https://www.amazon.com/Anne-Klein-109442CHHY-Gold-Tone-Champagne/dp/B004X4Y9ME/", "https://www.amazon.com/Invicta-8926OB-Stainless-Automatic-Bracelet/dp/B000JQFX1G/", "https://www.amazon.com/Armitron-Sport-45-7004BLU-Chronograph/dp/B006ZTJEPC/", "https://www.amazon.com/Michael-Kors-Runway-Black-MK8507/dp/B01HEVAPSO/", "https://www.amazon.com/Apple-Cellular-Stainless-Milanese-Resistant/dp/B0BDHQVZHW/", "https://www.amazon.com/Anne-Klein-Womens-Bracelet-Watch/dp/B09WNHPB79/", "https://www.amazon.com/Timex-Womens-TW2R30300-Pattern-Leather/dp/B00IMB7JTE/", "https://www.amazon.com/Fossil-Quartz-Stainless-Steel-Chronograph/dp/B008AXYWHQ/", "https://www.amazon.com/Fossil-Neutra-Chrono-Stainless-Leather/dp/B074ZHN54C/", "https://www.amazon.com/SAMSUNG-Bluetooth-Smartwatch-Improved-Sapphire/dp/B0B2J1KDW7/", "https://www.amazon.com/Anne-Klein-Womens-104899SVTT-Two-Tone/dp/B0006MFKJS/", "https://www.amazon.com/Timex-Unisex-T2N651-Weekender-Slip-Thru/dp/B004VR9HP2/", "https://www.amazon.com/Casio-Unisex-F108WHC-7BCF-White-Resin/dp/B00AB69I10/", "https://www.amazon.com/Anne-Klein-Womens-105491SVTT-Two-Tone/dp/B000U5O5XI/", "https://www.amazon.com/Fossil-FB-01-Quartz-Stainless-Three-Hand/dp/B07XYY9X9V/", "https://www.amazon.com/Google-Pixel-Watch-Smartwatch-Stainless/dp/B0BDSGHVMW/", "https://www.amazon.com/Timex-South-Street-Sport-Watch/dp/B001RNOAM8/", "https://www.amazon.com/Beeasy-Digital-Waterproof-Stopwatch-Countdown/dp/B082X7DM3R/", "https://www.amazon.com/Touchscreen-Smartwatch-Waterproof-Pedometer-Compatible/dp/B09KH59C8K/", "https://www.amazon.com/Timex-Unisex-TWC027600-Weekender-Slip-Thru/dp/B01JO761OI/", "https://www.amazon.com/Watch-Ben-Stiller/dp/B009M8W6SA/", "https://www.amazon.com/Anne-Klein-AK-2158GNRG-Gold-Tone/dp/B07BZFWVRB/", "https://www.amazon.com/TORJALPH-Compatible-Samsung-Waterproof-Bluetooh/dp/B09TR2NNJS/", "https://www.amazon.com/BUREI-Fashion-Minimalist-Wrist-Analog/dp/B06ZYXZNXY/", "https://www.amazon.com/Timex-T5E901-Ironman-Classic-Black/dp/B000AYTYLW/", "https://www.amazon.com/Timex-T2H281-Reader-Black-Leather/dp/B000AYYIYU/", "https://www.amazon.com/Android-Monitor-Modes%EF%BC%8CVoice-Assistant-Fitness/dp/B0BL73KJTB/", "https://www.amazon.com/Timex-Easy-Reader-Day-Date-Watch/dp/B000B5459Q/", "https://www.amazon.com/Ddidbi-Waterproof-Activity-Trackers-Compatible/dp/B0C1N9VDMM/", "https://www.amazon.com/AGPTEK-Waterproof-Smartwatch-Activity-Pedometer/dp/B08HMRY8NG/", "https://www.amazon.com/Timex-T2H331-Indiglo-Leather-Silver-Tone/dp/B000AYW0M2/", "https://www.amazon.com/BENYAR-Chronograph-Movement-Waterproof-Resistant/dp/B07TJW59YZ/", "https://www.amazon.com/Sports-PALADA-Digital-Military-Backlight/dp/B015H3KYLO/", "https://www.amazon.com/BENYAR-Chronograph-Movement-Waterproof-Resistant/dp/B07TJW59YZ/", "https://www.amazon.com/Sports-PALADA-Digital-Military-Backlight/dp/B015H3KYLO/", "https://www.amazon.com/Michael-Kors-Lexington-Gold-Tone-MK8281/dp/B009DFA43Q/", "https://www.amazon.com/Fitness-Waterproof-Activity-Trackers-Smartwatches/dp/B0BTBX691N/", "https://www.amazon.com/Timex-Womens-T2H341-Reader-Leather/dp/B000AYTYK8/", "https://www.amazon.com/Casio-Quartz-Resin-Sport-Watch/dp/B001AWZDA4/", "https://www.amazon.com/Timex-TW2P75800-Reader-Gold-Tone-Leather/dp/B00YTY4ABI/", "https://www.amazon.com/Bulova-Classic-Aerojet-Automatic-98A187/dp/B0733PJGWX/", "https://www.amazon.com/GOLDEN-HOUR-Waterproof-Professionals-Students/dp/B0B8GQZ1XS/", "https://www.amazon.com/Gabb-Silver-Tracker-Parental-Controls/dp/B0BZJV95HT/", "https://www.amazon.com/Anne-Klein-AK-2706CHBK-Gold-Tone/dp/B01H1UHV5S/", "https://www.amazon.com/Watch-3-Watching-Bethany-James-ebook/dp/B01ATQ0NHO/", "https://www.amazon.com/Disney-Classic-Cardiff-Articulating-Leather/dp/B074P4JZZ8/", "https://www.amazon.com/Minimalist-Fashion-Simple-Analog-Leather/dp/B08DHZNWK7/", "https://www.amazon.com/Fitness-Tracker-Watches-Bluetooth-Smartwatch/dp/B0BC88JTTZ/", "https://www.amazon.com/Casio-Womens-MQ24-7B3LL-Classic-Black/dp/B000GAYQOK/", "https://www.amazon.com/Amazfit-Android-Satellite-Positioning-Water-Resistant/dp/B09X1NN4YS/", "https://www.amazon.com/Timex-T2M570-Cavatina-Stainless-Expansion/dp/B001FCPKN4/", "https://www.amazon.com/Invicta-Swiss-Quartz-Stainless-Casual/dp/B002PAPT1S/", "https://www.amazon.com/Anne-Klein-AK-2512LPGB-Diamond-Accented/dp/B01FY3WAFK/", "https://www.amazon.com/PASOY-Digital-Waterproof-Rubber-Watches/dp/B071RXG4LF/", "https://www.amazon.com/Garmin-Fitness-Smartphone-Certified-Refurbished/dp/B00J420IHA/", "https://www.amazon.com/Anne-Klein-109168WTWT-Gold-Tone-Leather/dp/B0030DFF9A/", "https://www.amazon.com/Garmin-Smartwatch-Touchscreen-Features-010-02426-01/dp/B08FRQFBPC/", "https://www.amazon.com/Casio-Womens-LQ139A-1B3-Black-Classic/dp/B000GB0G2K/", "https://www.amazon.com/CakCity-Military-Waterproof-Luminous-Stopwatch/dp/B018HTGSN8/", "https://www.amazon.com/Casio-Diver-Style-Quartz-Casual/dp/B01L0APB5C/", "https://www.amazon.com/Rgthuhu-Military-Watches-Waterproof-Android/dp/B0BW47DC1H/", "https://www.amazon.com/Timex-Womens-Avenue-Quartz-Leather/dp/B0977RCSS3/", "https://www.amazon.com/Timex-T49870-Expedition-Metal-Leather/dp/B004VRD6FY/", "https://www.amazon.com/ENGERWALL-Smartwatch-Temperature-Pedometer-Notifications/dp/B08PF9V27X/", "https://www.amazon.com/Anne-Klein-Womens-10-6419SVTT-Two-Tone/dp/B000MPO6N0/", "https://www.amazon.com/Casio-Vintage-Digital-Stainless-A168WG9UR/dp/B002LAS086/", "https://www.amazon.com/Citizen-Eco-Drive-Stainless-display-BM8180-03E/dp/B000EQS1JW/", "https://www.amazon.com/Amazfit-Smartwatch-Military-Certified-Waterproof/dp/B08X9WS6VW/", "https://www.amazon.com/Casio-Womens-LQ139B-1B-Classic-Analog/dp/B000GB0G5M/", "https://www.amazon.com/CRRJU-Multifunctional-Chronograph-Wristwatches-Stainsteel/dp/B07F2V9BQ2/", "https://www.amazon.com/A-Near-Vimes-Experience/dp/B08R2MD3T9/", "https://www.amazon.com/Waterproof-Military-Electronic-Stopwatch-Luminous/dp/B01BA77L12/", "https://www.amazon.com/Smartwatch-Waterproof-Fitness-Activity-Pedometer/dp/B0C89CK95W/", "https://www.amazon.com/Anne-Klein-AK-1981WTSV-Silver-Tone/dp/B07MDCW3CT/", "https://www.amazon.com/Timex-T2P298-Two-Tone-Stainless-Expansion/dp/B00HYUS5PG/", "https://www.amazon.com/Citizen-Eco-Drive-Chronograph-Stainless-Perpetual/dp/B0B7Y2QN8N/", "https://www.amazon.com/YUINK-Ultra-Thin-Multifunctional-Chronograph-Minimalist/dp/B08JY7T5D2/", "https://www.amazon.com/Receive-Fitness-Tracking-Waterproof-Smartwatch/dp/B0BFQ36XPW/", "https://www.amazon.com/Timex-Womens-Easy-Reader-Watch/dp/B08TX6NWW5/", "https://www.amazon.com/MAXTOP-Fitness-Waterproof-Monitoring-Pedometer/dp/B0BX2XTBFF/", "https://www.amazon.com/Anne-Klein-AK-2434CHGB-Diamond-Accented/dp/B01940RVO4/", "https://www.amazon.com/Nine-West-NW-1981GYRT-Silver-Tone/dp/B06XDMBBFK/", "https://www.amazon.com/Amazfit-Smartwatch-Military-Certified-Waterproof/dp/B08X9WS6VW/", "https://www.amazon.com/ENGERWALL-Smartwatch-Temperature-Pedometer-Notifications/dp/B08PF9V27X/", "https://www.amazon.com/Nine-West-Dress-Watch-Model/dp/B08TB69GM2/", "https://www.amazon.com/Fossil-Womens-Riley-Quartz-Stainless/dp/B004D4S7AY/", "https://www.amazon.com/Samsung-Classic-Smartwatch-Monitor-Detection/dp/B096BMJPL8/", "https://www.amazon.com/Anne-Klein-Dress-Watch-Model/dp/B08H5WTDWH/", "https://www.amazon.com/ATIMO-Digital-Birthday-Present-Sports/dp/B07GPZ8NHD/", "https://www.amazon.com/Timex-Womens-T2P370-Weekender-Slip-Thru/dp/B00HYUSA74/", "https://www.amazon.com/BENYAR-Waterproof-Multifunction-Chronograph-Wristwatches/dp/B07X7MC5LQ/", "https://www.amazon.com/Bluetooth-Built-in1-8-Notification-Activity-Trackers/dp/B0C4YB3QBF/", "https://www.amazon.com/Timex-T2H311-Two-Tone-Stainless-Expansion/dp/B000AYSH2E/", "https://www.amazon.com/Mens-Digital-Watch-Waterproof-Chronograph/dp/B085HJ5K7V/", "https://www.amazon.com/Tissot-Gentleman-Swiss-Automatic-Stainless/dp/B07XTVQ3W7/", "https://www.amazon.com/Invicta-0070-Collection-Chronograh-Silver-Tone/dp/B000820YBU/", "https://www.amazon.com/KALINCO-Pressure-Tracking-Smartwatch-Compatible/dp/B08XM8X4VQ/", "https://www.amazon.com/Fitbit-Smartwatch-Readiness-Exercise-Tracking/dp/B0B4MWCFV4/", "https://www.amazon.com/Apple-Watch-GPS-40MM-Aluminum/dp/B0842BFWZV/", "https://www.amazon.com/Anne-Klein-AK-2787SVTT-Two-Tone/dp/B01H1V6JMS/", "https://www.amazon.com/Emporio-Armani-AR1808-Dress-Silver/dp/B00JGODRKQ/", "https://www.amazon.com/CASIO-Digital-World-A500WGA-1DF-Stainless/dp/B00N5TJ0PY/", "https://www.amazon.com/OLEVS-Chronograph-Stainless-Waterproof-Luminous/dp/B0B8RYKNVN/", "https://www.amazon.com/Bluetooth-Temperature-Reminder-Information-Monitoring/dp/B0CB29LC2V/", "https://www.amazon.com/GOLDEN-HOUR-Ultra-Thin-Minimalist-Waterproof/dp/B0B4V76LFG/", "https://www.amazon.com/GOLDEN-HOUR-Stainless-Waterproof-Chronograph/dp/B087JG6H25/", "https://www.amazon.com/Watching-Olman-County-Book-7-ebook/dp/B07BH6R23S/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Leather/dp/B09N43D1G3/", "https://www.amazon.com/Ladies-Outdoor-Watches-Waterproof-Digital/dp/B09KLP8BR6/", "https://www.amazon.com/Samsung-Galaxy-Watch-Smartwatch-Detection/dp/B096BK7W5M/", "https://www.amazon.com/Nine-West-Dress-Watch-Model/dp/B08TB2XS6V/", "https://www.amazon.com/Womens-Waterproof-Watches-Minimalist-Simple/dp/B089SVM2YP/", "https://www.amazon.com/MAXTOP-Fitness-Waterproof-Monitoring-Pedometer/dp/B0BX2XTBFF/", "https://www.amazon.com/Timex-T26481-Charles-Two-Tone-Expansion/dp/B000SQM5AY/", "https://www.amazon.com/Anne-Klein-AK-2626RGRG-Diamond-Accented/dp/B01H5CQFPO/", "https://www.amazon.com/Watch-Muse-Distribution-International/dp/B01G4FWLTW/", "https://www.amazon.com/Invicta-Speedway-Collection-Stainless-Chronograph/dp/B0006AAS5G/", "https://www.amazon.com/Anne-Klein-Japanese-Quartz-Leather/dp/B096L2FZWL/", "https://www.amazon.com/Lutron-Wireless-Lighting-P-BDG-PKG2W-Assistant/dp/B01M3XJUAD/", "https://www.amazon.com/Casio-Classic-Quartz-Stainless-Steel/dp/B07G2PTN7C/", "https://www.amazon.com/EIGIIS-Military-Tactical-Smartwatch-Compatible/dp/B0C2PMJLK6/", "https://www.amazon.com/Nine-West-Womens-Strap-Watch/dp/B08WFBJ3YF/", "https://www.amazon.com/Black-Super-Large-Stretch-Fashion/dp/B00OIDGJEQ/", "https://www.amazon.com/Timex-Reader-Quartz-Leather-Casual/dp/B0977QVRJS/", "https://www.amazon.com/SKG-Swimming-Waterproof-Smartwatch-Android-iPhone/dp/B09YD5MQPP/", "https://www.amazon.com/Anne-Klein-AK-2435SVTT-Diamond-Accented/dp/B01940RV08/", "https://www.amazon.com/Apple-Cellular-Titanium-Precision-Extra-Long/dp/B0BDJ9M2K4/", "https://www.amazon.com/Nine-West-Womens-Strap-Watch/dp/B09HV7W5SS/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Stainless/dp/B09NWHFFT9/", "https://www.amazon.com/Anne-Klein-AK-2435SVTT-Diamond-Accented/dp/B01940RV08/", "https://www.amazon.com/Apple-Cellular-Titanium-Precision-Extra-Long/dp/B0BDJ9M2K4/", "https://www.amazon.com/Nine-West-Womens-Strap-Watch/dp/B09HV7W5SS/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Stainless/dp/B09NWHFFT9/", "https://www.amazon.com/Timex-Womens-T20433-Gold-Tone-Leather/dp/B000N5Z64W/", "https://www.amazon.com/Freestyle-Shark-Japanese-Quartz-Sport-Watch/dp/B01LY94KUW/", "https://www.amazon.com/Quican-Bluetooth-Compatible-Waterproof-Smartwatch/dp/B0C5QVZGFR/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Quartz/dp/B09WNH6WVF/", "https://www.amazon.com/Stuhrling-Original-Blue-Watches-Men/dp/B07H3C1TRK/", "https://www.amazon.com/BRIGADA-Womens-Fashion-Elegant-Leather/dp/B09B1NQYM7/", "https://www.amazon.com/SAMSUNG-Smartwatch-Improved-Sapphire-Tracking/dp/B0B2JFNZSD/", "https://www.amazon.com/Anne-Klein-Womens-10-5404CHGB-Gold-Tone/dp/B000PU1EBO/", "https://www.amazon.com/Numerals-Chronograph-Stainless-Multi-Function-Resistant/dp/B09W9C9K9X/", "https://www.amazon.com/Fashion-Stainless-Waterproof-Chronograph-Watches/dp/B07YQRKJP4/", "https://www.amazon.com/Iaret-Receive-Waterproof-Smartwatch-Pedometer/dp/B0B499VHNZ/", "https://www.amazon.com/Citizen-Brycen-Japanese-Quartz-Stainless/dp/B086BB9BL9/", "https://www.amazon.com/Amazfit-Android-Dual-Band-Bluetooth-Battery/dp/B0B8YR3KZS/", "https://www.amazon.com/Fossil-Quartz-Stainless-Leather-Chronograph/dp/B008AXURAW/", "https://www.amazon.com/Anne-Klein-AK-1019WTWT-Diamond-Accented/dp/B008BLZTU6/", "https://www.amazon.com/Digital-Watches-Electronic-Stopwatch-Backlight/dp/B077GYY775/", "https://www.amazon.com/Fitness-Tracker-Monitor-Assistant-Smartwatch/dp/B0C2Z1CWJP/", "https://www.amazon.com/Anne-Klein-AK-2246CRNV-Gold-Tone/dp/B00ZHX57OE/", "https://www.amazon.com/AMAZTIM-Extra-Long-Waterproof-Bluetooth-Assistant/dp/B0BS3TZHBV/", "https://www.amazon.com/Timex-TW5M35000-Ironman-Transit-Gold-Tone/dp/B083JW3W8D/", "https://www.amazon.com/Fossil-ME3098-Analog-Display-Automatic/dp/B01487C7CO/", "https://www.amazon.com/JrTrack-Messaging-Childrens-Smartphone-Alternative/dp/B0BHF481X5/", "https://www.amazon.com/Timex-Marathon-Quartz-Digital-TW5M14400/dp/B08S63NTHZ/", "https://www.amazon.com/Invicta-1771-Collection-Stainless-Chronograph/dp/B005FN0ZA2/", "https://www.amazon.com/Tracking-Touchscreen-Smartwatch-Waterproof-Pedometer/dp/B0C1GNXTSW/", "https://www.amazon.com/Fossil-Jacqueline-Stainless-Leather-Calfskin/dp/B0725JPR4Z/", "https://www.amazon.com/LAVAREDO-Extremely-Minimalist-Birthday-Boyfriend/dp/B0C3QGHKGX/", "https://www.amazon.com/Watching-Making-Riley-Paige-Book-1-ebook/dp/B07CLK2369/", "https://www.amazon.com/Fossil-Womens-Raquel-Stainless-Three-Hand/dp/B0B4H6K6J7/", "https://www.amazon.com/Garmin-Smartwatch-Advanced-Monitoring-Features/dp/B099X8RSWN/", "https://www.amazon.com/Casio-Tough-Solar-AQ-S810W-1AVCF-Combination/dp/B00791R1MI/", "https://www.amazon.com/YUINK-Ultra-Thin-Multifunctional-Chronograph-Minimalist/dp/B08LBRTC4R/", "https://www.amazon.com/TOOBUR-Waterproof-Fitness-Tracker-Compatible/dp/B0BW43XJ94/", "https://www.amazon.com/Stainless-Japanese-Automatic-Winding-Sapphire/dp/B09NZD9W5X/", "https://www.amazon.com/Fossil-Quartz-Stainless-Leather-Casual/dp/B001T6OPZ0/", "https://www.amazon.com/OLEVS-Stainless-Wristwatch-Chronograph-Waterproof/dp/B0B4JWSCRL/", "https://www.amazon.com/Jojo-Siwa-Touchscreen-Model-JOJ4128AZ/dp/B07T5GBT9W/", "https://www.amazon.com/Popglory-Receive-Smartwatch-Control-Pressure/dp/B0B9MX76FB/", "https://www.amazon.com/Amazon-Essentials-Digital-Chronograph-Black/dp/B07YQFY579/", "https://www.amazon.com/CIGA-Design-Mechanical-Automatic-Planet/dp/B0BW89J9VJ/", "https://www.amazon.com/TOOBUR-Fitness-Tracker-Waterproof-Compatible/dp/B0C4GPPD1H/", "https://www.amazon.com/Nine-West-Womens-Japanese-Stainless/dp/B0979QJWQJ/", "https://www.amazon.com/Watches-Chronograph-Stainless-Waterproof-Business/dp/B07Z62B354/", "https://www.amazon.com/Fashion-Watch-Wholesale-Geneva-Stretch/dp/B076VTWXX4/", "https://www.amazon.com/Fossil-Quartz-Stainless-Steel-Chronograph/dp/B006GVP11A/", "https://www.amazon.com/Fitness-Tracker-Monitor-Assistant-Smartwatch/dp/B0C2Z1CWJP/", "https://www.amazon.com/AMAZTIM-Extra-Long-Waterproof-Bluetooth-Assistant/dp/B0BS3TZHBV/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Leather/dp/B09NWDL1ZT/", "https://www.amazon.com/Invicta-Diver-Stainless-Charcoal-Quartz/dp/B07SH1LNRV/", "https://www.amazon.com/Accutime-Microsoft-Minecraft-Educational-Touchscreen/dp/B08YFKKRY3/", "https://www.amazon.com/JrTrack-Messaging-Childrens-Smartphone-Alternative/dp/B0BHF481X5/", "https://www.amazon.com/Anne-Klein-Womens-Strap-AK/dp/B099X9LMW4/", "https://www.amazon.com/Minimalist-Waterproof-Military-Classic-Pointer/dp/B07MB37YJ8/", "https://www.amazon.com/Fossil-Machine-Stainless-Silicone-Chronograph/dp/B002T1M8A8/", "https://www.amazon.com/Tracking-Touchscreen-Smartwatch-Waterproof-Pedometer/dp/B0C1GNXTSW/", "https://www.amazon.com/Timex-TW2R98600-Crisscross-25mm-Two-Tone-Expansion/dp/B07FF9W9NZ/", "https://www.amazon.com/YOSUDA-Indoor-Cycling-Bike-Stationary/dp/B09NP3RF16/", "https://www.amazon.com/Anne-Klein-AK-1362GNGB-Diamond-Accented/dp/B079TY8G28/", "https://www.amazon.com/Garmin-Smartwatch-Advanced-Monitoring-Features/dp/B099X8RSWN/", "https://www.amazon.com/TOOBUR-Waterproof-Fitness-Tracker-Compatible/dp/B0BW43XJ94/", "https://www.amazon.com/Casio-MQ24-1B-3-Hand-Analog-Resistant/dp/B008Z42IPI/", "https://www.amazon.com/Bulova-Mens-Precisionist-98B315-Blue/dp/B07G62TDMS/", "https://www.amazon.com/Fashion-Watch-Wholesale-Geneva-Stretch/dp/B076VVYKKH/", "https://www.amazon.com/Jojo-Siwa-Touchscreen-Model-JOJ4128AZ/dp/B07T5GBT9W/", "https://www.amazon.com/Timex-T21854-Pleasant-Stainless-Expansion/dp/B00008IM8Q/", "https://www.amazon.com/Popglory-Receive-Smartwatch-Control-Pressure/dp/B0B9MX76FB/", "https://www.amazon.com/Citizen-Womens-Classic-Eco-Drive-Watch/dp/B09Z34HRY9/", "https://www.amazon.com/Fossil-Copeland-Stainless-Quartz-Leather/dp/B07WGWGMBM/", "https://www.amazon.com/Watches-Minimalist-Simple-Business-Waterproof/dp/B08FD4QYSB/", "https://www.amazon.com/TOOBUR-Fitness-Tracker-Waterproof-Compatible/dp/B0C4GPPD1H/", "https://www.amazon.com/Timex-T2M827-Gold-Tone-Stainless-Expansion/dp/B001BXS0GQ/", "https://www.amazon.com/Timex-Womens-Perfect-Stainless-Two-Tone/dp/B099SZ5N58/", "https://www.amazon.com/Apple-Watch-SE-Cellular-40mm/dp/B08L3VTNQZ/", "https://www.amazon.com/Samsung-Galaxy-Watch-40mm-WiFi/dp/B09LBKSCG3/", "https://www.amazon.com/Amazon-Essentials-Two-Tone-AE-5005WTTT/dp/B085WQYRS7/", "https://www.amazon.com/Fashion-Watch-Wholesale-Geneva-Stretch/dp/B076VWBGR1/", "https://www.amazon.com/HUAKUA-Watches-Compatible-Android-Waterproof/dp/B0BWJZW8WL/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Plastic/dp/B09KYFQYXZ/", "https://www.amazon.com/Watching-1-Bethany-James-ebook/dp/B0175CSTSK/", "https://www.amazon.com/Citizen-Quartz-Dress-Stainless-Silver-Tone/dp/B09JGGL2MT/", "https://www.amazon.com/Citizen-Eco-Drive-Quartz-Stainless-Leather/dp/B07992MDJQ/", "https://www.amazon.com/Aptkdoe-Waterproof-Smartwatch-Activity-Pedometer/dp/B0C4YD1SZL/", "https://www.amazon.com/Timex-TW2R23700-Silver-Tone-Stainless-Bracelet/dp/B01NCM3P3R/", "https://www.amazon.com/Citizen-Eco-Drive-Silhouette-Crystal-FE1140-86L/dp/B00UMDFVFY/", "https://www.amazon.com/Apple-Watch-Starlight-Aluminum-Regular/dp/B09PDZYL6F/", "https://www.amazon.com/Choiknbo-Fitness-Tracker-SmartWatch-Waterproof/dp/B09Q5SSYFH/", "https://www.amazon.com/Yokai-Watch-Model-Zero/dp/B01BQ9S50U/", "https://www.amazon.com/Silver-Super-Large-Stretch-Fashion/dp/B00NUJWHUE/", "https://www.amazon.com/Fitness-Activity-Smartwatch-Waterproof-Compatible/dp/B0BY8T8R3X/", "https://www.amazon.com/Timex-Womens-Reader-Perfect-Watch/dp/B09RTQBTMR/", "https://www.amazon.com/Watching-Charlie-Catrall/dp/B071DVW5YG/", "https://www.amazon.com/MVMT-Signature-Square-Womens-Charlie/dp/B0873DQ7DJ/", "https://www.amazon.com/OLEVS-Watches-Multi-Function-Chronograph-Resistant/dp/B09VPJ8P47/", "https://www.amazon.com/Stainless-OLEVS-Automatic-Waterproof-Tourbillon/dp/B09ZB6TNHL/", "https://www.amazon.com/Colesma-SmartWatch-Compatible-Smartwatches-Waterproof/dp/B0B5SYZKQ5/", "https://www.amazon.com/OLEVS-Automatic-Stainless-Winding-Watches/dp/B0B93212PQ/", "https://www.amazon.com/Amazpro-Tactical-Smartwatch-Bluetooth-Waterproof/dp/B0C4SMFHN9/", "https://www.amazon.com/Samsung-Galaxy-Watch-40mm-WiFi/dp/B09LBKSCG3/", "https://www.amazon.com/Watching-Charlie-Catrall/dp/B071DVW5YG/", "https://www.amazon.com/Amazon-Essentials-Two-Tone-AE-5005WTTT/dp/B085WQYRS7/", "https://www.amazon.com/Fashion-Watch-Wholesale-Geneva-Stretch/dp/B076VWBGR1/", "https://www.amazon.com/Smartwatch-Waterproof-Pedometer-Calories-Activity/dp/B0BD51K2ZF/", "https://www.amazon.com/Automatic-Mechanical-Waterproof-Luminous-Stainless/dp/B08Q83Y57J/", "https://www.amazon.com/KXAITO-Waterproof-Military-Stopwatch-8049_Blue/dp/B09VKR4LHF/", "https://www.amazon.com/AHWOO-%EF%BC%8CFitness-Smartwatches-Fulltouch-Compatible/dp/B0BVBKJ8G2/", "https://www.amazon.com/GOLDEN-HOUR-Ultra-Thin-Minimalist-Waterproof/dp/B0B4V76LFG/", "https://www.amazon.com/Anne-Klein-Womens-Japanese-Plastic/dp/B09KYFQYXZ/", "https://www.amazon.com/Citizen-Quartz-Dress-Stainless-Silver-Tone/dp/B09JGGL2MT/", "https://www.amazon.com/Gydom-Watches-Activity-Trackers-Waterproof/dp/B0BRCZXGQW/", "https://www.amazon.com/Timex-T2N092-Gold-Tone-Extra-Long-Stainless/dp/B004X3ZE9W/", "https://www.amazon.com/Fanmis-Business-Stainless-Calendar-Resistant/dp/B06XHJY5XZ/", "https://www.amazon.com/Fashion-Stainless-Waterproof-Chronograph-Watches/dp/B08HQN6NJK/", "https://www.amazon.com/OLEVS-Automatic-Mechanical-Waterproof-Black-Gold/dp/B0BRP5GVTC/", "https://www.amazon.com/GOLDEN-HOUR-Watches-Minimalist-Stainless/dp/B09JC9D4HV/", "https://www.amazon.com/RUIMEN-Assistant-Inteligente-Smartwatchs-Waterproof/dp/B0BL27BC6G/", "https://www.amazon.com/Citizen-Eco-Drive-Quartz-Stainless-Leather/dp/B07992MDJQ/", "https://www.amazon.com/Timex-TW2R23700-Silver-Tone-Stainless-Bracelet/dp/B01NCM3P3R/", "https://www.amazon.com/Citizen-Eco-Drive-Silhouette-Crystal-FE1140-86L/dp/B00UMDFVFY/", "https://www.amazon.com/Fitbit-Fitness-Smartwatch-Tracking-Included/dp/B07TWFVDWT/", "https://www.amazon.com/Yokai-Watch-Model-Zero/dp/B01BQ9S50U/", "https://www.amazon.com/Silver-Super-Large-Stretch-Fashion/dp/B00NUJWHUE/", "https://www.amazon.com/SAMSUNG-Smartwatch-Monitor-Detection-Bluetooth/dp/B09F5KF2VT/", "https://www.amazon.com/Citizen-Eco-Drive-Weekender-Avion-Stainless/dp/B0B917GYLB/", "https://www.amazon.com/Fitness-Tracker-Monitor-Waterproof-Android/dp/B0BRXSNZNJ/", "https://www.amazon.com/Timex-Mens-Expedition-Digital-Watch/dp/B08TYGD95K/", "https://www.amazon.com/Timex-Womens-Reader-Perfect-Watch/dp/B09RTQBTMR/", "https://www.amazon.com/Popglory-Smartwatch-Pressure-Monitor-Fitness/dp/B08DXKC653/", "https://www.amazon.com/MVMT-Signature-Square-Womens-Charlie/dp/B0873DQ7DJ/", "https://www.amazon.com/TOZO-S2-Waterproof-Touchscreen-Compatible/dp/B0BK1Q3G88/", "https://www.amazon.com/Nine-West-NW-2274MAWT-Rubberized/dp/B07MZ6LFVN/", "https://www.amazon.com/Anne-Klein-AK-3294RGST/dp/B07FTC4Z4T/", "https://www.amazon.com/ASWEE-Fitness-Pressure-Waterproof-Smartwatch/dp/B0C32VNY83/", "https://www.amazon.com/Anne-Klein-Glitter-Accented-Bracelet/dp/B09SJ5VRFS/", "https://www.amazon.com/BUREI-Fashion-Minimalist-Analog-Leather/dp/B07Q7NQ3WB/", "https://www.amazon.com/Apple-Watch-GPS-Cellular-40MM/dp/B083M8QB9Q/", "https://www.amazon.com/Swatch-Standard-Quartz-Silicone-Casual/dp/B099FM7XSR/", "https://www.amazon.com/HENGTO-Fitness-Tracker-Waterproof-Pedometers/dp/B09VBMYWK8/", "https://www.amazon.com/Casio-Illuminator-Resistant-Battery-MWA100HD-1AV/dp/B08FVHJ1ZJ/", "https://www.amazon.com/Fashion-Watch-Wholesale-Geneva-Stretch/dp/B07D3FR9R8/", "https://www.amazon.com/NETGEAR-Wi-Fi-Range-Extender-EX3700/dp/B00R92CL5E/", "https://www.amazon.com/Smartwatch-Fitness-Waterproof-Pressure-Tracker-Black/dp/B0BGMWYY8L/", "https://www.amazon.com/Skagen-Quartz-Stainless-Steel-leather/dp/B01LC11J50/", "https://www.amazon.com/Watching-Olman-County-Book-7-ebook/dp/B07BH6R23S/", "https://www.amazon.com/Armitron-Sport-Digital-45-7126PBH/dp/B081R3RXKT/", "https://www.amazon.com/KOSPET-Fitness-Tracker-Waterproof-Tracking/dp/B0C538DYNP/", "https://www.amazon.com/Anne-Klein-AK-3286WTST/dp/B07FTM6XRL/", "https://www.amazon.com/Nine-West-NW-2116TPRG-Gold-Tone/dp/B074W98WF8/", "https://www.amazon.com/Casio-W-800H-1BVES-Mens-Black-Watch/dp/B08BRDB4LS/", "https://www.amazon.com/Monitor-Painless-Non-invasive-Pressure-Tracking/dp/B0C9WYXX8G/", "https://www.amazon.com/Timex-T2P457-Silver-Tone-Stainless-Bracelet/dp/B00LW3R886/", "https://www.amazon.com/OTOSAGOW-Bluetooth-Waterproof-Fitness-Compatible/dp/B0C36YPWSQ/", "https://www.amazon.com/Amazon-Essentials-Unisex-Bracelet-Watch/dp/B0BKGDG7H9/", "https://www.amazon.com/VTech-KidiZoom-Smartwatch-DX3-Black/dp/B09PDCGDHM/", "https://www.amazon.com/AMIHUSEl-Military-Bluetooth-Waterproof-Smartwatch/dp/B0C137KSQV/", "https://www.amazon.com/Timex-T2P457-Silver-Tone-Stainless-Bracelet/dp/B00LW3R886/", "https://www.amazon.com/Amazpro-Tactical-Smartwatch-Bluetooth-Waterproof/dp/B0C4SMFHN9/", "https://www.amazon.com/Amazon-Essentials-Unisex-Bracelet-Watch/dp/B0BKGDG7H9/", "https://www.amazon.com/Smartwatch-Waterproof-Pedometer-Calories-Activity/dp/B0BD51K2ZF/", "https://www.amazon.com/Timex-T80-34mm-Watch-Stainless/dp/B08J9CN8P7/", "https://www.amazon.com/Casio-Battery-Quartz-Stainless-Steel/dp/B01GI9Z1EG/", "https://www.amazon.com/OLEVS-Stainless-Skeleton-Chronograph-Waterproof/dp/B0BVG85N1V/", "https://www.amazon.com/PASOY-Stainless-Multifunction-Stopwatch-Waterproof/dp/B09C25GV9G/", "https://www.amazon.com/Fossil-Womens-Jesse-Quartz-Stainless/dp/B005LBZON6/", "https://www.amazon.com/Military-Waterproof-Smartwatch-Bluetooth-Compatible/dp/B09B9TB61G/", "https://www.amazon.com/Samsung-Galaxy-Watch-Black-Bluetooth/dp/B07QP9N9DF/", "https://www.amazon.com/Watch-Ben-Stiller/dp/B0B8LZ5J66/", "https://www.amazon.com/Galaxy-Watch3-LTE-Monitoring-45MM/dp/B08QDSSKNL/", "https://www.amazon.com/Luxury-Crystal-Diamond-Watches-Stainless/dp/B08LZDT83Q/", "https://www.amazon.com/Gydom-Watches-Activity-Trackers-Waterproof/dp/B0BRCZXGQW/", "https://www.amazon.com/Iaret-Fitness-Waterproof-Smartwatch-Pedometer/dp/B0B85GYPD5/"] /// sample
    
    let samplePrice: [String] = ["24.9", "13.0", "16.88", "18.16", "39.99", "16.9", "33.34", "14.73", "16.9", "63.18", "309.99", "169.99", "24.59", "15.48", "229.99", "23.08", "48.0", "14.24", "83.0", "629.99", "45.5", "27.78", "72.87", "91.01", "170.05", "26.99", "36.4", "22.99", "26.28", "79.0", "249.99", "42.07", "13.59", "15.99", "30.62", "3.79", "28.0", "18.99", "20.79", "39.99", "32.9", "29.69", "37.7", "31.99", "44.99", "33.4", "31.99", "15.99", "31.99", "15.99", "112.0", "30.96", "31.99", "21.92", "39.99", "204.37", "20.31", "112.49", "24.56", "0.99", "14.55", "21.59", "23.99", "15.7", "59.49", "38.95", "45.97", "27.99", "9.99", "119.99", "24.95", "119.99", "15.4", "16.99", "26.92", "39.99", "26.52", "43.45", "18.99", "31.33", "43.95", "119.0", "104.63", "14.17", "31.19", "1.99", "15.99", "29.99", "39.99", "43.4", "261.1", "19.19", "45.98", "0", "27.99", "33.99", "20.81", "104.63", "18.99", "20.77", "68.08", "183.02", "39.48", "17.99", "38.95", "31.99", "39.99", "40.89", "13.59", "570.99", "58.54", "23.99", "139.95", "149.0", "27.48", "160.0", "54.0", "31.1", "279.8", "14.39", "33.91", "4.99", "27.99", "14.39", "151.05", "19.94", "16.88", "27.99", "43.48", "28.48", "0", "46.87", "34.99", "79.95", "16.88", "39.99", "22.67", "13.9", "32.65", "34.99", "31.65", "772.19", "27.49", "50.99", "31.65", "772.19", "27.49", "50.99", "33.75", "65.0", "74.9", "52.43", "69.99", "15.99", "379.19", "31.99", "31.1", "28.79", "39.99", "0", "169.99", "80.0", "41.14", "25.99", "59.98", "22.37", "79.99", "51.88", "135.96", "69.99", "14.5", "43.32", "17.59", "67.31", "21.59", "0.0", "119.0", "300.0", "30.99", "19.19", "29.95", "309.89", "80.0", "31.1", "14.99", "36.79", "14.5", "1329.3", "36.79", "24.99", "41.99", "13.16", "89.56", "59.98", "79.99", "27.99", "92.95", "54.98", "69.99", "28.99", "34.38", "97.23", "17.59", "45.27", "247.99", "56.0", "300.0", "29.95", "17.99", "409.88", "16.32", "14.99", "40.48", "36.79", "134.0", "70.0", "19.99", "36.79", "46.2", "48.3", "158.0", "88.98", "25.75", "12.32", "35.19", "41.99", "0.99", "0", "180.49", "39.99", "39.06", "115.28", "260.0", "19.25", "12.99", "12.26", "29.99", "33.06", "2.99", "103.5", "31.02", "110.4", "39.99", "79.02", "43.0", "88.98", "2.99", "25.75", "12.32", "24.99", "111.1", "19.99", "16.49", "14.39", "41.99", "0", "39.99", "59.84", "20.0", "28.79", "71.1", "29.59", "39.99", "180.49", "39.06", "115.28", "90.99", "12.99", "12.26", "89.99", "160.0", "35.98", "36.4", "33.06", "23.99", "103.5", "33.98", "21.26", "33.47", "29.73", "32.99", "20.79", "150.0", "64.2", "29.59", "40.99", "15.99", "20.79", "25.49", "60.15", "4.99", "17.99", "79.99", "37.79", "22.99", "27.99", "32.47", "31.49", "39.99", "29.25", "33.72", "39.91", "31.49", "43.0", "29.25", "24.99", "69.0", "0", "31.82", "15.99", "79.0", "39.99", "64.0", "0", "79.99", "15.99", "39.99", "47.99"] /// sample
    
    let sampleImageUrl: [String] = ["https://m.media-amazon.com/images/I/81bXL4Y6XXL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51yV7Ca-IIL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/510T962DtNL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71lyh92liiL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81Bq9T6Vk-L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81SkKZjDDyL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91APJ9+qs2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61AepCrYDOL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71F6fyefIGL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81ZP4QF1qCL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71xSYnvg7OL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51VG5cWFoCL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51jzaIqrKNL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/811OLK4PV+L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71lG7br7k1L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81BmJymxqLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71RdP+pYfbL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81dVjlmIgUL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71sMS5i3wxL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91DRCHFCw0L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71aqv9U7oYL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91t51u4kDpL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/718AVhhc1GL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71rxMdEC2KL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/41tAjmmEWyL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61u6FrBLweL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81Pnn76U1kL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61I4-4bPxjS._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81JVXUTHKVL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61M5EMiKYGL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61GWeXVQSdL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81PPYtQNSWL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71rT69t8GVL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61edry5rsxL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81TCoSpGnPL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81wWSBDKZpL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81SNtMRH2dL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71NrPRCvFRL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/7121lR-otMS._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71mewE+svdL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71S-CCwawqL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61XdkEwY5wL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51wAVCggW2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71+BP1gTN2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71JfGjxM5lL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71u9dpDC9HL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71sj7eCYG9L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61srikhJ1IL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71sj7eCYG9L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61srikhJ1IL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/615TwAMB9xL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/716QBWsdfuL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71LLdM2d7QL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/6159sqOpeSL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/41B0bJPcVPL._AC_UL1000_QL65_.jpg", "https://m.media-amazon.com/images/I/81fuTaD5wzL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/619Vk5pRVjL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61AhRNbrHBL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71Sbjr41u5L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81+kaX84rEL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61HbivsTv0L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61QeNWSSHaL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71pBtMd2vjL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71oXNZtH7bS._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61IX7x2YwZL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71jeOTTKRmL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71kmaM6mZvL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81E-Lr-ytLL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/715VRasD1gL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61x47Alb+WL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81ljgROP1eL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61WZfhUL3sL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61xNup8vYaL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61zN+q26d6L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81ihNhmMQxL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71eeeyUk2eL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71StX0FceBL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81VTDAH0ESL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61YvYiLUxDS._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81OXf0ujDsL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71dvbXsH+VL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81t0KQkVwpS._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71HvekeiFkL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81H5GpCx2hL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71G3W5z0F2L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/91mZ4eCUK7L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61wj7YyOmGL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71qoQVetqhL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71x+MLEWtoL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71RPQNOyz9L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81Fz3QXbeDL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71RA4WUklbL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71cB+13yVmL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81w8q+NKBrL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61MgaIRCQKL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81Vge+DyWlL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/9183p+ExCVL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71HvekeiFkL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61YvYiLUxDS._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71CQ9ttRVUL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61lk-YxTUAL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71VNyRYDQeL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71u+AkEZZpL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71Q-hS9O0LL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81aPPs3+hSL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71kzslUzjHL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71l6cnvwnXL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71QDv-ByTxL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71-+WIi-X3L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71s0PeB7iaL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81JIcyPY3CL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61zRr8F0u9L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61CZSoSnVPL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71nbXdvdGfL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81K7PRwX9oL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/713nE6NPjLL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71tok+TONdL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71LFOpzmgtL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71BM5VNe8mL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71d-h1sP17L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61hwd7aAmnL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81QyjCYpxcL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71gyKE38oHL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/5116juOrQcL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61em2RBifsL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71J1J+zOePL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61IyreFHFFL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61MgaIRCQKL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81JXZ9C9AuL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81iAfA+bwbL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81c8sCXvNWL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81f7bPEzlHL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61jICDucaeL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/61HYWEYgzbL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71CLerpVfKL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71771rQIwfL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/51zTnb8lbXL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/71G4lmAU6-L._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81KEqfAvWhL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/51oppDaRaHL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/813etxOA6JL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/916acEhBkcL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/51G59GLOfWL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/81xD1809wmL._AC_UL1200_QL65_.jpg", "https://m.media-amazon.com/images/I/813etxOA6JL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/916acEhBkcL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51G59GLOfWL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81xD1809wmL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71ypvY2ZQmL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81+cXdxM7OL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71a8NGzy1uL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71f2XEH7CcL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81l6aV6sK2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81py4q3x+uL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61Sl+xoVHoL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61Y1WHUaQ9L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/613741WClyS._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71Meq7sFVqL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81W2+y0K0uL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81OF7rBzZfL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71aWDnZOfLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81yU+L0BNGL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71RWpkCMBYL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61hapdZW7xL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71am7ArwnXL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/917G0+Er8sL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71Q7JMrurtL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81mTD7why6L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/710OsyQGJDL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81P69iPswLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71BoZgQ4QjS._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81Z6EfHN70L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61YkVSUyCVL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51u9v2NTd0L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61b0EyFvxbL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61y-zJzm1ZL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71KiaQjhyiL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/611zqAUqoDL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/811tVOXcjJL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71JSM9kTEwS._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61+UWR8ByrL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/615pfQueyyL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/8125l1CSd2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71rLtVc+GpL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61aaG6INteL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91d45PCEhqL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81CglBHsEnL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/612yLVoCU+L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61uYcnUlz8L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71IgiZ2pkjL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71VjM5LOeYL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51kHl9OR0+L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/8170BjKBHsL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71am7ArwnXL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71Q7JMrurtL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61N28Hap3iL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81ybtKRxonL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71lkRLnpYuL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81P69iPswLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71l-7BQsgLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/617FUjl3EXL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61rlZhEPK3L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61YkVSUyCVL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71vfaITrxlL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61ayT3DukTL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71lo++IOYjL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/611zqAUqoDL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61+UWR8ByrL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51T7yplyxVL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81WmCMctvsL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/416l5kCgyGL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61aaG6INteL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71vv3WOqV+L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91d45PCEhqL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71hx38M3y+L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81E2IhbmPBL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/710fvkNdz6L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61uYcnUlz8L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81EIvU4vurL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71XZ5w+uy2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61aIQEzzz3L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51h43yWQbfL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71kdzMDdDKL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61ZEU5Ah07L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61sDdNulhxL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71sl1tAThyL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81RkCtTJ8YL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71+OK9sMvSL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81ttGCzlr4S._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61EDyRTFESL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81KNkAYIcHL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/716JHZbxb5L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71mqz0ymh9L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61c+OqsCQvL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81sOchGR74L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51bZ8fDC-pL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/710mqDQFhfL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71-Y+hPucLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71NG5grsU7L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61k0HOByv8L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/713V95oK3QL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81l7jOfrCRL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71OuSHJFghL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71tgo-p2lHL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61HlCcVkMcL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51h43yWQbfL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71NG5grsU7L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71kdzMDdDKL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61ZEU5Ah07L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/619l+9g92kL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71xBTNyJw1L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71rjKFT3DwL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71cl-H53n1L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71d-h1sP17L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71sl1tAThyL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71+OK9sMvSL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/614eWVlmO9L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81J1cRng+8L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71ce13fZdAL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71SEd7XDFhL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71Gshom7i1L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51KwfkpLvOL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61WRQ5WXRUL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81ttGCzlr4S._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81KNkAYIcHL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/716JHZbxb5L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/5194ncpe5IL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81sOchGR74L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51bZ8fDC-pL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61kAqcLvUIS._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81YRfx-zvhL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61I9hB+aEkL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81WZc9a2X2L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71-Y+hPucLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61p9wEsgs4S._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61k0HOByv8L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/613pEi4kmyL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71vYX6+GJbL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91Mm5gxO9qL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61VkC7T0sCL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61rwFTnju6L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71WeWhA-szL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71GmfA43bmL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51RKt+qcH4S._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61QcYWhxbbL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81ga-Taw1OL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61TXtLYpuDL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61z5oOk5fzL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71BCR7zTpVL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81j3wKFtlpL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81QyjCYpxcL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71k5sxbk0RL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71WtvGEvu5L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/91pPf47eyLL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81TFpawF2HL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/710vuL3j5LL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61LCsAWrpWL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51LlFQNWNUL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71mFZbpG1NL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81XXvNBEYfL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51f5l7j8PUL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71BSa9KwTEL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/51LlFQNWNUL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61HlCcVkMcL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81XXvNBEYfL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/619l+9g92kL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81YdzPXZ5+L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/61UpqtH8FPL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71+AoVcynNL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/711gRDicyML._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71-jNfNTBYL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71y+Gb3N-hL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/415bAIQTxaL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81ktsNMvIKL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81wYSrZjtiL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/81AED8aXVFL._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/614eWVlmO9L._AC_UL960_QL65_.jpg", "https://m.media-amazon.com/images/I/71CICwJc2YL._AC_UL960_QL65_.jpg"] /// sample
    
    var keyword: String = "iPhone 14"
    
    @IBOutlet weak var searchedCollectionView: UICollectionView!
    
    @IBOutlet var keywordLabel: UILabel!
    @IBOutlet var keywordField: UITextField!
    @IBOutlet  weak var segmented: UISegmentedControl!
    
    var index: Int = 0
    
    var addName: String = ""
    var addPrice: String = ""
    var addImageUrl: String = ""
    var addUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchedCollectionView.register(UINib(nibName: "categoryCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        
        keywordLabel.text = keyword
        searchedCollectionView.dataSource = self
        searchedCollectionView.delegate = self
        
        searchedCollectionView.layer.cornerRadius = 25
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // vertical scroll
        let size = searchedCollectionView.frame.width
        layout.itemSize = CGSize(width: size / 2 / 1.2, height: size / 2 * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 10,
                                                   left: 20,
                                                   bottom: 30,
                                                   right: 20)
        searchedCollectionView.collectionViewLayout = layout
        
        //長押し時の判定
            // UILongPressGestureRecognizer宣言
            let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                                   action: #selector(ComparePriceViewController.cellLongPressed(_ :)))

            // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
            longPressRecognizer.delegate = self

            // tableViewにrecognizerを設定
        searchedCollectionView.addGestureRecognizer(longPressRecognizer)
        
        segmented.addTarget(self, action: #selector(ValueChanged), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAPI(keyword: keyword) /// 本番用
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch index{
        case 0:
             return productUrl.count /// 本番用
//            return sampleUrl.count/// sample
        case 1:
            if keyword.lowercased().contains("iphone"){
                return iphonePhysicalUrl.count
            }
            if keyword.lowercased().contains("roland"){
                return rolandPhysicalUrl.count
            }
            return 0
        default:
            print("error")
            return 0
        }
////        return productUrl.count /// 本番用
//        return sampleUrl.count /// sample
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 22.5
        let productNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        
        let priceLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        let imageView = cell.contentView.viewWithTag(3) as! UIImageView
        
        let shopNameLabel = cell.contentView.viewWithTag(4) as! UILabel
        
        switch index{
        case 0:
//            productNameLabel.text = sampleName[indexPath.row] /// sample
//            priceLabel.text = "USD " + samplePrice[indexPath.row] /// sample
//            let url = URL(string: sampleImageUrl[indexPath.row]) /// sample
            productNameLabel.text = productNames[indexPath.row] /// 本番用
            priceLabel.text = productPrice[indexPath.row] + "yen"  /// 本番用
            let url = URL(string: productImageUrl[indexPath.row]) /// 本番用
            shopNameLabel.text = " " ///  本番
            DispatchQueue.global().async {
                do {
                    let imgData = try Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: imgData)
                        cell.setNeedsLayout()
                    }
                }catch let err {
                    print("Error : (err.localizedDescription)")
                }
            }
        case 1:
            if keyword.lowercased().contains("iphone"){
                shopNameLabel.text = iphonePhysicalShopName[indexPath.row]
                productNameLabel.text = "iPhone 14 128GB"
                priceLabel.text = iphonePhysicalPrice[indexPath.row] + "yen" /// sample
                let url = URL(string: iphonePhysicalImageUrl[indexPath.row]) /// sample
                DispatchQueue.global().async {
                    do {
                        let imgData = try Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: imgData)
                            cell.setNeedsLayout()
                        }
                    }catch let err {
                        print("Error : (err.localizedDescription)")
                    }
                }
            } else if keyword.lowercased().contains("roland"){
                shopNameLabel.text = rolandPhysicalShopName[indexPath.row]
                productNameLabel.text = "Roland FP-30X"
                priceLabel.text = rolandPhysicalPrice[indexPath.row] + "yen" /// sample
                let url = URL(string: rolandPhysicalImageUrl[indexPath.row]) /// sample
                DispatchQueue.global().async {
                    do {
                        let imgData = try Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: imgData)
                            cell.setNeedsLayout()
                        }
                    }catch let err {
                        print("Error : (err.localizedDescription)")
                    }
                }
            }
        default:
            print("error")
        }
        
//        productNameLabel.text = sampleName[indexPath.row] /// sample
//        priceLabel.text = "USD " + samplePrice[indexPath.row] /// sample
//        let url = URL(string: sampleImageUrl[indexPath.row]) /// sample
////        productNameLabel.text = productNames[indexPath.row] /// 本番用
////        priceLabel.text = "USD " + productPrice[indexPath.row] /// 本番用
////        let url = URL(string: productImageUrl[indexPath.row]) /// 本番用
//        DispatchQueue.global().async {
//            do {
//                let imgData = try Data(contentsOf: url!)
//                DispatchQueue.main.async {
//                    imageView.image = UIImage(data: imgData)
//                    cell.setNeedsLayout()
//                }
//            }catch let err {
//                print("Error : (err.localizedDescription)")
//            }
//        }


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                              didSelectItemAt indexPath: IndexPath) {
        
        switch index{
        case 0:
            // move to link of product
            guard let url = URL(string: productUrl[indexPath.row]) else { return }
            UIApplication.shared.open(url)
        case 1:
            
            
            if keyword.lowercased().contains("iphone"){
                guard let url = URL(string: iphonePhysicalUrl[indexPath.row]) else { return }
                UIApplication.shared.open(url)
            } else if keyword.lowercased().contains("roland"){
                guard let url = URL(string: rolandPhysicalUrl[indexPath.row]) else { return }
                UIApplication.shared.open(url)
            }
//            // move to link of product
//            guard let url = URL(string: sampleUrl[0]) else { return }
//            UIApplication.shared.open(url)
        default:
            print("error")
        }
        // move to link of product
//        guard let url = URL(string: sampleUrl[indexPath.row]) else { return }
//        UIApplication.shared.open(url)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func startAPI(keyword: String){
        let url = URL(string: base)
        
        print(keyword)
        if keyword != nil{
            print(keyword)
            let headers = [
                "accept": "application/json",
                "content-type": "application/json"
            ]
            let parameters = [
                "source": "amazon",
                "country": "jp",
                "topic": "search_results",
                "key": "term",
                "values": "\(keyword)",
                //              "values": "\(keywordField.text!)",
                "max_pages": "10",
                "max_age": "1440",
                "timeout": "5",
                "token": token
            ] as [String : Any]
            
            let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs?token=\(token)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in guard let data = data else {return}
                do{
                    let requestJSON = try JSONDecoder().decode(initialRequestJSON.self, from: data) //make json parsing easy
                    if requestJSON.status == "new"{
                        print(requestJSON.job_id)
                        self.isJobFinished(requestJSON.job_id)
                    }
                }catch{
                    print("Error getBestPrice")
                }
            })
            
            dataTask.resume()
        }
    }
    
    func isJobFinished(_ id: String) -> Void{
        var isFinished: Bool = false
        let headers = ["accept": "application/json"]
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs/\(id)?token=\(token)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask =  session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              if let data = data{
                  do{
                      let checkJSON = try JSONDecoder().decode(checkingRequest.self, from: data)
                      print(checkJSON)
                      print(checkJSON.status)
                      if checkJSON.status == "finished" {
                          isFinished = true
                      }
                      if checkJSON.status != "finished"{
                          self.isJobFinished(id)
                      }
                  }catch{
                      print("Error returnJSON")
                      print("after call")
                      print(error)
                  }
              }
          }
            if isFinished {
                self.getResponse(id){
                    DispatchQueue.main.async {
                        self.searchedCollectionView.reloadData()
                        print("done")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    func getResponse(_ id: String, completion: @escaping () -> Void){
        sleep(20)///waiting 20 second for waiting creating data completely on the API server.
        let headers = ["accept": "application/json"]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs/\(id)/download?token=\(token)&job_id=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              if let data = data{
                  do{
                      let returnJSON = try JSONDecoder().decode(returnJSON.self, from: data)
//                      print(returnJSON)
                      if let searchResults = returnJSON.results?.compactMap({ $0.content?.search_results }) {
                          for searchResult in searchResults {
                            for result in searchResult {
                                print(result.name)
                                self.productNames.append(result.name!)
                                self.productUrl.append(result.url!)
                                self.productPrice.append(result.min_price ?? "0")
                                self.productImageUrl.append(result.image_url!)
//                                print(self.productNames)
//                                print(self.productUrl)
//                                print(self.productPrice)
//                                print(self.productImageUrl)
                            }
                        }
//                          print(self.productInfo[0].url)
                      }
                      print(self.productPrice)
                      print(self.productImageUrl)
                      completion()

                  }catch{
                      print("Error returnJSON")
                      print("after call")
                      print(error)
                  }
              }
          }
        })
        dataTask.resume()
    }
    
    func updateRealm(url: String, name: String, imageUrl: String, price: String){
        let productInfo: ProductInfo! = realm.objects(ProductInfo.self).filter("url == %@", addUrl).first
        
        if productInfo != nil {
            try! realm.write {
                productInfo.num += 1
            }
        } else {
            let newProduct = ProductInfo()
            newProduct.name = name
            newProduct.url = url
            newProduct.price = price
            newProduct.imageUrl = imageUrl
            newProduct.num = 1
            try! realm.write {
                realm.add(newProduct)
                print("add done")
            }
        }
    }
    
    @IBAction func ValueChanged(_ sender: UISegmentedControl) {
        index = segmented.selectedSegmentIndex
        self.searchedCollectionView.reloadData()
        print("seg")
    }
}

// MARK: ContextMenuDelegate
extension ComparePriceViewController: ContextMenuDelegate {
    
    func contextMenuDidSelect(_ contextMenu: ContextMenu,
                              cell: ContextMenuCell,
                              targetedView: UIView,
                              didSelect item: ContextMenuItem,
                              forRowAt index: Int) -> Bool {
        
        
        print("コンテキストメニューの", index, "番目のセルが選択された！")
        print("そのセルには", item.title, "というテキストが書いてあるよ!")
        
        switch index {
            case 0:
                //0番目のセル(1番上のメニューがタップされると実行されます)
                //この例では編集メニューに設定してあります
                print(addName)
                print("編集が押された!")
            updateRealm(url: addUrl, name: addName, imageUrl: addImageUrl, price: addPrice)
            
            default:
                //ここはその他のセルがタップされた際に実行されます
                break
            }
            
            //最後にbool値を返します
            return true

    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu,
                                cell: ContextMenuCell,
                                targetedView: UIView,
                                didSelect item: ContextMenuItem,
                                forRowAt index: Int) {
    }
    
    /**
     コンテキストメニューが表示されたら呼ばれる
     */
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("コンテキストメニューが表示された!")
    }
    
    /**
     コンテキストメニューが消えたら呼ばれる
     */
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("コンテキストメニューが消えた!")
    }
    
    /// セルが長押しした際に呼ばれるメソッド
    @objc func cellLongPressed(_ recognizer: UILongPressGestureRecognizer) {

        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: searchedCollectionView)
        // 押された位置に対応するindexPath
        let indexPath = searchedCollectionView.indexPathForItem(at: point)
            
        if indexPath == nil {  //indexPathがなかったら
                
            return  //すぐに返り、後の処理はしない
                
        } else if recognizer.state == UIGestureRecognizer.State.began  {
            // 長押しされた場合の処理
            
            switch index{
            case 0:
                // move to link of product
                addName = productNames[indexPath!.row] /// sample用
                addPrice = productPrice[indexPath!.row] /// sample用
                addImageUrl = productImageUrl[indexPath!.row] /// sample用
                addUrl = productUrl[indexPath!.row]
            case 1:
                // move to link of product
//                addName = sampleName[indexPath!.row] /// sample用
//                addPrice = samplePrice[indexPath!.row] /// sample用
//                addImageUrl = sampleImageUrl[indexPath!.row] /// sample用
//                addUrl = sampleUrl[indexPath!.row]
                
                if keyword.lowercased().contains("iphone"){
                    addName = "iPhone 14 128GB" /// sample用
                    addPrice = iphonePhysicalPrice[indexPath!.row] /// sample用
                    addImageUrl = iphonePhysicalImageUrl[indexPath!.row] /// sample用
                    addUrl = iphonePhysicalUrl[indexPath!.row]
                } else if keyword.lowercased().contains("roland"){
                    addName = "Roland FP-30X" /// sample用
                    addPrice = rolandPhysicalPrice[indexPath!.row] /// sample用
                    addImageUrl = rolandPhysicalImageUrl[indexPath!.row] /// sample用
                    addUrl = rolandPhysicalUrl[indexPath!.row]
                }
            default:
                print("error")
            }
            print(indexPath?.row)
//          let addName = productNames[indexPath?.row] /// 本番用
//          let addPrice = "USD " + productPrice[indexPath?.row] /// 本番用
//          let addUrl = URL(string: productImageUrl[indexPath?.row]) /// 本番用
                
            //コンテキストメニューの内容を作成します
            let add = ContextMenuItemWithImage(title: "Add to Cart", image: UIImage(systemName: "cart")!)
                
         //コンテキストメニューに表示するアイテムを決定します
            CM.items = [add]
        //表示します
            CM.showMenu(viewTargeted: searchedCollectionView.cellForItem(at: indexPath!)!,
                        delegate: self,
                        animated: true)
                
        }
    }
    
}
