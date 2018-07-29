//
//  BoardMenuViewController.swift
//  GO
//
//  Created by Eddie Huang on 7/29/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class BoardMenuViewController: UIViewController {

    @IBOutlet weak var dimensionPicker: UIPickerView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimensionPicker.delegate = self
        dimensionPicker.dataSource = self

        // Do any additional setup after loading the view.
        dimensionPicker.selectRow(18, inComponent: 0, animated: false)
    }
    
    @IBAction func go(_ sender: Any) {
        let dimension = dimensionPicker.selectedRow(inComponent: 0) + 4
        
        guard let gameVC = presentingViewController as? GameViewController else {
            fatalError()
        }
        
        gameVC.game.startGame(dimension: dimension)
        gameVC.update()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BoardMenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 4)"
    }
    
}
