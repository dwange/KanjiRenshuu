//
//  AuthViewModel.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 21/10/25.
//
import Foundation
import FirebaseAuth

final class AuthViewModel {
    
    var onAuthSuccess: ((User) -> Void)?
    var onAuthError: ((String) -> Void)?
    var onPasswordResetSent: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private let authService = AuthService.shared
    
    // MARK: - Public Methods
    
    func signIn(email: String, password: String) {
        onLoadingStateChange?(true)
        authService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)
                switch result {
                case .success(let user):
                    self?.onAuthSuccess?(user)
                case .failure(let error):
                    self?.onAuthError?(error.localizedDescription)
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        onLoadingStateChange?(true)
        authService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)
                switch result {
                case .success(let user):
                    self?.onAuthSuccess?(user)
                case .failure(let error):
                    self?.onAuthError?(error.localizedDescription)
                }
            }
        }
    }
    
    func sendPasswordReset(email: String) {
            guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                onAuthError?("Please enter your email to reset your password.")
                return
            }

            onLoadingStateChange?(true)
            authService.sendPasswordReset(email: email) { [weak self] error in
                DispatchQueue.main.async {
                    self?.onLoadingStateChange?(false)
                    if let err = error {
                        self?.onAuthError?(err.localizedDescription)
                    } else {
                        self?.onPasswordResetSent?()
                    }
                }
            }
        }
    
    func signOut() {
       authService.signOut()
    }
}
