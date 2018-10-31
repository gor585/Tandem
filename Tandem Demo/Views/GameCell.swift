//
//  GameCell.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 30.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreSeparatorLabel: UILabel!
    
    var game: Game?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setGame(game: Game) {
        self.game = game
        homeTeamLabel.text = game.homeTeam
        awayTeamLabel.text = game.awayTeam
        homeScoreLabel.text = game.scoreHome
        awayScoreLabel.text = game.scoreAway
        dateLabel.text = game.date
    }
}
