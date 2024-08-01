import UIKit
import SnapKit
import CoreData
import DGCharts

class PieChartViewController: UIViewController, ChartViewDelegate {
    
    // MARK: Properties
    
    var expenses: [Expenses] = []
    
    // MARK: UI Components
    
    lazy var pieChart: PieChartView = {
        let pieChart = PieChartView()
        pieChart.delegate = self
        pieChart.layer.borderWidth = 2.0
        pieChart.layer.borderColor = UIColor.black.cgColor
        pieChart.layer.cornerRadius = 10.0
        
        return pieChart
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        fetchData()
        setData()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: Setup UI
    
    private func setupUI() {
        view.addSubview(pieChart)
    }
    
    private func configureConstraints() {
        pieChart.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    // MARK: Fetch Data from CoreData
    private func fetchData() {
        expenses = CoreManager.shared.expenses
        print("Fetched Expenses for Pie Chart: \(expenses)") // Debugging: Print fetched data
    }
    
    // MARK: Set Data to Chart
    private func setData() {
        var dataEntries: [PieChartDataEntry] = []
        var groupedExpenses: [String: Double] = [:]
        
        // Group expenses by title
        for expense in expenses {
            let category = expense.title ?? "Unknown"
            let amount = expense.money
            
            if let existingAmount = groupedExpenses[category] {
                groupedExpenses[category] = existingAmount + amount
            } else {
                groupedExpenses[category] = amount
            }
        }
        
        // Create data entries from grouped expenses
        for (category, amount) in groupedExpenses {
            let dataEntry = PieChartDataEntry(value: amount, label: category)
            dataEntries.append(dataEntry)
        }
        
        print("Data Entries: \(dataEntries)") // Debugging: Print data entries
        
        guard !dataEntries.isEmpty else {
            print("No data entries to display") // Debugging: Print if no data
            pieChart.noDataText = "No data available"
            return
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "Expenses")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueTextColor = .black  // Set text color to black
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.setNeedsDisplay() // Ensure the chart is refreshed
    }
    
    // MARK: PieChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
