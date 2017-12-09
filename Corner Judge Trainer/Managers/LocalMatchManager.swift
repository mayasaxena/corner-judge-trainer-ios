//
//  Match.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

final class LocalMatchManager: MatchManager {

    private struct Constants {
        static let restTime: TimeInterval = 30.0
    }

    let match: Match

    private var round: Int = 1 {
        didSet {
            round = min(round, match.type.roundCount)
        }
    }

    weak var delegate: MatchManagerDelegate?

    private var isRestRound = false
    private var matchEnded = false

    private var timeRemaining = TimeInterval()
    private var endTime = Date()
    private var timer = Timer()

    convenience init(matchType: MatchType) {
        self.init(match: Match(type: matchType))
    }

    init(match: Match = Match()) {
        self.match = match
        resetTimer(match.type.roundDuration)
        delegate?.timerUpdated(timeString: timeRemaining.formattedTimeString)
    }

    func handle(scoringEvent: ScoringEvent) {
        match.handle(scoringEvent: scoringEvent)

        delegate?.scoreUpdated(redScore: match.redScore, blueScore: match.blueScore)

        guard match.type != .none else { return }

        match.checkPenalties()
        if round > match.type.pointGapThresholdRound {
            match.checkPointGap()
        }

        if match.isWon {
            endMatch()
        }
    }

    func joinMatch() {}

    func playPause() {
        guard !matchEnded else { return }
        if timer.isValid {
            stopTimer()
        } else {
            startTimer()
        }

        delegate?.matchStatusChanged(scoringDisabled: !match.isWon && (!timer.isValid || isRestRound))
    }

    // MARK: - Timer methods

    private func resetTimer(_ time: TimeInterval) {
        timeRemaining = time
        delegate?.timerUpdated(timeString: timeRemaining.formattedTimeString)
    }

    private func startTimer() {
        endTime = Date().addingTimeInterval(timeRemaining)
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }

    func stopTimer() {
        if timer.isValid {
            timer.invalidate()
        }
    }

    dynamic func updateTime() {
        if timeRemaining > 0 {
            timeRemaining = endTime.timeIntervalSinceNow
            delegate?.timerUpdated(timeString: timeRemaining.formattedTimeString)
        } else {
            timer.invalidate()
            delegate?.timerUpdated(timeString: (0.0).formattedTimeString)
            endRound()
        }
    }

    private func endRound() {
        var roundTime: TimeInterval
        let wasRestRound = isRestRound

        if wasRestRound {
            isRestRound = false
            round += 1
            roundTime = match.type.roundDuration

        } else {
            if round == match.type.roundCount {
                match.determineWinner()
                endMatch()
                return
            } else {
                roundTime = Constants.restTime
                isRestRound = true
            }
        }

        resetTimer(roundTime)
        startTimer()
        delegate?.matchStatusChanged(scoringDisabled: isRestRound)
        delegate?.roundChanged(round: isRestRound ? nil : round)
    }

    private func endMatch() {
        print(match.winningPlayer?.name ?? "No winning player")
        stopTimer()
        delegate?.matchStatusChanged(scoringDisabled: true)
        matchEnded = true
        // TODO: Display alert/modal with match stats and option to start new
    }
}

extension MatchType {

    var roundDuration: TimeInterval {
        switch self {
        case .aTeam:
            return TimeInterval(2 * 60.0)
        case .bTeam:
            return TimeInterval(1.5 * 60.0)
        case .cTeam:
            return TimeInterval(1 * 60.0)
        default:
            return TimeInterval(10.0)
        }
    }

    var roundCount: Int {
        switch self {
        case .aTeam, .bTeam, .cTeam:
            return 2
        case .none:
            return 2
        default:
            return 3
        }
    }

    var pointGapThresholdRound: Int {
        switch self {
        case .aTeam, .bTeam, .cTeam, .none:
            return 0
        default:
            return 0
        }
    }
}

extension Date {
    var timeStampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyy h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

extension TimeInterval {
    var formattedTimeString: String {
        return String(format: "%d:%02d", Int(self / 60.0), Int(ceil(self.truncatingRemainder(dividingBy: 60))))
    }
}
