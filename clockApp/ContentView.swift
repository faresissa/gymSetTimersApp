//
//  ContentView.swift
//  clockApp
//
//  Created by Fares Issa on 2022-01-25.
//
import Combine
import SwiftUI

@MainActor class TimerManager : ObservableObject {
    @Published var workoutTimeRemaining = 0
    @Published var superSetTimeRemaining = 0
    @Published var restTimeRemaining = 0
    
    //@State var showWorkout = true
    //@State var showSuper = true
    //@State var showRest = true
    
    private var cancellable_workout : AnyCancellable?
    private var cancellable_super : AnyCancellable?
    private var cancellable_rest : AnyCancellable?

    func clockManager(workoutTimer: Int, superSetTimer: Int, restTimer: Int) {
        let operation1 = BlockOperation { [self] in
            //showSuper.toggle()
            //showRest.toggle()
            self.workoutTimerFunction(workoutTimer: workoutTimer)
            Thread.sleep(forTimeInterval: TimeInterval(workoutTimeRemaining))
            print("Operation 1 completed")
        }

        let operation2 = BlockOperation { [self] in
            //showWorkout.toggle()
            //showRest.toggle()
            self.supersetTimerFunction(superSetTimer: superSetTimer)
            Thread.sleep(forTimeInterval: TimeInterval(superSetTimeRemaining))
            print("Operation 2 completed")
        }
        
        let operation3 = BlockOperation { [self] in
            //showWorkout.toggle()
            //showSuper.toggle()
            self.restTimerFunction(restTimer: restTimer)
            Thread.sleep(forTimeInterval: TimeInterval(restTimeRemaining))
            print("Operation 3 completed")
        }

        operation2.addDependency(operation1)
        operation3.addDependency(operation2)

        let queue = OperationQueue()
        queue.addOperation(operation1)
        queue.addOperation(operation2)
        queue.addOperation(operation3)
    }
    
    func workoutTimerFunction(workoutTimer: Int) {
        workoutTimeRemaining = workoutTimer
        cancellable_workout = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.workoutTimeRemaining -= 1
                if self.workoutTimeRemaining == 0 {
                    self.cancellable_workout?.cancel()
                }
            }
    }
    
    func supersetTimerFunction(superSetTimer: Int) {
        superSetTimeRemaining = superSetTimer
        cancellable_super = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.superSetTimeRemaining -= 1
                if self.superSetTimeRemaining == 0 {
                    self.cancellable_super?.cancel()
                }
            }
    }
    
    func restTimerFunction(restTimer: Int) {
        restTimeRemaining = restTimer
        cancellable_rest = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.restTimeRemaining -= 1
                if self.restTimeRemaining == 0 {
                    self.cancellable_rest?.cancel()
                }
            }
    }
}

struct ContentView: View {
    @StateObject private var timeManager = TimerManager()
    @State private var workoutTimeInput = 5
    @State private var superSetTimeInput = 4
    @State private var restTimeInput = 3

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Timers")){
                    Text(("Main Set: \(timeManager.workoutTimeRemaining)"))
                        //.opacity(timeManager.showWorkout ? 1 : 0)
                    Text(("Super Set: \(timeManager.superSetTimeRemaining)"))
                        //.opacity(timeManager.showSuper ? 1 : 0)
                    Text(("Rest: \(timeManager.restTimeRemaining)"))
                        //.opacity(timeManager.showRest ? 1 : 0)
                }
                Section(header: Text("Workout Timer Settings")) {
                    Stepper("Main Set [\(workoutTimeInput) seconds]", value: $workoutTimeInput, in: 0...150)
                    Stepper("Superset [\(superSetTimeInput) seconds]", value: $superSetTimeInput, in: 0...150)
                    Stepper("Rest [\(restTimeInput) seconds]", value: $restTimeInput, in: 0...150)
                }
                Section() {
                    HStack {
                        Button("START") {
                            timeManager.clockManager(workoutTimer: workoutTimeInput, superSetTimer: superSetTimeInput, restTimer: restTimeInput)
                        }
                    }
                }
            }
            .navigationBarTitle("Clock Application", displayMode: .inline)
        }
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
