//
//  SelectKanjiViewController.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 04.02.2025.
//

import UIKit
import SnapKit

class SelectKanjiViewController: UIViewController {
    
    //MARK: - GUI Variables
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Packs", "Explore"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        control.backgroundColor = .appAccent
        return control
    }()
    
    //MARK: - Properties
    
    private let packsVC = PackKanjiViewController()
    private let allKanjiVC = AllKanjiViewController()
    private var currentChildVC: UIViewController?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "kanji".uppercased()
        setupUI()
        switchToChildVC(packsVC)
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        
        view.backgroundColor = .appBackground
        view.addSubview(segmentControl)
        setupConstraints()
    }
    
    private func setupConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func modeChanged() {
        let selectedVC = segmentControl.selectedSegmentIndex == 0 ? packsVC : allKanjiVC
        switchToChildVC(selectedVC)
    }
    
    private func switchToChildVC(_ child: UIViewController) {
        currentChildVC?.willMove(toParent: nil)
        currentChildVC?.view.removeFromSuperview()
        currentChildVC?.removeFromParent()
        
        addChild(child)
        view.addSubview(child.view)
        child.view.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        child.didMove(toParent: self)
        
        currentChildVC = child
    }
}
