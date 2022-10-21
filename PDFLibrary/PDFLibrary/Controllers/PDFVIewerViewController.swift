//
//  PDFVIewerViewController.swift
//  PDFLibrary
//
//  Created by Perennial Macbook on 10/10/22.
//

import UIKit
import PDFKit

class PDFVIewerViewController: UIViewController {
    
    var pdfView = PDFView()
    var pdfURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.dismiss(animated: true, completion: nil)
            self.pdfView.maxScaleFactor = 3;
            self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit;
            self.pdfView.autoScales = true;
            self.pdfView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    override func viewDidLayoutSubviews() {
        pdfView.frame = view.bounds
    }
}
