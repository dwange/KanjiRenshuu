//
//  KanjiVideoPlayerView.swift
//  KanjiRenshuu
//
//  Created by Ekaterina Savina on 15/05/25.
//

import UIKit
import AVKit
import SVGKit
import SnapKit

class KanjiVideoPlayerView: UIView {
    
    private var svgImageView: SVGKFastImageView!
    private let playButton = UIButton(type: .system)
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    var videoURL: URL?
    var posterURL: URL? {
        didSet {
            if let url = posterURL {
                loadPoster(from: url)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        svgImageView = SVGKFastImageView(svgkImage: SVGKImage())
        svgImageView.contentMode = .scaleAspectFit
        svgImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(svgImageView)
        
        svgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .systemBlue
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        addSubview(playButton)
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    private func loadPoster(from url: URL) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let svgImage = SVGKImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.svgImageView.removeFromSuperview()
                self.svgImageView = SVGKFastImageView(svgkImage: svgImage)
                self.svgImageView.contentMode = .scaleAspectFit
                self.svgImageView.translatesAutoresizingMaskIntoConstraints = false
                self.insertSubview(self.svgImageView, at: 0)
                
                self.svgImageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    @objc private func playTapped() {
        guard let videoURL else { return }
        
        playButton.isHidden = true
        svgImageView.isHidden = true
        
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspect
        if let layer = playerLayer {
            self.layer.addSublayer(layer)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        player?.play()
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        
        svgImageView.isHidden = false
        playButton.isHidden = false
    }
    
    func resetPlayerState() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        
        svgImageView.isHidden = false
        playButton.isHidden = false
    }
}

