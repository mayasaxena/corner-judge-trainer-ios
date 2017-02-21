//
//  MatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift
import Intrepid
import Starscream

protocol MatchHolding {
    var model: Match { get }
}

public final class MatchViewModel: MatchHolding, WebSocketDelegate {
    internal let model = Match()

    private let disposeBag = DisposeBag()

    private var webSocket: WebSocket
    
    let redScoreText: Variable<String?>
    let blueScoreText: Variable<String?>
    
    let redPlayerName: Variable<String>
    let bluePlayerName: Variable<String>

    let matchInfoViewHidden = Variable(false)
    
    let timerLabelTextColor = Variable(UIColor.white)
    let timerLabelText: Variable<String?> = Variable("0:00")
    
    let penaltyButtonsVisible = Variable(true)
    let disablingViewVisible = Variable(true)

    private var timeRemaining = TimeInterval()
    private var endTime = Date()
    private var timer = Timer()

    let matchHasEnded = Variable(false)
    private var matchEnded = false {
        didSet {
            matchHasEnded.value = matchEnded
        }
    }
    
    let roundLabelHidden = Variable(false)
    let roundLabelText: Variable<String?> = Variable("R1")
    private var isRestRound = false

    init() {
        redScoreText = Variable(model.redScore.formattedString)
        blueScoreText = Variable(model.blueScore.formattedString)
        
        redPlayerName = Variable(model.redPlayer.displayName)
        bluePlayerName = Variable(model.bluePlayer.displayName)

        webSocket = WebSocket(url: URL(string: "ws://localhost:8080/match/10/")!)
        webSocket.delegate = self
        webSocket.connect()

        setupNameUpdates()

        resetTimer(model.matchType.roundDuration)

        matchInfoViewHidden.value = model.matchType == .none
    }
    
    private func setupNameUpdates() {
        redPlayerName.asObservable().subscribeNext {
            self.model.redPlayer.name = $0
        } >>> disposeBag
        
        bluePlayerName.asObservable().subscribeNext {
            self.model.bluePlayer.name = $0
        } >>> disposeBag
    }
    
    private func resetTimer(_ time: TimeInterval) {
        timeRemaining = time
        timerLabelText.value = timeRemaining.formattedTimeString
    }
    
    private func startTimer() {
        endTime = Date().addingTimeInterval(timeRemaining)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    dynamic func updateTime() {
        if timeRemaining > 0 {
            timeRemaining = endTime.timeIntervalSinceNow
            timerLabelText.value = timeRemaining.formattedTimeString
        } else {
            timer.invalidate()
            timerLabelText.value = "0:00"
            endRound()
        }
    }
    
    private func endRound() {
        var roundTime: TimeInterval
        
        if isRestRound { // set to normal round
            roundTime = model.matchType.roundDuration
            setupNormalRound()
        } else { // set to rest round
            if model.round == model.matchType.roundCount {
                endMatch()
                return
            } else {
                roundTime = model.restTimeInterval
                setupRestRound()
            }
        }
        resetTimer(roundTime)
        startTimer()
    }
    
    private func setupNormalRound() {
        timerLabelTextColor.value = UIColor.white
        isRestRound = false
        disablingViewVisible.value = false
        roundLabelHidden.value = true
        model.round += 1
        roundLabelText.value = "R\(model.round)"
    }
    
    private func setupRestRound() {
        timerLabelTextColor.value = UIColor.yellow
        isRestRound = true
        disablingViewVisible.value = true
        roundLabelHidden.value = false
        roundLabelText.value = "REST"
    }

    private func endMatch() {
        model.endMatch()
        print(model.winningPlayer?.name ?? "No winning player")
        pauseTimer()
        disablingViewVisible.value = true
        matchEnded = true
        // TODO: Display alert/modal with match stats and option to start new
    }
    
    public func handleMatchInfoViewTapped() {
        guard !matchEnded else { return }
        if timer.isValid {
            pauseTimer()
            penaltyButtonsVisible.value = true
            roundLabelHidden.value = false
            disablingViewVisible.value = true
            
        } else {
            startTimer()
            penaltyButtonsVisible.value = false
            if !isRestRound {
                roundLabelHidden.value = true
                disablingViewVisible.value = false
            }
        }
    }
    
    public func pauseTimer() {
        if timer.isValid {
            timer.invalidate()
        }
    }

    // MARK: - View Handlers

    public func handleScoringAreaTapped(color: PlayerColor) {
        playerScored(scoringEvent: ScoringEvent(color: color, category: .head, judgeID: "judge-iOS"))
    }

    public func handleScoringAreaSwiped(color: PlayerColor) {
        playerScored(scoringEvent: ScoringEvent(color: color, category: .body, judgeID: "judge-iOS"))
    }

    public func handleTechnicalButtonTapped(color: PlayerColor) {
        playerScored(scoringEvent: ScoringEvent(color: color, category: .technical, judgeID: "judge-iOS"))
    }

    public func handlePenaltyConfirmed(color: PlayerColor, penalty: ScoringEvent.Category) {
        playerScored(scoringEvent: ScoringEvent(color: color, category: penalty, judgeID: "judge-iOS"))
    }

    private func playerScored(scoringEvent: ScoringEvent) {
        model.updateScore(scoringEvent: scoringEvent)

        redScoreText.value = model.redScore.formattedString
        blueScoreText.value = model.blueScore.formattedString

        if model.winningPlayer != nil {
            endMatch()
        }
    }

    // MARK: - WebSocketDelegate

    public func websocketDidConnect(socket: WebSocket) {
        print("connected")
        socket.write(string: "{\"judge\":\"iOS\"}")
    }

    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    }

    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print(text)
    }

    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print(data)
    }
}

extension Double {
    var formattedString: String {
        return String(Int(self))
    }
}

extension TimeInterval {
    var formattedTimeString: String {
        return String(format: "%d:%02d", Int(self / 60.0),  Int(ceil(self.truncatingRemainder(dividingBy: 60))))
    }
}
