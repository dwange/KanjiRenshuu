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
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK: - Properties
    
    private let kanjiManager = KanjiManager()
    private var sortedGrades: [Int?] = []
    private var kanjiByGrade: [Int?: [KanjiObject]] = [:]
    
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
        collectionView.register(KanjiSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: KanjiSectionHeaderView.reuseIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(50))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(110))
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [item])
            verticalGroup.interItemSpacing = .fixed(10)
            
            let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(1000), heightDimension: .absolute(110))
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
            horizontalGroup.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 15
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            return section
        }
    }
    
    private func fetchKanji() {
        kanjiManager.fetchAllKanji { [weak self] groupedKanji in
            guard let self = self else { return }
            let filteredGroupedKanji = groupedKanji.filter { (key, value) in
                return key != nil
            }
            self.kanjiByGrade = filteredGroupedKanji
            self.sortedGrades = filteredGroupedKanji.keys.sorted { $0 ?? Int.max < $1 ?? Int.max }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sortedGrades.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let grade = sortedGrades[section]
        return kanjiByGrade[grade]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectKanjiViewCell", for: indexPath) as? SelectKanjiViewCell else {
            return UICollectionViewCell()
        }
        
        let grade = sortedGrades[indexPath.section]
        if let kanjiList = kanjiByGrade[grade] {
            cell.configure(with: kanjiList[indexPath.item])
        }
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KanjiSectionHeaderView.reuseIdentifier, for: indexPath) as! KanjiSectionHeaderView
        
        let grade = sortedGrades[indexPath.section]
        let title = grade != nil ? "Grade \(grade!)" : "Ungraded Kanji"
        
        headerView.configure(with: title)
        return headerView
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
