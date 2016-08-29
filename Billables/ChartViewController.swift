//
//  ChartViewController.swift
//  Billables
//
//  Created by Theodore Prekop on 8/23/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

//This class uses the charts framework and is responsible for displaying the graph that shows billed time over the past 7 days

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
        
        //Determine the xAxis
        getPastSevenDays()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        clients = loadClients()!
        getTimePerDay()
        
        //Display the chart
        setChart(pastSevenDays, values: timePerDay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Displays the chart
    func setChart(dataPoints: [String], values: [Double]){
        //Text to display with no data
        barChartView.noDataText = "You need to provide data for this chart to work"
        
        var dataEntries = [BarChartDataEntry]()
        
        //Constructs the x-Axis
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        //Sets the background color
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        //Construct the data entries on the chart
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Hours Billed")
        
        //Assign possible colors to each data bar
        chartDataSet.colors = self.colors
        
        //Construct the chart
        let chartData = BarChartData(xVals: pastSevenDays, dataSet: chartDataSet)
        
        //Set 0 as the minimum value and hide the right axis label
        barChartView.leftAxis.axisMinValue = 0.0
        barChartView.rightAxis.drawLabelsEnabled = false
     
        //Display the bar chart
        barChartView.data = chartData
        
        //Animate the chart
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
    }
    
    //This function obtains the past seven days and adds them to an array.  The days serve as the x-Axis of the graph
    func getPastSevenDays(){
        let calendar = NSCalendar.currentCalendar()
        
        for i in 0...6 {
            let day = calendar.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: [])
            let components = calendar.components(.Day, fromDate: day!)
            let numDay = String(components.day)
            pastSevenDays.append(numDay)
        }
        
        //The array needs to be reversed so that the most recent day appears on the right side of the graph
        pastSevenDays = pastSevenDays.reverse()
        print(pastSevenDays)
    }
    
    //This function determines the amount of time spent in the past seven days and the color of the bars on the graph
    func getTimePerDay(){
        
        //Reset the colors and time per day so that the graph is correct each time the User views the graph
        for (index, _) in timePerDay.enumerate(){
            timePerDay[index] = 0.0
            colors[index] = NSUIColor.redColor()
        }
        
        let today = NSDate()
        let lastWeek = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -6, toDate: today, options: [])
        
        //Iterate through each client and each matter.  If the matter is within the given time period,
        for client in clients{
            for matter in client.matters{
                print(matter.date)
                //Boolean test to see if date is within the last week.  If it is, translate the date to one of the seven dates on the x-Axis and increment the entry at that index
                if(matter.date!.isBetweeen(date: lastWeek!, andDate: today)){
                    let index = NSCalendar.currentCalendar().components(.Day, fromDate: matter.date!, toDate: today, options: []).day
                    print(index)
                    timePerDay[index] += matter.time!
                }
            }
        }
        //The array needs to be reversed so that the most recent day appears on the right
        timePerDay = timePerDay.reverse()
        print(timePerDay)
        
        //Determine the color of each bar
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
        print(colors)
    }
    
    func loadClients() -> [Client]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Client.ArchiveURL.path!) as? [Client]
    }
    
}

//This is an extension to easily calculate whether or not a date falls between 2 dates, inclusive
extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}