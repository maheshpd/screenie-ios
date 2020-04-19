//
//  ViewController.swift
//  screenie
//
//  Created by Mahesh Prasad on 19/04/20.
//  Copyright © 2020 CreatesApp. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController, RPPreviewViewControllerDelegate {

    //MARK: Outlet
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var imagePicker: UISegmentedControl!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var micToggle: UISwitch!
    @IBOutlet weak var recordBtn: UIButton!
    
    var recorder = RPScreenRecorder.shared()
    private var isRecording = false
    
    @IBAction func imagePicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedImageView.image = UIImage(named: "skate")!
        case 1:
            selectedImageView.image = UIImage(named: "food")!
        case 2:
            selectedImageView.image = UIImage(named: "cat")!
        case 3:
            selectedImageView.image = UIImage(named: "nature")!
        default:
            selectedImageView.image = UIImage(named: "skate")!
        }
    }
    
    @IBAction func recordBtnWasPressed(_ sender: UIButton) {
        if !isRecording {
            startRecording()
        } else {
//            stopRecording()
        }
    }
    
    func startRecording() {
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
            
        }
        if micToggle.isOn {
            recorder.isMicrophoneEnabled = true
        } else {
            recorder.isMicrophoneEnabled = false
        }
        
        recorder.startRecording { (error) in
            guard error == nil else {
                print("There was an error starting the recording.")
                return
            }
            
            print("STARTED RECORDING SUCCESSFULLY")
            DispatchQueue.main.async {
                self.micToggle.isEnabled = false
                self.recordBtn.setTitleColor(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), for: .normal)
                self.recordBtn.setTitle("Stop", for: .normal)
                self.statusLbl.text = "Recording..."
                self.statusLbl.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.isRecording = true
            }
            
        }
        
    }
    
    func stopRecording() {
        recorder.stopRecording { (preview, error) in
            guard preview != nil else {
                print("Preview controller is not available.")
                return
            }
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.recorder.discardRecording {
                    print("Recording successfully deleted!")
                }
            }
            
            let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            }
            
            alert.addAction(deleteAction)
            alert.addAction(editAction)
            self.present(alert, animated: true, completion: nil)
           
            self.isRecording = false
            self.viewReset()
        }
    }
    
    func viewReset() {
        micToggle.isEnabled = true
        statusLbl.text = "Ready to Record"
        statusLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        recordBtn.setTitle("Record", for: .normal)
        recordBtn.setTitleColor(#colorLiteral(red: 0.851465404, green: 0.4157265425, blue: 0.3035841882, alpha: 1), for: .normal)
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

