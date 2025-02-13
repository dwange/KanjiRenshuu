//
//  SelectKanjiViewCell.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 05.02.2025.
//

import UIKit
import SnapKit

protocol SelectKanjiViewCellDelegate: AnyObject {
    
    func didTapKanjiButton(kanji: String)
}

final class SelectKanjiViewCell: UICollectionViewCell {
    
    //MARK: - GUI Variables
    
    private let kanjiButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(kanjiButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Properties
    
    weak var delegate: SelectKanjiViewCellDelegate?
    private var kanji: String = ""
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        addSubview(kanjiButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        kanjiButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    @objc private func kanjiButtonTapped() {
        delegate?.didTapKanjiButton(kanji: kanji)
    }
    
    //MARK: - Methods
    
    func configure(with kanjiObject: KanjiObject) {
        kanji = kanjiObject.kanji
        kanjiButton.setTitle(kanji, for: .normal)
    }
}

