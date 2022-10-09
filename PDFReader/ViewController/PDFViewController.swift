//
//  ViewController.swift
//  PDFReader
//
//  Created by Perennial Macbook on 06/10/22.
//

import UIKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var tag: Int = -1
    
    var viewModel: PDFViewModel = PDFViewModel()
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        viewModel.getPDFList()
        tableView.delegate = self
        tableView.dataSource = self
        registerNIB()
    }
    
    func registerNIB(){
        tableView.register(UINib(nibName : "PDFTableViewCell", bundle : Bundle.main), forCellReuseIdentifier: "PDFTableViewCell")
    }
    
}

extension PDFViewController: UITableViewDelegate, UITableViewDataSource, PDFCellDelegate {
    
    func performSharePDFAction(_ tag: Int) {
        self.tag = tag
        let data = viewModel.pdfList[tag]
        guard let url = data.url else {return}
        let pdfFilePath = URL(string: url)
        let pdfData = NSData(contentsOf: pdfFilePath!)
        let activityVC = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        
    }
    
    func didPdfActionClick(_ tag: Int) {
        self.tag = tag
        let data = viewModel.pdfList[tag]
        guard let url = data.url else {return}
        guard let url = URL(string: url) else{return}
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pdfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PDFTableViewCell", for: indexPath) as? PDFTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.pdfList[indexPath.row]
        cell.configureCell(data: data)
        cell.delegate = self
        cell.pdfActionButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
    func performNavigation(url: URL){
        DispatchQueue.main.async {
            let pdfViewController = PDFViewerController()
            pdfViewController.pdfURL = url
            self.navigationController?.pushViewController(pdfViewController, animated: true)
        }
    }
}

extension PDFViewController:  URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("DownloadCompleted"), object: nil,userInfo: ["TAG" : self.tag])
            }
            performNavigation(url: destinationURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let written = byteFormatter.string(fromByteCount: totalBytesWritten)
        let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
        print("Downloaded \(written) / \(expected)")
        let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("percentDownloaded \(percentage * 100)%")
        
        DispatchQueue.main.async {
            guard let cell = self.tableView.cellForRow(at: IndexPath.init(row: self.tag, section: 0)) as? PDFTableViewCell else {
                return
            }
            cell.percLabel.text = "\(Int(percentage * 100))%"
            cell.progressBar.setProgress(percentage, animated: true)
        }
    }
}

extension PDFViewController: PDFViewModelNavigationDelegate {
    func refreshUI() {
        tableView.reloadData()
    }
}



