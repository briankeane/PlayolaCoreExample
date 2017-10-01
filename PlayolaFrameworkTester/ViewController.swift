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

    @IBOutlet weak var playStopImageButton: AutoUpdatingPlayButtonWithImage!

    
    @IBOutlet weak var albumArtworkImageView: UIImageView!
    @IBOutlet weak var autoPlayStopButton: AutoUpdatingPlayButtonWithText!
    
    var player:PlayolaStationPlayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.player = PlayolaStationPlayer.sharedInstance()
        PlayolaAPI.sharedInstance().setBaseURL(baseURL: "https://api.playola.fm")
        self.autoPlayStopButton.userID = "553ececb7be2cd0011669706"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}



