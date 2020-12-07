//
//  EditPostView.swift
//  XProject
//
//  Created by Максим Локтев on 12.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal protocol EditPostViewDelegate: class {
    func viewDidChangeTitle(text: String)
    func viewDidChangeDate(text: String, eventDate: Int, createDate: Int)
    func viewDidChangeDescription(text: String)
    func setupSaveBarButtonItem(isEnabled: Bool)

    func viewDidTapButton()
}

internal class EditPostView: UIView, UITextViewDelegate, UITextFieldDelegate {

    enum Constants {
        static let cellSize: CGFloat = (UIScreen.main.bounds.width - 64.0) / 3.0
    }
    
    // MARK: - Properties

    weak var delegate: EditPostViewDelegate?
    
    var genderDidSelected: ((Gender) -> Void)?
    
    private let textFieldInputValidator: TextFieldInputValidator = AlphanumericsValidator()
    
    private var responder: UIView?
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.text = "Фото"
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let collectionView = EditPostCollectionView()
    
    private let titleTextField = TitleTextField(title: "Название*", warning: "Введите название")
    
    private let titleToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(titleToolBarAction)
        )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        return toolBar
    }()

    private let dateTextField = TitleTextField(title: "Дата начала*", warning: "Выберите дату")
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        return toolBar
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale.firstPreferredLocale
        let minAgo = Date()
        let maxAgo = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        datePicker.minimumDate = minAgo
        datePicker.maximumDate = maxAgo
        
        return datePicker
    }()
    
    private let genderTextPicker = TitleTextPicker(title: "Пол*", warning: "Выберите пол")
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.text = "Описание"
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let containerTextView: InputView = InputView()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        textView.textColor = .darkGray
        textView.layer.cornerRadius = 8.0
        textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        return textView
    }()
    
    private let savePostButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.normalBackgroundcolor = .darkGray
        button.highlightedBackgroundcolor = UIColor.darkGray.withAlphaComponent(0.5)
        button.disabledBackgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        button.highlightedTextcolor = UIColor.white.withAlphaComponent(0.5)
        //button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(photoLabel)
        containerView.addSubview(collectionView)

        titleTextField.textField.inputAccessoryView = titleToolBar
        containerView.addSubview(titleTextField)
        titleTextField.textField.delegate = self
        titleTextField.textField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        
        containerView.addSubview(dateTextField)
        dateTextField.textField.delegate = self
        dateTextField.textField.inputView = datePicker
        dateTextField.textField.inputAccessoryView = toolBar
        dateTextField.textField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
        
        containerView.addSubview(genderTextPicker)
        genderTextPicker.genderPicker.genderDidSelected = { [weak self] gender in
            self?.genderDidSelected?(gender)
        }
        
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(containerTextView)
        containerTextView.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        
        containerView.addSubview(savePostButton)
        savePostButton.addTarget(self, action: #selector(savePostButtonAction(_:)), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        addGestureRecognizer(tapGesture)
        
        addObservers()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupLoad(viewModel: EditPostDataFlow.Load.ViewModel) {
        let post = viewModel.postModel
        titleTextField.textField.text = post.title
        descriptionTextView.text = post.description
        
        setupDate(timeInterval: post.date)
        setupGender(gender: viewModel.genderPost)
    }
    
    func setupGender(gender: Gender) {
        switch gender {
        case .defaults:
            genderTextPicker.genderPicker.selectRow(0, inComponent: 0, animated: true)
        case .android:
            genderTextPicker.genderPicker.selectRow(1, inComponent: 0, animated: true)
        case .ios:
            genderTextPicker.genderPicker.selectRow(2, inComponent: 0, animated: true)
        case .php:
            genderTextPicker.genderPicker.selectRow(3, inComponent: 0, animated: true)
        }
    }
    
    func setupInset(contentInset: UIEdgeInsets) {
        scrollView.contentInset = contentInset
        descriptionTextView.scrollIndicatorInsets = contentInset
        descriptionTextView.scrollRangeToVisible(descriptionTextView.selectedRange)
    }
    
    func setupDataManager(dataManager: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.delegate = dataManager
        collectionView.dataSource = dataManager
        collectionView.reloadData()
    }
    
    func setupNameError(isErrorShow: Bool, isValidData: Bool, typeError: EditPostDataFlow.TypeError) {
        switch typeError {
        case .title:
            titleTextField.warningIsHidden = !isErrorShow
        case .date:
            dateTextField.warningIsHidden = !isErrorShow
        case .gender:
            genderTextPicker.warningIsHidden = !isErrorShow
        }
        
        setupSavePostButton(isEnabled: isValidData)
        delegate?.setupSaveBarButtonItem(isEnabled: isValidData)
    }
    
    func setupSavePostButton(isEnabled: Bool) {
        savePostButton.isEnabled = isEnabled
    }
    
    private func setupDate(timeInterval: Int) {
        let eventDate = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        setupDatePicker(date: eventDate)
    }
    
    private func setupDatePicker(date: Date?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        if let date = date {
            dateTextField.textField.text = formatter.string(from: date)
        } else {
            dateTextField.textField.text = formatter.string(from: datePicker.date)
        }
    }
    
    private func setupCreateDate() -> Int {
        let timeInterval = Date().timeIntervalSince1970
        let createDate = Int(timeInterval)
        
        return createDate
    }
    
    private func setupEventDate(date: Date) -> Int {
        let timeInterval = date.timeIntervalSince1970
        let eventDate = Int(timeInterval)
        
        return eventDate
    }
    
    // MARK: - Actions
    
    @objc
    private func titleTextFieldDidChange(_ sender: UITextField) {
        delegate?.viewDidChangeTitle(text: sender.text ?? "")
    }
    
    @objc
    private func dateTextFieldDidChange(_ sender: UITextField) {
        let text = sender.text ?? ""
        let eventDate = setupEventDate(date: datePicker.date)
        let createDate = setupCreateDate()
        delegate?.viewDidChangeDate(text: text, eventDate: eventDate, createDate: createDate)
    }
    
    @objc
    private func savePostButtonAction(_ sender: UIButton) {
        delegate?.viewDidTapButton()
    }
    
    @objc
    private func didTapView(gesture: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc
    private func titleToolBarAction() {
        delegate?.viewDidChangeTitle(text: titleTextField.textField.text ?? "")
        dateTextField.textField.becomeFirstResponder()
    }
    
    @objc
    private func doneAction() {
        setupDatePicker(date: datePicker.date)
        let text = dateTextField.textField.text ?? ""
        let eventDate = setupEventDate(date: datePicker.date)
        let createDate = setupCreateDate()
        delegate?.viewDidChangeDate(text: text, eventDate: eventDate, createDate: createDate)
        endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
        
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard dateTextField.textField != textField else {
            return false
        }
        return textFieldInputValidator.shouldChangeCharacters(of: textField.text ?? "",
                                                              in: range,
                                                              replacementText: string)
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        textFieldInputValidator.shouldChangeTextIn(of: textView.text, in: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.viewDidChangeDescription(text: textView.text)
    }
    
    // MARK: - Keyboard management
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 5.0, right: 0)
        
        let options: UIView.AnimationOptions
        if let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            options = UIView.AnimationOptions(rawValue: animationCurve << 16)
        } else {
            options = []
        }
        
        animationWillStart()
        
        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            performAnimation(duration: duration, options: options, contentInset: contentInset)
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        setupInset(contentInset: UIEdgeInsets.zero)
    }
    
    /// Смена респондера
    private func animationWillStart() {
        if titleTextField.textField.isFirstResponder {
            responder = titleTextField
        } else if dateTextField.textField.isFirstResponder {
            responder = dateTextField
        } else if descriptionTextView.isFirstResponder {
            responder = containerTextView
        }
    }
    
    private func performAnimation(duration: TimeInterval,
                                  options: UIView.AnimationOptions,
                                  contentInset: UIEdgeInsets) {
        let rect: CGRect = (responder?.frame ?? .zero).inset(
            by: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -16.0, right: 0.0)
        )
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            self.setupInset(contentInset: contentInset)
            self.scrollView.scrollRectToVisible(rect, animated: false)
        })
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(snp.width)
        }
        photoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.height.equalTo(15.0)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.cellSize + 12.0)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(25.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(5.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        genderTextPicker.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(5.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(genderTextPicker.snp.bottom).offset(5.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.height.equalTo(15.0)
        }
        containerTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.height.equalTo(128.0)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        savePostButton.snp.makeConstraints { make in
            make.top.equalTo(containerTextView.snp.bottom).offset(32.0)
            make.left.right.bottom.equalToSuperview().inset(16.0)
            make.height.equalTo(56.0)
        }
    }
}
