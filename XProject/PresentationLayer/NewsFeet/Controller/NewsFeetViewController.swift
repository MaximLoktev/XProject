//
//  NewsFeetViewController.swift
//  XProject
//
//  Created by Максим Локтев on 02.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AVFoundation
import UIKit

internal protocol NewsFeetModuleOutput: class {

}

internal protocol NewsFeetModuleInput: class {

}

internal class NewsFeetViewController: UIViewController, NewsFeetModuleInput, NewsFeetViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: NewsFeetModuleOutput?

    var moduleView: NewsFeetView!
    
    // MARK: - View life cycle

    override func loadView() {
        moduleView = NewsFeetView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer()
    }
    
    private func audioPlayer() {
        
        do {
            if let audioPath = Bundle.main.path(forResource: "anal", ofType: ".mp3") {
                try moduleView.player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            }
        } catch {
            
        }
    }

    // MARK: - NewsFeetViewDelegate
    
}
