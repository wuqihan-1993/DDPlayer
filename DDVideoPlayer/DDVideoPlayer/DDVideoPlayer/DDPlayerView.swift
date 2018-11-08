//
//  DDPlayerView.swift
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/8.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class DDPlayerView: UIView {

    @objc lazy var player: DDPlayer = {
        var player = DDPlayer()
        player.delegate = self
        return player
    }()
    
    private lazy var containerView: DDVideoPlayerContainerView = {
        let containerView = DDVideoPlayerContainerView()
        return containerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        player.bind(to: layer as! AVPlayerLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    private func initUI() {
        backgroundColor = UIColor.black
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK
extension DDPlayerView: DDPlayerDelegate {
    func playerTimeChanged(_ currentTime: TimeInterval) {
        self.containerView.bottomLandscapeView.slider.value = Float(currentTime/self.player.duration);
        self.containerView.bottomPortraitView.slider.value = Float(currentTime/self.player.duration);
    }
}
