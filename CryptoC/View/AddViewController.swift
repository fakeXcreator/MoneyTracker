import UIKit
import SnapKit

class AddViewController: UIViewController {
    
    // MARK: Properties
    
    private let manager = CoreManager.shared
    var expenses: Expenses?
    
    // MARK: UI Components
    
    lazy var titleField: UITextField = {
        let titleField = UITextField()
        titleField.backgroundColor = .white
        titleField.layer.cornerRadius = 8
        titleField.layer.borderWidth = 1.0
        titleField.layer.borderColor = UIColor.darkGray.cgColor
        titleField.placeholder = "Type title name..."
        titleField.textColor = .darkGray
        titleField.font = UIFont(name: "Baskerville-Regular", size: 12)
        
        let paddingView = UIView()
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        titleField.rightView = paddingView
        titleField.rightViewMode = .always
        
        return titleField
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.placeholder = "Type amount of money in $..."
        textField.textColor = .darkGray
        textField.font = UIFont(name: "Baskerville-Regular", size: 12)
        
        let paddingView = UIView()
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private var buttonOne: UIButton!
    
    lazy var action = UIAction { [weak self] _ in
        guard let self = self else { return }
        if self.isValidDouble(self.textField.text) {
            let title = self.titleField.text ?? ""
            let money = Double(self.textField.text ?? "0.0") ?? 0.0
            if self.expenses == nil {
                self.manager.addNewNote(title: title, money: money)
            } else {
                self.expenses?.updateNote(newTitle: title, newMoney: money)
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showInvalidInputAlert()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = expenses == nil ? "Add Note" : "Edit Note"
        view.backgroundColor = .systemBackground
        setupUI()
        configureConstraints()
        
        // Populate fields if expenses is not nil
        if let expenses = expenses {
            titleField.text = expenses.title
            textField.text = "\(String(expenses.money)) $"
        }
    }

    
    // MARK: Setup UI
    
    private func setupUI() {
        view.addSubview(titleField)
        view.addSubview(textField)
        
        buttonOne = UIButton(primaryAction: action)
        buttonOne.setTitle("Save", for: .normal)
        buttonOne.setTitleColor(.label, for: .normal)
        buttonOne.backgroundColor = .systemBackground
        buttonOne.layer.cornerRadius = 8
        buttonOne.layer.borderColor = UIColor.systemBlue.cgColor
        buttonOne.layer.borderWidth = 1
        
        view.addSubview(buttonOne)
    }
    
    private func configureConstraints() {
        
        titleField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        titleField.leftView?.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        
        titleField.rightView?.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleField.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        textField.leftView?.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        
        textField.rightView?.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        
        buttonOne.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.leading)
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    // MARK: Validation and Alert
    
    private func isValidDouble(_ string: String?) -> Bool {
        guard let string = string else { return false }
        return Double(string) != nil
    }
    
    private func showInvalidInputAlert() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number for the amount of money.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
