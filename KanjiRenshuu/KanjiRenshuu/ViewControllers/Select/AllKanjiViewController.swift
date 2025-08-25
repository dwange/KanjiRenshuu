//
//  AllKanjiView.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 25/08/25.
//

import UIKit

final class AllKanjiViewController: KanjiCollectionViewController {
    
    //MARK: - Properties
    
    private let viewModel = SelectKanjiViewModel()
    private var kanjiLoadingView: KanjiLoadingView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        showKanjiLoadingAnimation()
        viewModel.fetchKanji()
        bindViewModel()
    }
    
    //MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.kanjiLoadingView?.stop()
            self?.kanjiLoadingView?.removeFromSuperview()
            self?.reloadData()
        }
    }
    
    private func showKanjiLoadingAnimation() {
        let kanjiLoadingView = KanjiLoadingView()
        self.kanjiLoadingView = kanjiLoadingView
        view.addSubview(kanjiLoadingView)
        kanjiLoadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
    }
}

// MARK: - DataSource
extension AllKanjiViewController: KanjiCollectionViewControllerDataSource {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sortedGrades.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let grade = viewModel.sortedGrades[section]
        return viewModel.kanjiByGrade[grade]?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SelectKanjiViewCell",
            for: indexPath
        ) as? SelectKanjiViewCell else { return UICollectionViewCell() }
        
        let grade = viewModel.sortedGrades[indexPath.section]
        if let kanjiList = viewModel.kanjiByGrade[grade] {
            cell.configure(with: kanjiList[indexPath.item])
        }
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: KanjiSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! KanjiSectionHeaderView
        
        let grade = viewModel.sortedGrades[indexPath.section]
        headerView.configure(with: grade != nil ? "Grade \(grade!)" : "Ungraded Kanji")
        return headerView
    }
}

// MARK: - Delegate
extension AllKanjiViewController: SelectKanjiViewCellDelegate {
    
    func didTapKanjiButton(kanji: String) {
        for (_, kanjiList) in viewModel.kanjiByGrade {
            if let matchedKanji = kanjiList.first(where: { $0.kanji.character == kanji }) {
                showDrawViewController(for: matchedKanji, kanjiGroup: kanjiList)
                break
            }
        }
    }
}

