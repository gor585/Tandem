//
//  FootballViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 30.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class FootballViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mainFilterButton: UIButton!
    @IBOutlet weak var mainFlagImage: UIImageView!
    @IBOutlet weak var othersStackView: UIStackView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    
    var lightColorTheme = Bool()
    let userDefaults = UserDefaults.standard
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var latestScoresDict = [String: [Game]]()
    var upcomingGamesDict = [String: [Game]]()
    var gamesToPresentArray = [Game]()
    var selectedLeague = "PL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        lightColorTheme = userDefaults.bool(forKey: "lightThemeIsOn")
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibCell = UINib(nibName: "GameCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "gameCell")
        activityIndicator.startAnimating()
        getGamesUpdates()
        othersStackView.isHidden = true
    }
    
    //MARK: - TableView delegate methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        cell.setGame(game: gamesToPresentArray[indexPath.row])
        applyColorTheme(cell: cell)
        
        if gamesToPresentArray[indexPath.row].selected == true {
            cell.contentView.backgroundColor = UIColor(hexString: "008080")
            cell.homeTeamLabel.textColor = UIColor.white
            cell.awayTeamLabel.textColor = UIColor.white
            cell.dateLabel.textColor = UIColor.white
            cell.homeScoreLabel.textColor = UIColor.white
            cell.awayScoreLabel.textColor = UIColor.white
            cell.scoreSeparatorLabel.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor(hexString: "E6E6E6")
            cell.homeTeamLabel.textColor = UIColor.black
            cell.awayTeamLabel.textColor = UIColor.black
            cell.dateLabel.textColor = UIColor.black
            cell.homeScoreLabel.textColor = UIColor.black
            cell.awayScoreLabel.textColor = UIColor.black
            cell.scoreSeparatorLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesToPresentArray.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let game = gamesToPresentArray[indexPath.row]
        var select = UITableViewRowAction()
        if segmentedControl.selectedSegmentIndex == 1 {
            let gameCellSelection = UITableViewRowAction(style: .default, title: "Select") { (action, indexPath) in
                DataService.shared.getUserImg(completion: { (userName, userImage, url) in
                    guard let name = userName else { return }
                    guard let image = userImage else { return }
                    guard let url = url else { return }
                    //MARK: - Add new item in ToDo list
                    DataService.shared.addNewItem(title: "\(game.homeTeam) - \(game.awayTeam) game", text: "\(game.homeTeam) - \(game.awayTeam) \nDate: \(game.date)", userLogin: name, userImage: image, userImgURL: url, completion: { (newItemDict) in })
                })
                game.selected = true
                tableView.reloadData()
            }
            select = gameCellSelection
            select.backgroundColor = UIColor(hexString: "008080")
        } 
        return [select]
    }
    
    //MARK: - Networking
    func getGamesUpdates() {
        GamesService.shared.getScores { (scores) in
            guard let scores = scores else { return }
            self.latestScoresDict = scores
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.switchLeague()
            }
        }
        
        GamesService.shared.getUpcomingGames { (upcomingGames) in
            guard let upcomingGames = upcomingGames else { return }
            self.upcomingGamesDict = upcomingGames
        }
    }
    
    //MARK: - Filtering
    func switchLeague() {
        guard let latestScores = self.latestScoresDict[self.selectedLeague] else { print("Scores not loaded"); return }
        guard let upcomingGames = self.upcomingGamesDict[self.selectedLeague] else { return }
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.gamesToPresentArray = latestScores
            self.tableView.reloadData()
        case 1:
            self.gamesToPresentArray = upcomingGames
            self.tableView.reloadData()
        default: break
        }
    }
    
    @IBAction func mainButtonPressed(_ sender: Any) {
        othersStackView.isHidden = false
    }
    
    @IBAction func otherLeagueButtonPressed(_ sender: UIButton) {
        //Replacing sender name & flag with previous main
        let otherFlagImagesArray = [firstImage, secondImage, thirdImage]
        for image in otherFlagImagesArray {
            if image?.tag == sender.tag {
                image?.image = mainFlagImage.image
            }
        }
        guard let mainName = mainFilterButton.titleLabel?.text else { return }
        sender.setTitle(mainName, for: .normal)
        
        //Setting main name & flag to selected ones
        guard let leagueName = sender.titleLabel?.text else { return }
        othersStackView.isHidden = true
        mainFilterButton.setTitle(leagueName, for: .normal)
        mainFlagImage.image = UIImage(named: leagueName)
        
        guard let senderLeagueName = sender.titleLabel?.text else { return }
        switch senderLeagueName {
        case "FA Premiere League": selectedLeague = "PL"
        case "Bundesliga": selectedLeague = "BL1"
        case "Serie A": selectedLeague = "SA"
        case "Primera": selectedLeague = "PD"
        default: break
        }
        
        switchLeague()
    }
    
    @IBAction func segmentedControllPressed(_ sender: Any) {
        switchLeague()
    }
    
    //MARK: - Observers
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(FootballViewController.darkColorTheme(notification:)), name: COLOR_THEME_DARK, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FootballViewController.lightColorTheme(notification:)), name: COLOR_THEME_LIGHT, object: nil)
    }
    
    //MARK: - Color theme settings
    @objc func darkColorTheme(notification: NSNotification) {
        lightColorTheme = false
        tableView.reloadData()
    }
    
    @objc func lightColorTheme(notification: NSNotification) {
        lightColorTheme = true
        tableView.reloadData()
    }
    
    func applyColorTheme(cell: GameCell) {
        switch lightColorTheme {
        case false:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "7F7F7F")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "7F7F7F")
            tabBarController?.tabBar.tintColor = UIColor.white
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "B3B3B3")
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            tableView.backgroundColor = UIColor(hexString: "7F7F7F")
            segmentedControl.tintColor = UIColor.white
            cell.homeTeamLabel.textColor = UIColor.white
            cell.awayTeamLabel.textColor = UIColor.white
            cell.homeScoreLabel.textColor = UIColor.white
            cell.awayScoreLabel.textColor = UIColor.white
            cell.dateLabel.textColor = UIColor.white
            cell.scoreSeparatorLabel.textColor = UIColor.white
            cell.contentView.backgroundColor = UIColor(hexString: "7F7F7F")
        case true:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "E6E6E6")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "008080")]
            navigationController?.navigationBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "E6E6E6")
            tabBarController?.tabBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "7F7F7F")
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            tableView.backgroundColor = UIColor(hexString: "E6E6E6")
            segmentedControl.tintColor = UIColor(hexString: "008080")
            cell.homeTeamLabel.textColor = UIColor.black
            cell.awayTeamLabel.textColor = UIColor.black
            cell.homeScoreLabel.textColor = UIColor.black
            cell.awayScoreLabel.textColor = UIColor.black
            cell.dateLabel.textColor = UIColor.black
            cell.scoreSeparatorLabel.textColor = UIColor.black
            cell.contentView.backgroundColor = UIColor(hexString: "E6E6E6")
            break
        }
    }
}
