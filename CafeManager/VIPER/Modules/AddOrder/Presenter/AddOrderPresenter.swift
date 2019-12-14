//
//  AddOrderPresenter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class AddOrderPresenter: NSObject, AddOrderPresenterInterface {
    
    var router: AddOrderRouterInterface!
    var interactor: AddOrderInteractorInterface!
    weak var view: AddOrderViewControllerInterface!
    
    var isSearchActive: Bool = false
    
    var data = [String : [[String : String]]]()
    var sections: [String] {
        return Array(data.keys).sorted()
    }
    
    // Incoming
    func configureView() {
        // Prepare data for TableView
        getData()
        view?.tableView.reloadData()
    }
    
    // Functions for TableView
    func getData() {
        data = interactor.getMenuItems(withText: nil)
    }
    
    func getFilteredData (forSearchText key: String) {
        data = interactor.getMenuItems(withText: key)
    }
    
    func getNumberOfRowsInSection (withNumber section: Int) -> Int {
        let sectionTitle = sections[section]
        let sectionData = data[sectionTitle]
        let numberOfRowsInSection = sectionData!.count
        return numberOfRowsInSection
    }
    
    func getTitleForHeaderInSection (withNumber section: Int) -> String? {
        let sectionTitle = sections[section]
        return sectionTitle
    }
    
    func getRowData (forSectionIndex section: Int, andRowIndex rowIndex: Int) -> (name: String?, description: String?, price: String?) {
        let sectionName = sections[section]
        let rowData = data[sectionName]![rowIndex]
        let name = rowData["name"]
        let description = rowData["description"]
        var price = rowData["price"]
        price = price! + UserSettings.currencySymbol
        return (name, description, price)
    }


    // Outgoing
    func didChoose (itemName name: String, withDescription description: String) {
        interactor.getMenuItem(withName: name)
        router.didChooseMenuItem()
    }
    

}
