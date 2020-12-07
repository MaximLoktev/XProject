//
//  EditProfileView.swift
//  XProject
//
//  Created by Максим Локтев on 09.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditProfileViewDelegate: class {
    func viewDidChangeName(text: String)
    func viewDidChangeEmail(text: String)
    func viewDidChangeBirthday(birthday: Int)
    func setupSaveBarButtonItem(isEnabled: Bool)
    func editProfileImage()
    func deleteProfileImage(image: UIImage)
    func viewDidTapButton()
}

internal class EditProfileView: UIView, UITextFieldDelegate {

    // MARK: - Properties

    weak var delegate: EditProfileViewDelegate?
    
    var genderDidSelected: ((Gender) -> Void)?
    
    private let textFieldInputValidator: TextFieldInputValidator = AlphanumericsValidator()
    
    private var responder: UIView?
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.text = "Фото*"
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let warningImageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 13.0)
        label.isHidden = true
        label.text = "Выберите фото"
        
        return label
    }()
    
    private let deletePhotoButton: UIButton = {
        let button = AdjustedTapAreaButton()
        button.setImage(#imageLiteral(resourceName: "cancelIcon"), for: .normal)
        button.backgroundColor = .darkSkyBlue
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10.0
            
        return button
    }()
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = UIColor.darkGrey50.cgColor
        layer.lineWidth = 1.0
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.lineDashPattern = [8, 10]
        layer.isHidden = true
        
        return layer
    }()
    
    private let shapeLayerFill: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.borderColor = UIColor.darkSkyBlue.cgColor
        layer.cornerRadius = 8.0
        layer.borderWidth = 2
        layer.isHidden = false
        
        return layer
    }()
    
    private let nameTextField = TitleTextField(title: "Имя*", warning: "Введите имя")
    
    private let nameToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(nameToolBarAction)
        )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        return toolBar
    }()
    
    private let emailTextField = TitleTextField(title: "E-mail", warning: "Введите E-mail")
    
    private let emailToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(emailToolBarAction)
        )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        return toolBar
    }()

    private let birthdayTextField = TitleTextField(title: "Дата рождения", warning: "Выберите дату")
    
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
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.firstPreferredLocale
        let minAgo = Date()
        let maxAgo = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        datePicker.minimumDate = minAgo
        datePicker.maximumDate = maxAgo
        
        return datePicker
    }()
    
    private let genderTextPicker = TitleTextPicker(title: "Пол*", warning: "Выберите пол")
    
    private let saveProfileButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.normalBackgroundcolor = .darkGray
        button.highlightedBackgroundcolor = UIColor.darkGray.withAlphaComponent(0.5)
        button.disabledBackgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        button.highlightedTextcolor = UIColor.white.withAlphaComponent(0.5)

        return button
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        addGestureRecognizer(tapGesture)
        
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(photoLabel)
        
        containerView.addSubview(contentImageView)
        contentImageView.isUserInteractionEnabled = false
        contentImageView.layer.addSublayer(shapeLayer)
        contentImageView.layer.addSublayer(shapeLayerFill)
        
        let tapGesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapGestureAction))
        contentImageView.addGestureRecognizer(tapGesureRecognizer)
        
        containerView.addSubview(warningImageLabel)
        
        containerView.addSubview(deletePhotoButton)
        deletePhotoButton.addTarget(self, action: #selector(deletePhotoAction), for: .touchUpInside)
        
        containerView.addSubview(nameTextField)
        nameTextField.textField.delegate = self
        nameTextField.textField.inputAccessoryView = nameToolBar
        nameTextField.textField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        
        containerView.addSubview(emailTextField)
        emailTextField.textField.delegate = self
        emailTextField.textField.inputAccessoryView = emailToolBar
        emailTextField.textField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        
        containerView.addSubview(birthdayTextField)
        birthdayTextField.textField.delegate = self
        birthdayTextField.textField.inputView = datePicker
        birthdayTextField.textField.inputAccessoryView = toolBar
        birthdayTextField.textField.addTarget(self,
                                              action: #selector(birthdayTextFieldDidChange(_:)),
                                              for: .editingChanged)
        
        containerView.addSubview(genderTextPicker)
        genderTextPicker.genderPicker.genderDidSelected = { [weak self] gender in
            self?.genderDidSelected?(gender)
        }
        
        containerView.addSubview(saveProfileButton)
        saveProfileButton.addTarget(self, action: #selector(saveProfileButtonAction(_:)), for: .touchUpInside)
        
        addObservers()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.bounds = contentImageView.bounds
        shapeLayer.position = CGPoint(x: contentImageView.bounds.width / 2, y: contentImageView.bounds.height / 2)
        shapeLayer.path = UIBezierPath(roundedRect: contentImageView.bounds, cornerRadius: 8.0).cgPath
        
        shapeLayerFill.bounds = contentImageView.bounds
        shapeLayerFill.position = CGPoint(x: contentImageView.bounds.width / 2, y: contentImageView.bounds.height / 2)
    }
    
    // MARK: - Setup

    func setupLoad(viewModel: EditProfileDataFlow.Load.ViewModel) {
        let profileModel = viewModel.profileModel
        contentImageView.kf.setImage(with: URL(string: profileModel.imageURL))
        nameTextField.textField.text = profileModel.name
        emailTextField.textField.text = profileModel.email
        setupGender(gender: viewModel.gender)
        
        guard let birthday = profileModel.birthday else {
            return
        }
        setupBirthday(timeInterval: birthday)
    }
    
    func getImage() -> UIImage? {
        return contentImageView.image
    }
    
    func setupImage(image: UIImage?, state: EditProfileDataFlow.State) {
        switch state {
        case .fill:
            shapeLayer.isHidden = true
            shapeLayerFill.isHidden = false
            deletePhotoButton.isHidden = false
            contentImageView.isUserInteractionEnabled = false
        case .active:
            shapeLayer.isHidden = false
            shapeLayerFill.isHidden = true
            deletePhotoButton.isHidden = true
            contentImageView.isUserInteractionEnabled = true
        }
        contentImageView.image = image
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
    }
    
    func setupNameError(isErrorShow: Bool, isValidData: Bool, typeError: EditProfileDataFlow.TypeError) {
        switch typeError {
        case .name:
            nameTextField.warningIsHidden = !isErrorShow
        case .gender:
            genderTextPicker.warningIsHidden = !isErrorShow
        case .image:
            warningImageLabel.isHidden = !isErrorShow
        }
        
        setupSaveProfileButton(isEnabled: isValidData)
        delegate?.setupSaveBarButtonItem(isEnabled: isValidData)
    }
    
    private func setupBirthday(timeInterval: Int) {
        let birthday = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        setupDatePicker(date: birthday)
    }
    
    private func setupSaveProfileButton(isEnabled: Bool) {
        saveProfileButton.isEnabled = isEnabled
    }
    
    private func setupDatePicker(date: Date?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        if let date = date {
            birthdayTextField.textField.text = formatter.string(from: date)
        } else {
            birthdayTextField.textField.text = formatter.string(from: datePicker.date)
        }
    }
    
    private func setupBirthdayInterval(date: Date) -> Int {
        let timeInterval = date.timeIntervalSince1970
        let birthday = Int(timeInterval)
        
        return birthday
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapView(gesture: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc
    func photoTapGestureAction() {
        delegate?.editProfileImage()
    }
    
    @objc
    func deletePhotoAction() {
        let image = #imageLiteral(resourceName: "Artboard")
        delegate?.deleteProfileImage(image: image)
    }
    
    @objc
    private func nameTextFieldDidChange(_ sender: UITextField) {
        delegate?.viewDidChangeName(text: sender.text ?? "")
    }
    
    @objc
    private func emailTextFieldDidChange(_ sender: UITextField) {
        delegate?.viewDidChangeEmail(text: sender.text ?? "")
    }
    
    @objc
    private func birthdayTextFieldDidChange(_ sender: UITextField) {
        let birthday = setupBirthdayInterval(date: datePicker.date)
        delegate?.viewDidChangeBirthday(birthday: birthday)
    }
    
    @objc
    private func nameToolBarAction() {
        delegate?.viewDidChangeName(text: nameTextField.textField.text ?? "")
        emailTextField.textField.becomeFirstResponder()
    }
    
    @objc
    private func emailToolBarAction() {
        delegate?.viewDidChangeEmail(text: emailTextField.textField.text ?? "")
        birthdayTextField.textField.becomeFirstResponder()
    }
    
    @objc
    private func doneAction() {
        setupDatePicker(date: datePicker.date)
        let birthday = setupBirthdayInterval(date: datePicker.date)
        delegate?.viewDidChangeBirthday(birthday: birthday)
        endEditing(true)
    }
    
    @objc
    private func saveProfileButtonAction(_ sender: UIButton) {
        delegate?.viewDidTapButton()
    }
    
    // MARK: - UITextFieldDelegate
        
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard birthdayTextField.textField != textField else {
            return false
        }
        return textFieldInputValidator.shouldChangeCharacters(of: textField.text ?? "",
                                                              in: range,
                                                              replacementText: string)
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
        if nameTextField.textField.isFirstResponder {
            responder = nameTextField
        } else if emailTextField.textField.isFirstResponder {
            responder = emailTextField
        } else if birthdayTextField.isFirstResponder {
            responder = birthdayTextField
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
            make.top.left.right.equalToSuperview().inset(16.0)
            make.height.equalTo(15.0)
        }
        contentImageView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(16.0)
            make.height.width.equalTo(snp.width).multipliedBy(0.3)
        }
        warningImageLabel.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.height.equalTo(15.0)
        }
        deletePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(contentImageView).offset(-7.0)
            make.right.equalTo(contentImageView).offset(7.0)
            make.height.width.equalTo(20.0)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(5.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        birthdayTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        genderTextPicker.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(5.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        saveProfileButton.snp.makeConstraints { make in
            make.top.equalTo(genderTextPicker.snp.bottom).offset(16.0)
            make.left.right.bottom.equalToSuperview().inset(16.0)
            make.height.equalTo(56.0)
        }
    }
}
