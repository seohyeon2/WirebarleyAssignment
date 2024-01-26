//
//  ExchangeRateCalculatorViewController.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/27/24.
//

import UIKit

class ExchangeRateCalculatorViewController: UIViewController {

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
//        button.addTarget(
//            self,
//            action: #selector(),
//            for: .touchUpInside
//        )
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
        label.text = "1,130.05 KRW / USD"
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
        label.text = "2019-03-20 16:13"
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

    let remittanceAmountTextField: UITextField = {
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
    let recipientAmountResultLabel: UILabel = {
        let label = UILabel()
        label.text = "수취금액은 113,004.98 KRW 입니다"
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
    }

    // MARK: -
    // MARK: UI Method
    func setupUI() {
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
            
            remittanceCountryTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            recipientCountryTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            exchangeRateTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            viewTimeTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            remittanceAmountTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            remittanceAmountTextField.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
