//
//  RecipientCountrySelectionViewController.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/27/24.
//

import UIKit

class RecipientCountrySelectionViewController: UIViewController {
    weak var delegate: SendDataDelegate?
    private let viewModel:RecipientCountrySelectionViewModel = RecipientCountrySelectionViewModel()
    
    // MARK: UI 요소 정의
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupViewConstraint()
        setupPickerView()
    }
    
    // 출처: https://stackoverflow.com/questions/42106980/how-to-present-a-viewcontroller-on-half-screen
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 5 * 3, width: self.view.bounds.width, height: UIScreen.main.bounds.height / 5 * 2)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.sendData(viewModel.getSelectedCountry())
    }
    
    // MARK: -
    // MARK: UI Method
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(pickerView)
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPickerView))
        tapGesture.delegate = self
        pickerView.addGestureRecognizer(tapGesture)
    }
    
    private func setupViewConstraint() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -5),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 5)
        ])
    }
    
    // MARK: -
    // MARK: Action Method
    @objc func didTapPickerView(gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: -
// MARK: PickerView Extension
extension RecipientCountrySelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getPickerDate().count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setSelectedCountry(by: row)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = "\(viewModel.getPickerDate()[row])"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }
}

// MARK: -
// MARK: GestureRecognizer Extension
extension RecipientCountrySelectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
