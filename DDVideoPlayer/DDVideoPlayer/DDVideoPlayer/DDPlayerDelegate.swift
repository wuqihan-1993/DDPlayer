//
//  DDPlayerDelegate.swift
//  DDVideoPlayer
//
//  Created by wuqh on 2018/11/8.
//  Copyright © 2018 wuqh. All rights reserved.
//

import Foundation

protocol DDPlayerDelegate: AnyObject {
    func playerTimeChanged(_ currentTime: TimeInterval)
}
