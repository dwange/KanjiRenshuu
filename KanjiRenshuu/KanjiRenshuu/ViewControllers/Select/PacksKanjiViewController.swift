//
//  PacksKanjiView.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 25/08/25.
//

import UIKit

final class PackKanjiViewController: KanjiCollectionViewController {
  
    //MARK: - Properties

    private let viewModel = PacksViewModel()
 
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        viewModel.loadPacks()
    }
}

// MARK: - DataSource
extension PackKanjiViewController: KanjiCollectionViewControllerDataSource {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.packs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.packs[section].kanji.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SelectKanjiViewCell",
            for: indexPath
        ) as? SelectKanjiViewCell else { return UICollectionViewCell() }
        
        let character = viewModel.packs[indexPath.section].kanji[indexPath.item]
        cell.configure(with: character)
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: KanjiSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! KanjiSectionHeaderView
        headerView.configure(with: viewModel.packs[indexPath.section].title)
        return headerView
    }
}

// MARK: - Delegate
extension PackKanjiViewController: SelectKanjiViewCellDelegate {

    func didTapKanjiButton(kanji: String) {
        let detailManager = KanjiDetailManager()
        detailManager.fetchKanjiDetails(kanji: kanji) { [weak self] kanjiObject in
            guard let self else { return }
            DispatchQueue.main.async {
                if let kanjiObject = kanjiObject {
                    self.showDrawViewController(for: kanjiObject, kanjiGroup: [kanjiObject])
                } else {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Could not load kanji details for \(kanji)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

