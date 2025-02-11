//
//  SelectKanjiViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import Foundation
import UIKit

class SelectKanjiViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK: - Properties
    
    private let kanjiManager = KanjiManager()
    private var kanjiData = [KanjiObject]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "kanji".uppercased()
        setupUI()
        fetchKanji()
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.register(SelectKanjiViewCell.self, forCellWithReuseIdentifier: "SelectKanjiViewCell")
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchKanji() {
        kanjiManager.fetchAllKanji { [weak self] kanjiList in
            self?.kanjiData = kanjiList
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: - UICollectionViewDelegate

extension SelectKanjiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - UICollectionViewDataSource

extension SelectKanjiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        kanjiData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectKanjiViewCell", for: indexPath) as? SelectKanjiViewCell else {return UICollectionViewCell()}
        cell.configure(with: kanjiData[indexPath.item])
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
}

//MARK: - SelectKanjiViewCellDelegate

extension SelectKanjiViewController: SelectKanjiViewCellDelegate {
    
    func didTapKanjiButton(kanji: String) {
        let drawVC = DrawViewController()
        drawVC.kanji = kanji
        navigationController?.pushViewController(drawVC, animated: true)
    }
}
