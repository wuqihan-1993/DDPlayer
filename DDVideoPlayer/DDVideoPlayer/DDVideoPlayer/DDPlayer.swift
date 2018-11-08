//
//  DDPlayer.swift
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/8.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit
import AVFoundation

class DDPlayer: NSObject {
    
    enum Status {
        case unknown
        case buffering
        case playing
        case paused
        case end
        case error
    }
    
    weak var delegate: DDPlayerDelegate?
    
    var statusDidChangeHandler: ((Status) -> Void)?
    var currentItem: AVPlayerItem?
    var duration: TimeInterval = 0
    var currentTime: TimeInterval = 0 {
        didSet {
            self.delegate?.playerTimeChanged(currentTime)
        }
    }
    var status = Status.unknown {
        didSet {
            guard status != oldValue else {
                return
            }
            statusDidChangeHandler?(status)
        }
    }
    
    private let player = AVPlayer()
    private var observerContext = "DDPlayer.KVO.Context"
    private var timeObserver: Any?

    deinit {
        removeNotifications()
        removeItemObservers()
        removePlayerObservers()
    }
    
    override init() {
        super.init()
        addNotifications()
        addPlayerObservers()
    }
}

// MARK: - public method
extension DDPlayer {
    @objc func replace(with url: URL) {
        currentItem = AVPlayerItem(url: url)
        addItemObservers()
        player.replaceCurrentItem(with: currentItem)
    }
    func stop() {
        removeItemObservers()
        currentItem = nil
        player.replaceCurrentItem(with: nil)
        
        status = .unknown
    }
    @objc func play() {
        player.play()
    }
    func pause() {
        player.pause()
    }
    func seek(to time: TimeInterval) {
        player.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    func bind(to playerLayer: AVPlayerLayer) {
        playerLayer.player = player
    }
}

// MARK: - private method
extension DDPlayer {
    private func updateStatus() {
        DispatchQueue.main.async {
            guard let currentItem = self.currentItem else {
                return
            }
            if self.player.error != nil || currentItem.error != nil {
                self.status = .error
                
                return
            }
            if #available(iOS 10, *) {
                switch self.player.timeControlStatus {
                case .playing:
                    self.status = .playing
                case .paused:
                    self.status = .paused
                case .waitingToPlayAtSpecifiedRate:
                    self.status = .buffering
                }
            } else {
                if self.player.rate != 0 {
                    if currentItem.isPlaybackLikelyToKeepUp {
                        self.status = .playing
                    } else {
                        self.status = .buffering
                    }
                } else {
                    self.status = .paused
                }
            }
        }
    }
}

// MARK: - notification
extension DDPlayer {
    /// 添加通知
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    /// 移除通知
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: 接收通知
    /// 收到playItem播放完毕的通知
    ///
    /// - Parameter notification: Notification
    @objc private func playerItemDidPlayToEndTime(_ notification: Notification) {
        guard (notification.object as? AVPlayerItem) == self.currentItem && self.currentItem != nil else {
            return
        }
        status = .end
    }
    
}
// MARK: - kvo
extension DDPlayer {
    private func addPlayerObservers() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [unowned self] (time) in
            self.updateStatus()
            
            guard let total = self.currentItem?.duration.seconds else {
                return
            }
            if total.isNaN || total.isZero {
                return
            }
            self.duration = total
            self.currentTime = time.seconds
        })
        player.addObserver(self, forKeyPath: "rate", options: [.new], context: &observerContext)
        player.addObserver(self, forKeyPath: "status", options: [.new], context: &observerContext)
        if #available(iOS 10, *) {
            player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: &observerContext)
        }
    }
    private func addItemObservers() {
        currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: &observerContext)
        currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: &observerContext)
        currentItem?.addObserver(self, forKeyPath: "isPlaybackBufferEmpty", options: .new, context: &observerContext)
        currentItem?.addObserver(self, forKeyPath: "isPlaybackBufferFull", options: .new, context: &observerContext)
    }
    private func removePlayerObservers() {
        guard let timeObserver = timeObserver else {
            return
        }
        player.removeTimeObserver(timeObserver)
        player.removeObserver(self, forKeyPath: "rate", context: &observerContext)
        player.removeObserver(self, forKeyPath: "status", context: &observerContext)
        if #available(iOS 10, *) {
            player.removeObserver(self, forKeyPath: "timeControlStatus", context: &observerContext)
        }
    }
    private func removeItemObservers() {
        currentItem?.removeObserver(self, forKeyPath: "status")
        currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        currentItem?.removeObserver(self, forKeyPath: "isPlaybackBufferEmpty")
        currentItem?.removeObserver(self, forKeyPath: "isPlaybackBufferFull")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        updateStatus()
    }
}
