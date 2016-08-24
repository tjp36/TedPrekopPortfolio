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
    var colors = [NSUIColor](count:7, repeatedValue: NSUIColor.redColor())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         getPastSevenDays()
        
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
        
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Hours Billed")
        
        chartDataSet.colors = self.colors
        
        let chartData = BarChartData(xVals: pastSevenDays, dataSet: chartDataSet)
        barChartView.leftAxis.axisMinValue = 0.0
        barChartView.rightAxis.drawLabelsEnabled = false
     
        
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
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
            colors[index] = NSUIColor.redColor()
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
        for (index,time) in timePerDay.enumerate(){
            if(time < 3.0){
                colors[index] = (NSUIColor.redColor())
            }
            else if(time >= 3.0 && time < 6.0){
                colors[index] = (NSUIColor.yellowColor())
            }
            else{
                colors[index] = (NSUIColor.greenColor())
            }
        }
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