//
//  ViewController.swift
//  PDFLibrary
//
//  Created by Perennial Macbook on 10/10/22.
//

import UIKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: PDFViewModelProtocol = PDFViewModel.init()
    var tag: Int = -1
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Programming PDF's"
        setupView()
    }
    
    // MARK: - functions
    func setupView(){
        viewModel.navigationDelegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func registerNib() {
        collectionView?.register(UINib(nibName: "PDFCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PDFCollectionViewCell")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PDFViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PDFCellDelegate {
    
    func performPDFDownloadAction(_ tag: Int) {
        self.tag = tag
        let data = viewModel.getFileStatus(index: tag)
        if data.status, let url = data.fileUrl  {
            print("Open \(url)")
            performNavigation(url: url)
        } else {
            let data = viewModel.pdfList[tag]
            guard let url = data.url else {return}
            guard let url = URL(string: url) else{return}
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
        }
    }
    
    func performNavigation(url: URL){
        DispatchQueue.main.async {
            let pdfViewController = PDFVIewerViewController()
            pdfViewController.pdfURL = url
            self.navigationController?.pushViewController(pdfViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pdfList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDFCollectionViewCell", for: indexPath) as? PDFCollectionViewCell {
            cell.configureCell(data: viewModel.getPdfModel(index: indexPath.row))
            cell.delegate = self
            cell.btnDownlaodPDF.tag = indexPath.row
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width/2 - 20)
        let height = 300.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension PDFViewController:  URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            viewModel.updateFileStatus(index: self.tag, destinationURL: destinationURL)
            print("Download \(destinationURL)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
            guard let cell = self.collectionView.cellForItem(at: IndexPath.init(row: self.tag, section: 0)) as? PDFCollectionViewCell else {return}
            cell.percLabel.text = "\(Int(percentage * 100))%"
            cell.progressBar.setProgress(percentage, animated: true)
        }
    }
}

extension PDFViewController : PDFViewModelNavigationDelegate {
    func refreshUI() {
        self.collectionView.reloadData()
    }
}
