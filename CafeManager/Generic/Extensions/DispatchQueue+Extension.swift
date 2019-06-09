//
//  DispatchQueue+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func GetCurrentQueueName() -> String? {
        let name = __dispatch_queue_get_label(nil)
        return String(cString: name, encoding: .utf8)
    }
}
