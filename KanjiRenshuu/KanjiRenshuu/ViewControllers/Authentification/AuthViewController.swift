//
//  AuthViewController.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 24/10/25.
//

import UIKit
import SnapKit

enum AuthMode {
    case signIn
    case signUp
}

final class AuthViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.appPrimary.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sign In", "Sign Up"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .appPrimary
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.appText], for: .normal)
        return control
    }()
    
    private let emailField = AuthTextField(placeholder: "Email", isSecure: false)
    private let passwordField = AuthTextField(placeholder: "Password", isSecure: true)
    private let confirmPasswordField = AuthTextField(placeholder: "Confirm Password", isSecure: true)
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .appPrimary
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
        
    }()
    
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
        
    }()
    //MARK: - Properties
    
    private var mode: AuthMode = .signIn {
        didSet {
            updateUIForMode(animated: true)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupActions()
    }
    
    //MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .appBackground
        view.addSubview(cardView)
        cardView.addSubViews([segmentedControl, emailField, passwordField, confirmPasswordField, actionButton, messageLabel])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.leading.trailing.equalTo(cardView).inset(16)
            make.height.equalTo(32)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(25)
            make.leading.trailing.equalTo(cardView).inset(20)
            make.height.equalTo(44)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(emailField)
        }
        
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(emailField)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(25)
            make.leading.trailing.equalTo(emailField)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(12)
            make.leading.trailing.equalTo(emailField)
            make.bottom.equalTo(cardView.snp.bottom).offset(-20)
        }
        
        updateUIForMode(animated: false)
        
    }
    
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc private func modeChanged() {
        mode = segmentedControl.selectedSegmentIndex == 0 ? .signIn : .signUp
    }
    
    @objc private func actionButtonTapped() {
        messageLabel.text = ""
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            messageLabel.text = "Please enter email and password."
            return
        }
        
        switch mode {
        case .signIn:
            AuthService.shared.signIn(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self?.messageLabel.textColor = .systemGreen
                        self?.messageLabel.text = "Welcome back, \(user.email ?? "")!"
                    case .failure(let error):
                        self?.messageLabel.textColor = .systemRed
                        self?.messageLabel.text = error.localizedDescription
                    }
                }
            }
            
        case .signUp:
            guard let confirm = confirmPasswordField.text, password == confirm else {
                messageLabel.text = "Passwords do not match."
                return
            }
            
            AuthService.shared.signUp(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self?.messageLabel.textColor = .systemGreen
                        self?.messageLabel.text = "Account created for \(user.email ?? "")!"
                    case .failure(let error):
                        self?.messageLabel.textColor = .systemRed
                        self?.messageLabel.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    private func updateUIForMode(animated: Bool) {
        let isSignIn = (mode == .signIn)
        confirmPasswordField.isHidden = isSignIn
        actionButton.setTitle(isSignIn ? "Log In" : "Create Account", for: .normal)
        messageLabel.text = ""
        
        if animated {
            UIView.transition(with: cardView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.cardView.layoutIfNeeded()
            })
        }
    }
}

final class AuthTextField: UITextField {
    init(placeholder: String, isSecure: Bool) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
