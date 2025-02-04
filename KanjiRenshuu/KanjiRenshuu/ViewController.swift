//
//  ViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 21.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kanji Renshuu"
        label.font = UIFont(name: "Arial Bold", size: 35)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("Draw", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 25)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToDrawViewController), for: .touchUpInside)
        
        return button
    }()

    private lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Match", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial Bold", size: 25)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowColor = UIColor.systemCyan.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToMatchViewController), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Properties
    
    private let cornerRadius: CGFloat = 20
    private let buttonHeight: CGFloat = 80
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    //MARK: - Private methods
    
    @objc private func goToDrawViewController() {
        navigationController?.pushViewController(DrawViewController(), animated: true)

     }
     
     @objc private func goToMatchViewController() {
         navigationController?.pushViewController(MatchViewController(), animated: true)

      }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(firstButton)
        view.addSubview(secondButton)
        
        view.backgroundColor = .white

        setupConstraints()

    }
    
    private func setupConstraints() {
        
        firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        firstButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: firstButton.topAnchor, constant: -80).isActive = true
        
        secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 40).isActive = true
        secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        secondButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
    }

}

