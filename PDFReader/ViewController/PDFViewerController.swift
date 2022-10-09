//
//  PDFViewController.swift
//  PDFReader
//
//  Created by Perennial Macbook on 06/10/22.
//

import UIKit
import PDFKit

class PDFViewerController: UIViewController {
    
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
        let width = self.view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        self.view.addSubview(navigationBar);
        let navigationItem = UINavigationItem(title: "Navigation bar")
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: nil, action: #selector(selectorX))
        navigationItem.rightBarButtonItem = doneBtn
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc func selectorX() {
        let pdfFilePath = self.pdfURL
        let pdfData = NSData(contentsOf: pdfFilePath!)
        let activityVC = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
