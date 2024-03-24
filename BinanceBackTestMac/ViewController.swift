//
//  ViewController.swift
//  BinanceBackTestMac
//
//  Created by Lado Tsivtsivadze on 3/19/24.
//

import Cocoa

class ViewController: NSViewController {
    
    let backTester = BackTester()
    let fundamentalTester = FundamentalTester()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fundamentalTester.strategy = FirstStrategy()
        fundamentalTester.fundamentalTest(symbol: .adausd, interval: .oneDay, limit: 100000) { results in
            //let sortedByProfit = results.sorted { $0.profit! < $1.profit! }
            //print("highest profit dates and value. Profit: \(sortedByProfit.last?.profit ?? 0)$ From: \(sortedByProfit.last?.fromDate ?? .distantPast) To: \(sortedByProfit.last?.lastDate ?? .distantPast)")
            var profitableCount: Double = 0
            for item in results {
                if item.profit! > 0 {
                    profitableCount += 1
                }
            }
            print("profitable percentage of this strategy is: \((profitableCount / Double(results.count)) * 100)%")
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

