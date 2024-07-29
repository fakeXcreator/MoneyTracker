import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {

    // MARK: Properties
    var vm = ViewModel()
    var asset_id_base: String = ""

    // MARK: UI Components
    lazy var labelStepper: UILabel = {
        let labelStepper = UILabel()
        labelStepper.text = "Amount: \(Int(vm.amount))$"
        labelStepper.textColor = UIColor.white
        labelStepper.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return labelStepper
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 100
        stepper.maximumValue = 10_000
        stepper.stepValue = 100
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        return stepper
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 100
        slider.maximumValue = 10_000
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 10
        return vStack
    }()
    
    private lazy var hStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fill
        hStack.spacing = 10
        return hStack
    }()
    
    private lazy var list: UITableView = {
        let list = UITableView()
        list.backgroundColor = .systemBackground
        list.register(TableCell.self, forCellReuseIdentifier: TableCell.identifyer)
        return list
    }()
    
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Currency"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        return searchBar
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto Currency"
        view.backgroundColor = .systemBackground
        
        setupUI()
        configureConstraints()
        list.delegate = self
        list.dataSource = self
        
        vm.refreshData() // Fetch data
        vm.$rates.sink { [weak self] _ in
            self?.list.reloadData()
        }.store(in: &subscriptions)
    }

    // MARK: Setup UI
    private func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        navigationItem.rightBarButtonItem = refreshButton
        
        hStack.addArrangedSubview(labelStepper)
        hStack.addArrangedSubview(stepper)
        
        vStack.addArrangedSubview(searchBar)
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(slider)
        
        view.addSubview(vStack)
        view.addSubview(list)
        view.addGestureRecognizer(tap)

    }
    
    private func configureConstraints() {
        vStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(150)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        list.snp.makeConstraints { make in
            make.top.equalTo(vStack.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }
    }

    // MARK: Selectors
    @objc private func refreshButtonTapped() {
        vm.refreshData()
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        vm.amount = Double(sender.value)
        updateUIComponents()
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        vm.amount = Double(sender.value)
        updateUIComponents()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateUIComponents() {
        labelStepper.text = "Amount: \(String(format: "%.2f", vm.amount))$"
        stepper.value = vm.amount
        slider.value = Float(vm.amount)
    }

    // MARK: Subscriptions
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.filteredRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifyer, for: indexPath) as? TableCell else {
            fatalError("Unable to dequeue TableCell")
        }
        
        let rate = vm.filteredRates[indexPath.row]
        cell.setupCell(name: rate.asset_id_quote, rate: String(rate.rate))
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.text = ""
    }
}

