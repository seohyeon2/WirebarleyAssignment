//
//  ExchangeRateCalculatorViewController.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/27/24.
//

import UIKit

class ExchangeRateCalculatorViewController: UIViewController, UISheetPresentationControllerDelegate {

    private let viewModel: ExchangeRateCalculatorViewModel = ExchangeRateCalculatorViewModel(exchangeRateService: ExchangeRateService())
    
    // MARK: UI 요소 정의
    // 타이틀
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 계산"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 송금 국가, 수취국가, 환율, 조회시간, 송금액 담을 스택
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 송금국가 관련 스택
    private let remittanceCountryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let remittanceCountryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "송금국가 :"
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remittanceCountryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "미국 (USD)"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 수취국가 관련 스택
    private let recipientCountryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let recipientCountryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수취국가 :"
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipientCountryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "한국 (KRW)"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recipientCountrySelectionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.down")
        button.setImage(
            image,
            for: .normal
        )
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(openSelectionView),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 환율 관련 스택
    private let exchangeRateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let exchangeRateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 :"
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 조회시간 관련 스택
    private let viewTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let viewTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회시간 :"
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 송금액 관련 스택
    private let remittanceAmountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let remittanceAmountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "송금액 :"
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let remittanceAmountTextField: UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.textAlignment = .right
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.keyboardType = .numberPad
        textField.borderStyle  = .line
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let remittanceCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 수취금액 결과
    private let recipientAmountResultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: -
    // MARK: initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewConstraint()
        setupText()

        remittanceAmountTextField.delegate = self
    }

    // MARK: -
    // MARK: UI Method
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(contentStackView)
        view.addSubview(recipientAmountResultLabel)
        
        contentStackView.addArrangedSubview(remittanceCountryStackView)
        contentStackView.addArrangedSubview(recipientCountryStackView)
        contentStackView.addArrangedSubview(exchangeRateStackView)
        contentStackView.addArrangedSubview(viewTimeStackView)
        contentStackView.addArrangedSubview(remittanceAmountStackView)
        
        remittanceCountryStackView.addArrangedSubview(remittanceCountryTitleLabel)
        remittanceCountryStackView.addArrangedSubview(remittanceCountryNameLabel)

        recipientCountryStackView.addArrangedSubview(recipientCountryTitleLabel)
        recipientCountryStackView.addArrangedSubview(recipientCountryNameLabel)
        recipientCountryStackView.addArrangedSubview(recipientCountrySelectionButton)
        
        exchangeRateStackView.addArrangedSubview(exchangeRateTitleLabel)
        exchangeRateStackView.addArrangedSubview(exchangeRateLabel)
        
        viewTimeStackView.addArrangedSubview(viewTimeTitleLabel)
        viewTimeStackView.addArrangedSubview(viewTimeLabel)
        
        remittanceAmountStackView.addArrangedSubview(remittanceAmountTitleLabel)
        remittanceAmountStackView.addArrangedSubview(remittanceAmountTextField)
        remittanceAmountStackView.addArrangedSubview(remittanceCurrencyLabel)
    }
    
    private func setupViewConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),

            recipientAmountResultLabel.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 60),
            recipientAmountResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recipientAmountResultLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            remittanceCountryTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            recipientCountryTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            exchangeRateTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            viewTimeTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            remittanceAmountTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            remittanceAmountTextField.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupText() {
        viewModel.loadExchangeRate(recipientCountry: recipientCountryNameLabel.text ?? "한국(KRW)") { [weak self] exchangeRateInfo in
            
            DispatchQueue.main.async { [weak self] in
                let formatNumber = self?.viewModel.formatNumber(exchangeRateInfo.rate) ?? ""
                self?.exchangeRateLabel.text = "\(String(describing: formatNumber)) \(exchangeRateInfo.currency) / USD"
                
                self?.viewTimeLabel.text = self?.viewModel.formatDate()

                self?.recipientAmountResultLabel.text = "수취금액은 0.00 \(exchangeRateInfo.currency) 입니다"
            }
        }
    }
    
    private func updateExchangeRateUI(recipientCountry: String, currency: String, exchangeRate: Double) {
        recipientCountryNameLabel.text = recipientCountry
        let formattedNumber = viewModel.formatNumber(exchangeRate)
        exchangeRateLabel.text = "\(formattedNumber) \(currency) / USD"
        textFieldDidChangeSelection(remittanceAmountTextField)
    }
    
    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: -
    // MARK: Action Method
    @objc private func openSelectionView() {
        let selectionViewController = RecipientCountrySelectionViewController()
        selectionViewController.delegate = self
        present(selectionViewController, animated: true, completion: nil)
    }
}

// MARK: -
// MARK: SendDataDelegate Extension
extension ExchangeRateCalculatorViewController: SendDataDelegate {
    func sendData<T>(_ data: T) {
        guard let recipientCountry = data as? String else {
            return
        }
        
        viewModel.loadExchangeRate(recipientCountry: recipientCountry) { [weak self] exchangeRateInfo in
            DispatchQueue.main.async {
                self?.updateExchangeRateUI(recipientCountry: recipientCountry, currency: exchangeRateInfo.currency, exchangeRate: exchangeRateInfo.rate)
            }
        }
    }
}

// MARK: -
// MARK: TextFieldDelegate Extension
extension ExchangeRateCalculatorViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            return
        }
        
        guard let amountText = textField.text,
              let amount = Double(amountText),
                amount >= 0.0, amount <= 10000.0,
              amountText.isEmpty || !amountText.isEmpty else {
            presentAlert(message: "송금액이 바르지 않습니다")
            textField.text = "0.0"
            return
        }

        viewModel.convertToForeignAmount(money: textField.text ?? "") { [weak self] result in
            switch result {
            case .success(let amount):
                let formattedNumber = self?.viewModel.formatNumber(amount) ?? ""
                let currency = self?.viewModel.exchangeRateInfo.currency ?? ""
                self?.recipientAmountResultLabel.text = "수취금액은 \(formattedNumber) \(currency) 입니다"
            case .failure(let error):
                print(error)
            }
        }
    }
}
