//
//  ChartsViewController.swift
//  IWantFace
//
//  Created by Mr Z on 2017/3/27.
//  Copyright © 2017年 C2H4. All rights reserved.
//

import UIKit
import SwiftCharts
class ChartsViewController: UIViewController {
    var chart: Chart? // arc
    let scrollView = UIScrollView()
    let norecordLabel = UILabel(frame: CGRect(x: 0, y: 237 * Percent, width: kScreenWidth, height: 30))
    let scoreLabel = UILabel(frame: CGRect(x: 286 * Percent, y: 60 * Percent, width: 56, height: 65))
    var chartPoints:[(Int,Int)] = []
    let dateBtn = UIButton(type: .custom)
    let dateBtnSecond = UIButton(type: .custom)
    let zzLabel = UILabel(frame: CGRect(x: 343 * Percent, y: 72 * Percent, width: 12, height: 17))
    var arr:[Chart] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
//MARK -  just tap the button for times(don't care which one ,I test it happend on  iPhpne 7 plus,iPhone 6s Plus, iPhone 6 Plus) and you will see the layer on the ChartbaseView dismissed hope you can find what's error I made ,thanks very much
        
//  containView
        setScrollView()
//  tapBtn
        setTapBtns()
        
//  loaddata
        chartPoints = [(1,10),(2,15),(10,20),(30,50)]
        loadCharts()
 
    }
    
    func selectedFirstDT() {
        chartPoints = [(1,10),(2,15),(10,20),(15,50),(18,70)]
        loadCharts()
    }
    func selectedSecondDT() {
        chartPoints = [(2,10),(3,35),(8,30),(10,50),(15,70)]
        loadCharts()
    }
    
    
    func  loadCharts() {
        let labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 15))
        let chartPoints1 = chartPoints.map{ChartPoint(x: ChartAxisValueString.init("\($0.0)", order: $0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
        let chartPoints2 = [(4, 20), (6, 60)].map{ChartPoint(x: ChartAxisValueInt($0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
        let chartPoints3 = [ (4, 20), (6, 100)].map{ChartPoint(x: ChartAxisValueInt($0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
        
        let allChartPoints = (chartPoints1 + chartPoints2 + chartPoints3).sorted {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        //设置最大值
        func setYearsTitle(time:Int) -> String {
            if time == 0 || time == 54{
                return ""
            }
            return "\(time)周"
        }
        let xLabelSettings = ChartLabelSettings(font: .systemFont(ofSize: 11), fontColor: UIColor.init(red: 180 / 255.0, green: 180 / 255.0, blue: 180 / 255.0, alpha: 1), rotation: 0, rotationKeep: ChartLabelDrawerRotationKeep.top, shiftXOnRotation: false, textAlignment: ChartLabelTextAlignment.default)
        let xValues = stride(from: 0, through: 54, by: 1).map {
            ChartAxisValueString.init(setYearsTitle(time: $0), order: $0, labelSettings: xLabelSettings)
        }
        let ylabelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 0), fontColor: UIColor.clear, rotation: 0, rotationKeep: ChartLabelDrawerRotationKeep.center, shiftXOnRotation: false, textAlignment: ChartLabelTextAlignment.default)
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 5, maxSegmentCount: 5, multiple: 5, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: ylabelSettings)}, addPaddingSegmentIfEdge: true)
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.defaultVertical()))
        //        let chartFrame = ExamplesDefaults.chartFrame(self.view.bounds)
        let scrollViewFrame = ExamplesDefaults.chartFrame(CGRect(x: 0, y: 33, width: 375, height: 411 * Percent))
        let chartFrame = CGRect(x: 0, y: 0, width: 2120, height: scrollViewFrame.size.height)
        let chartSettings = ExamplesDefaults.chartSettings
        chartSettings.trailing = 0
        chartSettings.leading = -40
        chartSettings.top = 0
        chartSettings.bottom = 0
        chartSettings.labelsToAxisSpacingX = 12
        chartSettings.labelsToAxisSpacingY = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let c1 = UIColor(red: 100 / 255.0, green: 200 / 255.0, blue: 200 / 255.0, alpha: 0.5)
        let lineModel = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor(red: 100 / 255.0, green: 200 / 255.0, blue: 200 / 255.0, alpha: 1), lineWidth: 2, animDuration: 0, animDelay: 0)
        //曲线? 直线
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel], pathGenerator: CubicLinePathGenerator(tension1: 0.00, tension2: 0.00))
        
        let guidelinesHighlightLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor(red: 225 / 255.0, green: 225 / 255.0, blue: 225 / 255.0, alpha: 1), linesWidth: 1, dotWidth: 4, dotSpacing: 4)
        let guidelinesHighlightLayer = ChartGuideLinesForValuesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: guidelinesHighlightLayerSettings, axisValuesX: [ChartAxisValueDouble(-1000)], axisValuesY: [ChartAxisValueDouble(80)])
        
        //点的 layer
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: chartPointsLineLayer.innerFrame, chartPoints: chartPoints1, areaColor: c1, animDuration: 0.01, animDelay: 0, addContainerPoints: true)
        let popups: [UIView] = []
        var selectedView: ChartPointTextCircleView?
        
        let showCoordsLinesLayer = ChartShowCoordsLinesLayer<ChartPoint>(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1)
        
        var add = false
        let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            
            // 点
            let v =
                ChartPointTextCircleView(chartPoint: chartPoint, center: screenLoc, diameter: 30 * Percent, cornerRadius: 4.5, borderWidth: 2, font: ExamplesDefaults.fontWithSize(8))
            v.textColor = UIColor.clear
            if chartPoint == chartPoints1.last {
                if add == false {
                    add = true
                }else {
                    selectedView = v
                    selectedView?.selected = true
                    //                        self.dateLabel.text = "\(Int(chartPoint.x.description)!)周"
                    self.scoreLabel.text = chartPoint.y.description
                }
            }
            
            v.viewTapped = {view in
                for p in popups {p.removeFromSuperview()}
                selectedView?.selected = false
                //竖线
                showCoordsLinesLayer.showChartPointLines(chartPoint, chart: chart)
                let w: CGFloat = 80
                let h: CGFloat = 80
                
                let x: CGFloat = {
                    let attempt = screenLoc.x - (w/2)
                    let leftBound: CGFloat = chart.bounds.origin.x
                    let rightBound = chart.bounds.size.width - 5
                    if attempt < leftBound {
                        return view.frame.origin.x
                    } else if attempt + w > rightBound {
                        return rightBound - w
                    }
                    return attempt
                }()
                
                UIView.animate(withDuration: 0.0, delay: 0, options: UIViewAnimationOptions(), animations: {
                    view.selected = true
                    selectedView = view
                }, completion: {finished in})
            }
            return v
        }
        
        let touchLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, viewGenerator: circleViewGenerator)
        let itemsDelay: Float = 0.00
        let chartPointsCircleLayer1 = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, viewGenerator: circleViewGenerator, displayDelay: 0.0, delayBetweenItems: itemsDelay)
        //        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                touchLayer,
                chartPointsLayer1,
                showCoordsLinesLayer,
                chartPointsLineLayer,
                chartPointsCircleLayer1,
                
                ]
        )
        
        scrollView.contentSize = CGSize(width: chartFrame.size.width, height: scrollViewFrame.size.height)
        
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        scrollView.addSubview(chart.view)
        if chartPoints.count != 0 {
            if (chartPoints.last?.0)! > 8 && kScreenWidth == 320 || (chartPoints.last?.0)! > 8 && kScreenWidth == 375 || (chartPoints.last?.0)! > 9 && kScreenWidth == 414 {
                scrollView.contentOffset.x = CGFloat(40 * (chartPoints.last?.0)!) - kScreenWidth + 40
            }else {
                scrollView.contentOffset.x = 0
            }
            
        }
        
        self.chart = chart
        chart.view.setNeedsDisplay()
        
        
    }
    
    
    
    
    
    
    func setScrollView()  {
        self.view.backgroundColor = .white
        scrollView.frame = CGRect(x: 0, y: 100, width: Int(UIScreen.main.bounds.size.width), height: Int(400 * Percent))
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    func setTapBtns() {
        
        dateBtn.addTarget(self, action: #selector(selectedFirstDT), for: .touchUpInside)
        dateBtn.frame = CGRect(x: 61 * Percent, y: 96 * Percent, width: 42, height: 21)
        dateBtn.setTitle("2016", for: UIControlState())
        dateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        dateBtn.setTitleColor(.green, for: .normal)
        dateBtn.setTitleColor(.red, for: .selected)
        dateBtnSecond.addTarget(self, action: #selector(selectedSecondDT), for: .touchUpInside)
        dateBtnSecond.frame = CGRect(x: 110 * Percent, y: 96 * Percent, width: 40, height: 21)
        dateBtnSecond.setTitle("2017", for: UIControlState())
        dateBtnSecond.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        dateBtnSecond.setTitleColor(.green, for: .normal)
        dateBtnSecond.setTitleColor(.red, for: .selected)
        self.view.addSubview(dateBtnSecond)
        self.view.addSubview(dateBtn)
    }
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func setCharts(arr:[(Int,Int)]) {
        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "dd.MM.yyyy"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd"
        var displayFormatterForFirstDayOfMonth = DateFormatter()
        displayFormatterForFirstDayOfMonth.dateFormat = "MMM/dd"
        var displayFormatterMonth = DateFormatter()
        displayFormatterMonth.dateFormat = "MMM/dd"
        
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }
        let calendar = Calendar.current
        
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.date(from: components)!
        }
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        
    }
    
    
    
}






