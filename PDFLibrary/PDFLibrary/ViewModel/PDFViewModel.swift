//
//  PDFViewModel.swift
//  PDFLibrary
//
//  Created by Perennial Macbook on 10/10/22.
//

import Foundation

protocol PDFViewModelNavigationDelegate {
    func refreshUI()
}

protocol PDFViewModelProtocol {
    var navigationDelegate: PDFViewModelNavigationDelegate? {get set}
    var pdfList: [PDFModel] {get set}
    func updateFileStatus(index:Int, destinationURL: URL)
    func getPdfModel(index: Int) -> PDFModel
    func getFileStatus(index: Int) -> (status:Bool, fileUrl:URL?)
}

class PDFViewModel: PDFViewModelProtocol {

    var navigationDelegate: PDFViewModelNavigationDelegate?
    var pdfList: [PDFModel] = [PDFModel]()
    let defaults = UserDefaults.standard
    
    init() {
        getPDFList()
    }
    
    func getPDFList() {
        let data = PDFData.getPDFList()
        self.pdfList.removeAll()
        self.pdfList.append(contentsOf: data)
        self.navigationDelegate?.refreshUI()
    }
    
    func updateFileStatus(index:Int, destinationURL: URL) {
        defaults.set(true, forKey: "\(pdfList[index].title ?? "")flag")
        defaults.set(destinationURL.absoluteString, forKey: "\(pdfList[index].url ?? "")URL")
        print(" absoluteURL \(destinationURL.absoluteURL)")
    }
    
    func getFileStatus(index: Int) -> (status:Bool, fileUrl:URL?) {
        guard let flag = defaults.object(forKey: "\(pdfList[index].title ?? "")flag") as? Bool, let destUrl = defaults.object(forKey: "\(pdfList[index].url ?? "")URL") as? String,  let url = URL(string: destUrl) else{
            return (false, nil)
        }
        return (flag, url)
    }
    
    func getPdfModel(index: Int) -> PDFModel {
        var pdfModel = self.pdfList[index]
        guard let flag = defaults.object(forKey: "\(pdfList[index].title ?? "")flag") as? Bool else{
            return pdfModel
        }
        if flag {
            pdfModel.buttonTitle = "Open"
        }
        return pdfModel
    }
    
    
}
