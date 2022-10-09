//
//  PFViewMoel.swift
//  PDFReader
//
//  Created by Perennial Macbook on 06/10/22.
//

import Foundation


protocol PDFViewModelNavigationDelegate {
    func refreshUI()
}

protocol PDFViewModelProtocol {
    var navigationDelegate: PDFViewModelNavigationDelegate? {get set}
    var pdfList: [PDFModel] {get set}
}

class PDFViewModel: PDFViewModelProtocol {
    
    var navigationDelegate: PDFViewModelNavigationDelegate?
    var pdfList: [PDFModel] = [PDFModel]()
    
    func getPDFList() {
        let data = PDFData.getPDFList()
        self.pdfList.removeAll()
        self.pdfList.append(contentsOf: data)
        self.navigationDelegate?.refreshUI()
    }
    
}
