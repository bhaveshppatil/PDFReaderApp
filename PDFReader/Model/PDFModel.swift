//
//  PDFModel.swift
//  PDFReader
//
//  Created by Perennial Macbook on 06/10/22.
//

import Foundation

struct PDFModel {
    let title: String?
    let url: String?
    let image: String?
}

class PDFData {
    static func getPDFList() -> [PDFModel] {
        let data = [
            PDFModel(title: "Java: Java Programming For Beginners", url: "https://www.iitk.ac.in/esc101/share/downloads/javanotes5.pdf", image: "java_beginner"),
            PDFModel(title: "EXCEL VBA Step-by-Step Guide To Learning Excel Programming Language", url: "https://www.automateexcel.com/blockedfolder/VBA-Tutorial.pdf", image: "excel"),
            PDFModel(title: "Introduction to Software Development", url: "https://www.pearsonhighered.com/assets/samplechapter/0/1/3/0/0130091154.pdf", image: "software_developement"),
            PDFModel(title: "Java for Absolute Beginners: Learn to Program", url: "https://www.cs.usfca.edu/~parrt/doc/java/JavaBasics-notes.pdf", image: "javaCoding"),
            PDFModel(title: "Web Design with HTML and CSS", url: "http://mpbou.edu.in/slm/webdeenglish.pdf", image: "web_design"),
            PDFModel(title: "Programming Bitcoin: Learn How to Program Bitcoin from Scratch", url: "https://kkarasavvas.com/assets/bitcoin-textbook.pdf", image: "bitcoin"),
            PDFModel(title: "Cracking the Coding Interview, Fourth Edition: 150 Programming", url: "https://www.byte-by-byte.com/wp-content/uploads/2019/01/50-Coding-Interview-Questions.pdf", image: "coding_interviews"),
            PDFModel(title: "Android Programming Tutorials", url: "https://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf", image: "android"),
            PDFModel(title: "Python Programming for the Absolute Beginner", url: "https://www.halvorsen.blog/documents/programming/python/resources/Python%20Programming.pdf", image: "python")
            ]
        return data
    }
}

