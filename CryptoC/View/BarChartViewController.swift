import UIKit
import SnapKit
import CoreData
import DGCharts

class BarChartViewController: UIViewController, ChartViewDelegate {
    
    // MARK: Properties
    
    var expenses: [Expenses] = []
    
    // MARK: UI Components
    
    lazy var barChart: BarChartView = {
        let barChart = BarChartView()
        barChart.delegate = self
        barChart.xAxis.valueFormatter = DateAxisValueFormatter()
        barChart.xAxis.granularity = 1
        return barChart
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        setData()
    }
    
    // MARK: Setup UI
    
    private func setupUI() {
        view.addSubview(barChart)
    }
    
    private func configureConstraints() {
        barChart.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    // MARK: Fetch Data from CoreData
    private func fetchData() {
        expenses = CoreManager.shared.expenses
    }
    
    // MARK: Set Data to Chart
    private func setData() {
        var dataEntries: [BarChartDataEntry] = []
        var expenseDictionary: [String: Double] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // You can adjust the date format as needed
        
        for expense in expenses {
            guard let date = expense.date else { continue }
            let dateString = dateFormatter.string(from: date)
            expenseDictionary[dateString, default: 0] += expense.money
        }
        
        for (dateString, money) in expenseDictionary {
            if let date = dateFormatter.date(from: dateString) {
                let timeInterval = date.timeIntervalSince1970
                let dataEntry = BarChartDataEntry(x: timeInterval, y: money)
                dataEntries.append(dataEntry)
            }
        }
        
        if dataEntries.isEmpty {
            print("No data entries to display")
        } else {
            print("Data Entries: \(dataEntries)")
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Expenses")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueTextColor = .black

        let data = BarChartData(dataSet: dataSet)
        barChart.data = data
    }
    
    // MARK: PieChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}

class DateAxisValueFormatter: AxisValueFormatter {
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
