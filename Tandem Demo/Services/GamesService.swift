//
//  GamesService.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 30.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

class GamesService {
    static let shared = GamesService()
    let footballAPIToken = "b3a5072485714a2f9c58b9945ad4dcad"
    let footballLeaguesArray = ["PL", "BL1", "SA", "PD"]
    
    //MARK: - Games Loading
    func getScores(completion: @escaping (_ scoreDict: [String: [Game]]?) -> Void) {
        var scoresArray = [Game]()
        var scoresDict = [String: [Game]]()
        
        for league in footballLeaguesArray {
            let baseURLString = "https://api.football-data.org/v2/competitions/\(league)/matches?dateFrom=\(DateConverter.shared.lastTwoWeeksDateString)&dateTo=\(DateConverter.shared.currentDateString)"
            guard let url = URL(string: baseURLString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(footballAPIToken, forHTTPHeaderField: "X-Auth-Token")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let data = data else { return }
                        self.gameParsing(data: data, completion: { (game) in
                            guard let newGame = game else { return }
                            //Getting an array of scores from all leagues
                            scoresArray.append(newGame)
                            //Sorting scores array by league name (competition)
                            scoresDict.updateValue(scoresArray.filter { $0.competition == league }, forKey: league)
                            completion(scoresDict)
                        })
                    } else {
                        print("\(league) scores loading RESPONSE: \(response.statusCode)")
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }.resume()
        }
    }
    
    func getUpcomingGames(completion: @escaping (_ matchesDict: [String: [Game]]?) -> Void) {
        var upcomingMatchesArray = [Game]()
        var upcomingMatchesDict = [String: [Game]]()
        
        for league in footballLeaguesArray {
            let baseURLString = "https://api.football-data.org/v2/competitions/\(league)/matches?dateFrom=\(DateConverter.shared.currentDateString)&dateTo=\(DateConverter.shared.nextTwoWeeksDateString)"
            guard let url = URL(string: baseURLString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(footballAPIToken, forHTTPHeaderField: "X-Auth-Token")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let data = data else { return }
                        self.gameParsing(data: data, completion: { (game) in
                            guard let newGame = game else { return }
                            //Getting an array of games from all leagues
                            upcomingMatchesArray.append(newGame)
                            //Sorting games array by league name (competition)
                            upcomingMatchesDict.updateValue(upcomingMatchesArray.filter { $0.competition == league }, forKey: league)
                            completion(upcomingMatchesDict)
                        })
                    } else {
                        print("\(league) Upcoming games loading RESPONSE: \(response.statusCode)")
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }.resume()
        }
    }
    
    func gameParsing(data: Data, completion: (_ game: Game?) -> Void) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        guard let dict = json as? [String: Any] else { return }
        guard let competition = dict["competition"] as? [String: Any] else { return }
        guard let code = competition["code"] as? String else { return }
        guard let matches = dict["matches"] as? [[String: Any]] else { return }
        for match in matches {
            guard let homeDict = match["homeTeam"] as? [String: Any] else { return }
            guard let homeTeam = homeDict["name"] as? String else { return }
            
            guard let awayDict = match["awayTeam"] as? [String: Any] else { return }
            guard let awayTeam = awayDict["name"] as? String else { return }
            
            guard let scoreDict = match["score"] as? [String: Any] else { return }
            guard let fullTimeScore = scoreDict["fullTime"] as? [String: Any] else { return }
            
            //Checking if score contains an Int value and not null (as in case of upcoming games with no score yet)
            let homeScore: String = {
                var score = "-"
                if fullTimeScore["homeTeam"] as? Int != nil {
                    score = "\(fullTimeScore["homeTeam"] ?? "-")"
                }
                return score
            }()
            
            let awayScore: String = {
                var score = "-"
                if fullTimeScore["awayTeam"] as? Int != nil {
                    score = "\(fullTimeScore["awayTeam"] ?? "-")"
                }
                return score
            }()
            
            guard let date = match["utcDate"] as? String else { return }
            
            let newGame = Game(competition: code, homeTeam: homeTeam, awayTeam: awayTeam, scoreHome: homeScore, scoreAway: awayScore, date: date)
            completion(newGame)
        }
    }
}
