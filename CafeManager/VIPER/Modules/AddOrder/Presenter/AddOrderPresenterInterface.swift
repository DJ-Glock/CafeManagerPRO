//
//  AddOrderPresenterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol AddOrderPresenterInterface: class {
    var data: [String : [[String : String]]] {get set}
    
    /// Method configures view
    func configureView()
    
    /// Method gets data from interactor and assigns to "data" variable
    func getData()
    
    /// Method gets filtered data for search key and assigns to "data" variable. It uses contains condition in the database
    func getFilteredData (forSearchText key: String)
    
    /// Method returns tuple with data for cell
    func getRowData (forSectionIndex section: Int, andRowIndex rowIndex: Int) -> (name: String?, description: String?, price: String?)
    
    /// Method returns number of rows for given section
    func getNumberOfRowsInSection (withNumber section: Int) -> Int
    
    /// Method returns title for given section
    func getTitleForHeaderInSection (withNumber section: Int) -> String?
    
    /// Method get called when menu item is chosen. It gets data from interactor and calls respective method in router
    func didChoose (itemName name: String, withDescription description: String)

}
