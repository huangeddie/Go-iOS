//
//  GameViewController.swift
//  GO
//
//  Created by Eddie Huang on 7/29/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var dimension: Int = 19
    
    @IBOutlet weak var board: BoardView!
    
    var game: Game<GOBoard> = Game(dimension: 19)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        board.delegate = self
        board.dimension = dimension
    }
    
    func update() -> Void {
        board.update(game.board)
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

extension GameViewController: BoardDelegate {
    func attemptedToMakeMove(_ point: Point) {
        do {
            try game.makeMove(point)
            update()
        } catch {
            print(error)
        }
    }
}
