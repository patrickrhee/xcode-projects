//
//  ViewController.swift
//  Test Ship Game
//
//  Created by Patrick Rhee on 12/25/19.
//  Copyright © 2019 Rhee Family. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // Link to the game objects
    @IBOutlet var motherShip: UIImageView!
    @IBOutlet var playerShip: UIImageView!
    @IBOutlet var enemyShip: UIImageView!
    @IBOutlet var missile: UIImageView!
    
    // Score and lives label
    @IBOutlet var livesLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var gameOverLabel: UILabel!
    
    // Start button
    @IBOutlet var startButton: UIButton!
    
    var touch: UITouch!
    var livesString: String!
    var scoreString: String!
    
    var enemyMovementTimer: Timer?
    var missileMovementTimer: Timer?
    var functionTimer: Timer?
    
    // When the start button is poked, start the game function
   
    
    var score = 0;
    var lives = 3;
    var enemyAttackOccurance: Double!
    var enemyPosition: Int!
    var randomSpeed: Int!
    var enemySpeed: Double!
    var enemyJumpGap: CGFloat!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Hide game except start button
        playerShip.isHidden = true;
        motherShip.isHidden = true;
        enemyShip.isHidden = true;
        missile.isHidden = true;
        
        livesLabel.isHidden = true;
        scoreLabel.isHidden = true;
        gameOverLabel.isHidden = true;
        
        // set lives and score
        livesString = String(format: "%@%x", "Lives = ", lives);
        scoreString = String(format: "%@%d", "Score = ", score);
        
        livesLabel.text = livesString;
        scoreLabel.text = scoreString;
        
        let w = UIScreen.main.bounds.width;
        // Set starting positions of sprites
        playerShip.center = CGPoint(x: w/2,y: 680);
        enemyShip.center = CGPoint(x:w/2, y:120);
        missile.center = playerShip.center;
        
        
    }
    
    @IBAction func startGame()
    {
        print("Starting game")
        if(missileMovementTimer != nil){missileMovementTimer?.invalidate()};
        if(enemyMovementTimer != nil){enemyMovementTimer?.invalidate()};
        enemyJumpGap = 6;
        // Hide start button
        startButton.isHidden = true;
        
        // Show game screen
        playerShip.isHidden = false;
        motherShip.isHidden = false;
        enemyShip.isHidden = false;
        
        livesLabel.isHidden = false;
        scoreLabel.isHidden = false;
        
        self.positionEnemy();
        print("Starting game");
        
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }*/
    
    @objc override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(startButton.isHidden == true && gameOverLabel.isHidden == true)
        {
            let touch = touches.first;
            let point = touch?.location(in: self.view);
            playerShip.center = CGPoint(x:point?.x ?? playerShip.center.x, y:playerShip.center.y);
                
        }
    }
    
    @objc override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch ended");
        
        if(startButton.isHidden == true && gameOverLabel.isHidden == true)
        {
            if(missileMovementTimer != nil){missileMovementTimer?.invalidate()};
            missile.isHidden = false;
            missile.center = CGPoint(x: playerShip.center.x, y: playerShip.center.y);
            missileMovementTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(missileMovement), userInfo: nil, repeats: true)
        }
    }
    
    @objc func positionEnemy()
    {
        if(startButton.isHidden == true && gameOverLabel.isHidden == true)
        {
            print("Positioning enemy");
            // make random enemy position
            enemyPosition = Int.random(in:0..<249);
            enemyPosition += 20;
            
            // set enemy spawning position
            enemyShip.center = CGPoint(x:enemyPosition, y: -40);
            
            // set enemy speed
            randomSpeed = Int.random(in:0..<3);
            
            switch(randomSpeed)
            {
            case(0):
                enemySpeed = 0.01;
                break;
                
            case(1):
                enemySpeed = 0.01;
                break;
                
            case(2):
                enemySpeed = 0.01;
                break;
                
            default:
                break;
            }
            
            enemyAttackOccurance = Double.random(in: 0..<2);
        
            functionTimer = Timer.scheduledTimer(timeInterval: enemyAttackOccurance, target: self, selector: #selector(enemyMovementTimerMethod), userInfo: nil, repeats: false)
        }
    }
    
    @objc func enemyMovementTimerMethod()
    {
        print("Calling enemyMovement func");
        enemyMovementTimer = Timer.scheduledTimer(timeInterval: enemySpeed, target: self, selector: #selector(enemyMovement), userInfo: nil, repeats: true);
    }
    
    @objc func enemyMovement()
    {
        if(startButton.isHidden == true && gameOverLabel.isHidden == true)
        {
            enemyShip.center = CGPoint(x: enemyShip.center.x, y: enemyShip.center.y + enemyJumpGap);
            
            // if enemy ship hits the mother ship
            if(enemyShip.frame.intersects(motherShip.frame))
            {
                // we lose a live
                lives = lives-1;
                livesString = String(format: "%@%d", "Lives = ", lives);
                livesLabel.text = livesString;
                
                // stop moving enemy
                enemyMovementTimer?.invalidate();
                if (lives>0){self.positionEnemy();}
                else{print("Going to gameOver func");
                    self.gameOver();}
            }
        }else{
            if(enemyMovementTimer != nil)
            {
                enemyMovementTimer?.invalidate();
                enemyMovementTimer = nil;
            }
        }
    }
    
    @objc func missileMovement()
    {
        // missile moves upwards
        missile.isHidden = false;
        missile.center = CGPoint(x: missile.center.x, y: missile.center.y-8);
        
        // if the missile hits the enemy
        if(missile.frame.intersects(enemyShip.frame))
        {
            score += 5;
            if(score%15==0){
                enemyJumpGap += 1;
                
            }
            scoreString = String(format: "%@%d", "Score = ", score);
            scoreLabel.text = scoreString;
            
            // stop missile
            missileMovementTimer?.invalidate();
            
            // hide missile
            missile.isHidden = true;
            missile.center = playerShip.center;
            
            // stop enemy ship
            if(enemyMovementTimer != nil){enemyMovementTimer?.invalidate()};
            self.positionEnemy();
        }
        
    }
    
    @objc func gameOver()
    {
        lives = 3;
        score = 0;
        if(missileMovementTimer != nil){missileMovementTimer?.invalidate();}
        print("game over");
        gameOverLabel.isHidden = false;
        
         functionTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(replayGame), userInfo: nil, repeats: false);
    }
    
    @objc func replayGame()
    {
        enemyJumpGap = 2;
        
        // Hide game except start button
        playerShip.isHidden = true;
        motherShip.isHidden = true;
        enemyShip.isHidden = true;
        missile.isHidden = true;
        
        livesLabel.isHidden = true;
        scoreLabel.isHidden = true;
        print("Remove game over");
        gameOverLabel.isHidden = true;
        
        // set lives and score
        livesString = String(format: "%@%x", "Lives = ", lives);
        scoreString = String(format: "%@%d", "Score = ", score);
        
        livesLabel.text = livesString;
        scoreLabel.text = scoreString;
        
        let w = UIScreen.main.bounds.width;
        // Set starting positions of sprites
        playerShip.center = CGPoint(x: w/2,y: 680);
        enemyShip.center = CGPoint(x:w/2, y:120);
        missile.center = playerShip.center;
        startButton.isHidden = false;
    }
}
