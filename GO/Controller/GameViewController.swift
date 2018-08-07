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
    @IBOutlet weak var turnIndicator: TurnView!
    
    var game: Game<GOBoard> = Game(dimension: 19)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        board.delegate = self
        board.dimension = dimension
        
        update()
    }
    
    @IBAction func undo(_ sender: Any) {
        game.undo()
        update()
    }
    
    @IBAction func pass(_ sender: Any) {
        game.pass()
        update()
    }
    
    
    @IBAction func newGame(_ sender: Any) {
        game.reset()
        update()
    }
    
    
    func update() -> Void {
        board.update(game.board)
        turnIndicator.turn = game.board.turn
        turnIndicator.gameEnded = game.board.gameEnded
        turnIndicator.setNeedsDisplay()
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
