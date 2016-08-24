//
//  ChartViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/23/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    //MARK - Properties
    @IBOutlet weak var barChartView: BarChartView!
    
    var clients = [Client]()
    var pastSevenDays = [String]()
    var timePerDay = [Double](count:7, repeatedValue: 0.0)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         getPastSevenDays()
       
        //print(clients)
        print("-----------------------------")
//        for client in clients{
//            print(client.matters)
//        }

        //print(clients)
//        getPastSevenDays()
//        getTimePerDay()
//      
//        
//        setChart(pastSevenDays, values: timePerDay)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("THIS GETS CALLED")
        clients = loadClients()!
      
        getTimePerDay()
        
        setChart(pastSevenDays, values: timePerDay)
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        pastSevenDays.removeAll()
//        timePerDay.removeAll()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        barChartView.noDataText = "You need to provide data for this chart to work"
        //var dataEntries: [BarChartDataEntry] = []
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            print(dataPoints[i])
            //print(i)
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Hours Billed")
        let chartData = BarChartData(xVals: pastSevenDays, dataSet: chartDataSet)
        barChartView.xAxis.labelPosition = .Top
        
        barChartView.data = chartData
    }
    
    func getPastSevenDays(){
        let calendar = NSCalendar.currentCalendar()
        
        for i in 0...6 {
            let day = calendar.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: [])
            let components = calendar.components(.Day, fromDate: day!)
            let numDay = String(components.day)
            pastSevenDays.append(numDay)
        }
        pastSevenDays = pastSevenDays.reverse()
        print(pastSevenDays)
    }
    
    func getTimePerDay(){
        
        for (index, _) in timePerDay.enumerate(){
            timePerDay[index] = 0.0
        }
        
        let today = NSDate()
        let lastWeek = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -6, toDate: today, options: [])
        
        for client in clients{
            print(client.matters.count)
            for matter in client.matters{
                if(matter.date!.isBetweeen(date: lastWeek!, andDate: today)){
                    let index = NSCalendar.currentCalendar().components(.Day, fromDate: matter.date!, toDate: today, options: []).day
                    print("Index is \(index)")
                    timePerDay[index] += matter.time!
                }
            }
        }
        timePerDay = timePerDay.reverse()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadClients() -> [Client]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Client.ArchiveURL.path!) as? [Client]
    }
    
    

}


extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}