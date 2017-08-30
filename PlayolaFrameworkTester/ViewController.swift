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
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var albumArtworkImageView: UIImageView!
    
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
            player.loadUserAndPlay(userID: "553ececb7be2cd0011669706")
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
        // Respond to Station Loading Progress
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.loadingStationProgress, object: nil, queue: .main)
        {
            (notification) -> Void in
            if let userInfo = notification.userInfo {
                if let downloadProgress = userInfo["downloadProgress"] as? Double {
                    DispatchQueue.main.async
                    {
                        self.stationLabel.text = "Loading: \(Double(round(downloadProgress*100)*100/100))% complete"
                    }
                }
            }
        }
        
        // Respond to "Finished Loading"
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.startedPlayingStation , object: nil, queue: .main)
        {
            (notification) -> Void in
            DispatchQueue.main.async
            {
                self.playStopButton.setTitle("Stop", for: .normal)
                self.stationLabel.text = "Station: "
            }
        }
        
        // Respond to "Stopped Playing"
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.stoppedPlayingStation, object: nil, queue: .main)
        {
            (notification) -> Void in
            DispatchQueue.main.async
            {
                self.playStopButton.setTitle("Play", for: .normal)
            }
        }
        
        // Respond to "NowPlaying Changed"
        NotificationCenter.default.addObserver(forName: PlayolaStationPlayerEvents.nowPlayingChanged, object: nil, queue: .main)
        {
            (notification) -> Void in
            if let userInfo = notification.userInfo
            {
                var nowPlayingLabelString = ""
                var stationNameString = ""
                
                if let audioBlockInfo = userInfo["audioBlockInfo"] as? [String:Any]
                {
                    if let title = audioBlockInfo["title"] as? String
                    {
                        nowPlayingLabelString += "\(title)"
                    }
                    if let artist = audioBlockInfo["artist"] as? String
                    {
                        nowPlayingLabelString += " / \(artist)"
                    }
                    if let albumArtworkURL = audioBlockInfo["albumArtworkUrl"] as? URL
                    {
                        self.setAlbumImage(url: albumArtworkURL)
                    }
                }
                
                if let stationName = self.player.userPlaying?.displayName
                {
                    stationNameString = "Station: \(stationName)"
                }
                
                
                
                DispatchQueue.main.async
                {
                    self.stationLabel.text = stationNameString
                    self.nowPlayingLabel.text = nowPlayingLabelString
                }
            }
        }
    }
    // taken from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    func setAlbumImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.albumArtworkImageView.image = UIImage(data: data)
            }
        }
    }
}

// taken from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        completion(data, response, error)
        }.resume()
}



