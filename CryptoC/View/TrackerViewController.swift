import UIKit
import SnapKit

class TrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:  Properties
    
    private let manager = CoreManager.shared
    
    // MARK:  UI Components
    
    private lazy var TableView: UITableView = {
        let TableView = UITableView()
        TableView.backgroundColor = .systemBackground
        TableView.allowsSelection = true
        TableView.translatesAutoresizingMaskIntoConstraints = false
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return TableView
    }()
    
    // MARK:  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TableView.reloadData()
        }
    
    // MARK:  Setup UI
    
    private func setupUI() {
        view.addSubview(TableView)
        
        // Create a UIBarButtonItem with a system item (e.g., "Add")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
                
                // Set it as the right bar button item
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    private func configureConstraints() {
        TableView.snp.makeConstraints{ make in
            make.top.equalTo(additionalSafeAreaInsets)
            make.bottom.equalTo(additionalSafeAreaInsets)
            make.leading.equalTo(additionalSafeAreaInsets)
            make.trailing.equalTo(additionalSafeAreaInsets)

        }
    }
    
    // MARK:  Selectors
    
    @objc private func addButtonTapped() {
        let addVC = AddViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = manager.expenses[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddViewController()
        vc.expenses = manager.expenses[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = manager.expenses[indexPath.row]
            note.deleteNote()
            manager.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

