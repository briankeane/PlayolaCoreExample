//
//  ViewController.swift
//  PlayolaFrameworkTester
//
//  Created by Brian D Keane on 8/16/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import PlayolaCore

class ViewController: UIViewController {

    @IBOutlet weak var playStopButton: UIButton!
    
    var player:PlayolaStationPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupListeners()
        self.player = PlayolaStationPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any)
    {
        if (self.playStopButton.titleLabel?.text == "Play")
        {
            player.loadUserAndPlay(userID: "59508b2eac42570400cdb67d")
                .then { (void) -> Void in
                    print("starting!")
                }.catch { (error) -> Void in
                    print("there was an error starting your station.")
                    print(error)
                }
        }
        else
        {
            player.stop()
        }
    }
    
    func setupListeners()
    {
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.loadingStationProgress, object: nil, queue: .main)
        {
            (notification) -> Void in
            if let userInfo = notification.userInfo {
                if let downloadProgress = userInfo["downloadProgress"] as? Double {
                    DispatchQueue.main.async
                    {
                        self.playStopButton.setTitle("\(Double(round(downloadProgress*100)*100/100))% complete", for: .normal)
                    }
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.finishedLoadingStation, object: nil, queue: .main)
        {
            (notification) -> Void in
            DispatchQueue.main.async
            {
                self.playStopButton.setTitle("Stop", for: .normal)
            }
        }
        
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.stoppedPlayingStation, object: nil, queue: .main)
        {
            (notification) -> Void in
            DispatchQueue.main.async
            {
                self.playStopButton.setTitle("Play", for: .normal)
            }
        }
    }
}

