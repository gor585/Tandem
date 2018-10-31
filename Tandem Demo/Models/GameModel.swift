//
//  GameModel.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 30.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

class Game {
    var competition: String
    var homeTeam: String
    var awayTeam: String
    var scoreHome: String
    var scoreAway: String
    var date: String
    var selected: Bool
    
    init(competition: String, homeTeam: String, awayTeam: String, scoreHome: String = "-", scoreAway: String = "-", date: String) {
        self.competition = competition
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.scoreHome = scoreHome
        self.scoreAway = scoreAway
        self.date = date
        self.selected = false
    }
}
