//
//  AddOrderModule.swift
//  CafeManagerTests
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import XCTest
@testable import CafeManager

class AddOrderModule: XCTestCase {
    
//    func testExample() {
//        let addOrder = AddOrderAssembly.assembleModule()
//        let interactor = addOrder.presenter.interactor
//        let presenter = addOrder.presenter
//
//        presenter!.data = interactor!.getMenuItems()
//        presenter!.getFilteredData(forKey: "Beer")
//
//    }
    
    func test1() {
        let countOfLines = 250
        for i in 0 ..< countOfLines {
            var variable = 0
            let test = modf(Double(i)/2).1

            if test == 0 {
                variable += i+3
            } else {
                variable += i+1
            }
            let color = UIColor(red: CGFloat(variable)/255, green: CGFloat(variable)/255, blue: CGFloat(variable)/255, alpha: 1)
            
        }
    }
    
    
}
