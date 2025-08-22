//
//  SelectKanjiViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import UIKit
import SnapKit

class SelectKanjiViewController: UIViewController {
    
    enum Mode { case packs, explore }
    
    //MARK: - GUI Variables
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Packs", "Explore"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        control.backgroundColor = .white
        return control
    }()
    
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
    
    private let viewModel = SelectKanjiViewModel()
    private let packsViewModel = PacksViewModel()
    
    private var currentMode: Mode = .packs
    
    private var kanjiLoadingView: KanjiLoadingView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "kanji".uppercased()
        setupUI()
        bindViewModel()
        showKanjiLoadingAnimation()
        packsViewModel.loadPacks()
        viewModel.fetchKanji()
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(segmentControl)
        view.addSubview(collectionView)
        
        collectionView.register(SelectKanjiViewCell.self, forCellWithReuseIdentifier: "SelectKanjiViewCell")
        collectionView.register(KanjiSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: KanjiSectionHeaderView.reuseIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func modeChanged() {
        currentMode = segmentControl.selectedSegmentIndex == 0 ? .packs : .explore
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: true)
        collectionView.reloadData()
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
    
    private func showKanjiLoadingAnimation() {
        let kanjiLoadingView = KanjiLoadingView()
        self.kanjiLoadingView = kanjiLoadingView
        view.addSubview(kanjiLoadingView)
        kanjiLoadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.kanjiLoadingView.stop()
                self?.kanjiLoadingView.removeFromSuperview()
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SelectKanjiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDataSource
extension SelectKanjiViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch currentMode {
        case .packs:
            return packsViewModel.packs.count
        case .explore:
            return viewModel.sortedGrades.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentMode {
        case .packs:
            return packsViewModel.packs[section].kanji.count
        case .explore:
            let grade = viewModel.sortedGrades[section]
            return viewModel.kanjiByGrade[grade]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectKanjiViewCell", for: indexPath) as? SelectKanjiViewCell else { return UICollectionViewCell() }
        
        switch currentMode {
        case .packs:
            let character = packsViewModel.packs[indexPath.section].kanji[indexPath.item]
            cell.configure(with: character)
        case .explore:
            let grade = viewModel.sortedGrades[indexPath.section]
            if let kanjiList = viewModel.kanjiByGrade[grade] {
                cell.configure(with: kanjiList[indexPath.item])
            }
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KanjiSectionHeaderView.reuseIdentifier, for: indexPath) as! KanjiSectionHeaderView
        
        switch currentMode {
        case .packs:
            headerView.configure(with: packsViewModel.packs[indexPath.section].title)
        case .explore:
            let grade = viewModel.sortedGrades[indexPath.section]
            headerView.configure(with: grade != nil ? "Grade \(grade!)" : "Ungraded Kanji")
        }
        return headerView
    }
}

// MARK: - SelectKanjiViewCellDelegate
extension SelectKanjiViewController: SelectKanjiViewCellDelegate {
    func didTapKanjiButton(kanji: String) {
        let drawVC = DrawViewController()
        drawVC.viewModel.kanji = kanji

        for (_, kanjiList) in viewModel.kanjiByGrade {
            if let matchedKanji = kanjiList.first(where: { $0.kanji.character == kanji }) {
                drawVC.viewModel.kanjiGroup = kanjiList

                if let posterString = matchedKanji.kanji.video.poster,
                   let posterURL = URL(string: posterString) {
                    drawVC.posterURL = posterURL
                }

                if let videoString = matchedKanji.kanji.video.mp4,
                   let videoURL = URL(string: videoString) {
                    drawVC.videoURL = videoURL
                }

                break
            }
        }

        navigationController?.pushViewController(drawVC, animated: true)
    }
}


