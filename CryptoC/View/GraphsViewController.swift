import UIKit
import SnapKit

class GraphsViewController: UIViewController {
    
    // MARK:  Properties
    let pieChartImage = "chart.pie"
    let barChartImage = "chart.bar"

    
    // MARK:  UI Components
    
    private lazy var pieChartButton: UIButton = {
        let pieChartButton = UIButton()
        pieChartButton.setImage(createSymbolImage(named: pieChartImage), for: .normal)
        pieChartButton.backgroundColor = .systemBackground
        pieChartButton.layer.borderWidth = 2.0
        pieChartButton.layer.borderColor = UIColor.label.cgColor
        pieChartButton.layer.cornerRadius = 10.0
        pieChartButton.addTarget(self, action: #selector(pieChartButtonTappet), for: .touchUpInside)

        return pieChartButton
    }()
    
    private lazy var barChartButton: UIButton = {
        let barChartButton = UIButton()
        barChartButton.setImage(createSymbolImage(named: barChartImage), for: .normal)
        barChartButton.backgroundColor = .systemBackground
        barChartButton.layer.borderWidth = 2.0
        barChartButton.layer.borderColor = UIColor.label.cgColor
        barChartButton.layer.cornerRadius = 10.0
        barChartButton.addTarget(self, action: #selector(barChartButtonTappet), for: .touchUpInside)

        return barChartButton
    }()
    
    // MARK:  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
        view.backgroundColor = .systemBackground
    }
    
    // MARK:  Setup UI
    
    private func setupUI() {
        view.addSubview(pieChartButton)
        view.addSubview(barChartButton)

    }
    
    private func configureConstraints() {
        pieChartButton.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.snp.centerX).multipliedBy(0.5)
            make.width.equalTo(125)
            make.height.equalTo(125)
        }
        
        barChartButton.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.snp.centerX).multipliedBy(1.5)
            make.width.equalTo(125)
            make.height.equalTo(125)
        }
    }
    
    // MARK:  Selectors
    private func createSymbolImage(named: String) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        return UIImage(systemName: named, withConfiguration: configuration)
    }
    
    @objc private func pieChartButtonTappet() {
        let pieVC = PieChartViewController()
        navigationController?.pushViewController(pieVC, animated: true)
    }

    @objc private func barChartButtonTappet() {
        let barVC = BarChartViewController()
        navigationController?.pushViewController(barVC, animated: true)
    }
    
}

