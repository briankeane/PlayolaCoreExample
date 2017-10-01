//
//  AudioPlotViewController.swift
//  PlayolaFrameworkTester
//
//  Created by Brian D Keane on 9/29/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import AudioKit
import PlayolaCore

class AudioPlotViewController: UIViewController {

    @IBOutlet weak var plot: AKNodeOutputPlot!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plot.node = PlayolaStationPlayer.sharedInstance().getOutputNode()
        self.plot.plotType = .rolling
        self.plot.shouldFill = true
        self.plot.shouldMirror = true
        self.plot.color = UIColor(red: 0.980, green: 0.475, blue: 0.459, alpha: 1.00)
        self.plot.gain = 1.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
