//
//  ViewController.swift
//  StopWatchApp
//
//  Created by Arpit iOS Dev. on 24/06/24.
//
import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetLapButton: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var stopwatchViewModel = StopwatchViewModel()
    var cancellable: AnyCancellable?
    var lapTimes: [Lap] = []
    var lapTimer: Timer?
    var currentLapStartTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "00:00.00"
        resetLapButton.setTitle("Lap", for: .normal)
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.layer.cornerRadius = startStopButton.frame.height / 2
        resetLapButton.layer.cornerRadius = resetLapButton.frame.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cancellable = stopwatchViewModel.$elapsedTime.sink { [weak self] elapsedTime in
            DispatchQueue.main.async {
                self?.timeLabel.text = self?.stopwatchViewModel.formattedElapsedTime()
                if self?.stopwatchViewModel.stopwatchTimer != nil {
                    self?.updateLastLapTime()
                }
            }
        }
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        stopwatchViewModel.startStop()
        
        if stopwatchViewModel.stopwatchTimer == nil {
            sender.setTitle("Start", for: .normal)
            sender.setTitleColor(.systemGreen, for: .normal)
            sender.backgroundColor = .customGreen
            resetLapButton.setTitle("Reset", for: .normal)
        } else {
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = .customeRed
            sender.setTitleColor(.systemRed, for: .normal)
            resetLapButton.setTitle("Lap", for: .normal)
            if lapTimes.isEmpty {
                startNewLap()
            }
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        if stopwatchViewModel.stopwatchTimer == nil {
            stopwatchViewModel.reset()
            startStopButton.setTitle("Start", for: .normal)
            lapTimes.removeAll()
            tableView.reloadData()
            sender.setTitle("Lap", for: .normal)
            lapTimer?.invalidate()
        } else {
            startNewLap()
        }
    }
    
    private func updateLastLapTime() {
        if let lastLap = lapTimes.last {
            lastLap.elapsedTime = stopwatchViewModel.elapsedTime - lastLap.startTime
            tableView.reloadRows(at: [IndexPath(row: lapTimes.count - 1, section: 0)], with: .none)
        }
    }
    
    private func startNewLap() {
        if let lastLap = lapTimes.last {
            lastLap.elapsedTime = stopwatchViewModel.elapsedTime - lastLap.startTime
            tableView.reloadRows(at: [IndexPath(row: lapTimes.count - 1, section: 0)], with: .none)
        }
        let newLap = Lap(startTime: stopwatchViewModel.elapsedTime)
        lapTimes.append(newLap)
        currentLapStartTime = stopwatchViewModel.elapsedTime
        tableView.reloadData()
        startLapTimer()
    }
    
    private func startLapTimer() {
        lapTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let lastLap = self.lapTimes.last {
                lastLap.elapsedTime = self.stopwatchViewModel.elapsedTime - self.currentLapStartTime
                self.tableView.reloadRows(at: [IndexPath(row: self.lapTimes.count - 1, section: 0)], with: .none)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapCell", for: indexPath)
        
        let lap = lapTimes[indexPath.row]
        cell.textLabel?.text = "Lap \(indexPath.row + 1)"
        cell.detailTextLabel?.text = lap.formattedElapsedTime()
        return cell
    }
}
