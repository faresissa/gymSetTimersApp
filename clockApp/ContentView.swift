//
//  ContentView.swift
//  clockApp
//
//  Created by Fares Issa on 2022-01-25.
//
import Combine
import SwiftUI

//struct ContentView: View {
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var shouldSendNewsletter = false
//    @State private var numberOfLikes = 1
//
//    var body: some View {
//        NavigationView{
//            Form {
//                Section(header: Text("Personal Information")) {
//                    TextField("First Name", text: $firstName)
//                    TextField("Last Name", text: $lastName)
//                }
//                Section(header: Text("Actions")) {
//                    Toggle("Send Newsletter", isOn: $shouldSendNewsletter)
//                        .toggleStyle(SwitchToggleStyle(tint: .red))
//                    Stepper("Number of Likes", value: $numberOfLikes, in: 1...100)
//                    Text("Counter: \(numberOfLikes)")
//                }
//            }
//            .navigationTitle("Account")
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    Button {
//                        hideKeyboard()
//                    } label: {
//                        Image(systemName: "keyboard.chevron.compact.down")
//                    }
//                    Button("Save", action: saveUser)
//                }
//            }
//            .accentColor(.red)
//        }
//    }
//    func saveUser() {
//       print("User Saved")
//    }
//}
/*
struct ContentView: View {
    //Input Declarations
    @State private var workoutTimeInput: Int = 0
    @State private var superSetTimeInput: Int = 0
    @State private var restTimeInput: Int = 0
    
    var timer = Timer()
    var globalTimer: Int {
        workoutTimeInput
    }
    
    //String to Int conversion returns optional
    /*var workoutTime: Int {
        return Int(workoutTimeInput) ?? 0
    }
    
    var superSetTime: Int {
        return Int(superSetTimeInput) ?? 0
    }
    
    var restTime: Int {
        return Int(restTimeInput) ?? 0
    }*/
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Timer Settings")) {
                    Stepper("Main Set [\(workoutTimeInput) seconds]", value: $workoutTimeInput, in: 0...150)
                    Stepper("Superset [\(superSetTimeInput) seconds]", value: $superSetTimeInput, in: 0...150)
                    Stepper("Rest [\(restTimeInput) seconds]", value: $restTimeInput, in: 0...150)
                }
                Section() {
                    HStack {
                        Button("START", action: startTimer)
                        Spacer()
                        Button("PAUSE", action: pauseTimer)
                        Spacer()
                        Button("RESET", action: resetTimer)
                    }
                    Label(String(globalTimer), image: "")
                        .labelStyle(TitleOnlyLabelStyle())
                    .padding()
                }
            }
            .navigationTitle("Test")//globalTimer)
        }
    }
    
    func startTimer() {
//        convertTimeLogic()
//
//        timer.invalidate()
//        //Create timer
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ContentView.timerClass), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
//        timer.invalidate()

    }
    func resetTimer() {
//        timer.invalidate()
//        globalTimer = 0
    }
    func timerClass() {
//        globalTimer -= globalTimer
//        if (globalTimer == 0) {
//            timer.invalidate()
//        }
    }
    func convertTimeLogic() {
//        globalTimer = workoutTime
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
*/

class TimerManager : ObservableObject {
    @Published var timeRemaining = 0
    private var cancellable : AnyCancellable?
    
    func startTimer(initial: Int) {
        timeRemaining = initial
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.timeRemaining -= 1
                if self.timeRemaining == 0 {
                    self.cancellable?.cancel()
                }
            }
    }
}

struct ContentView: View {
    @StateObject private var timeManager = TimerManager()
    @State private var workoutTimeInput = 60
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Timer Settings")) {
                    Stepper("Main Set [\(workoutTimeInput) seconds]", value: $workoutTimeInput, in: 0...150)
                    //Stepper("Superset [\(superSetTimeInput) seconds]", value: $superSetTimeInput, in: 0...150)
                    //Stepper("Rest [\(restTimeInput) seconds]", value: $restTimeInput, in: 0...150)
                }
                Section() {
                    HStack {
                        Button("START") {
                            timeManager.startTimer(initial: workoutTimeInput)
                        }
                        //Spacer()
                        //Button("PAUSE", action: pauseTimer)
                        //Spacer()
                        //Button("RESET", action: resetTimer)
                    }
                }
            }
            .navigationTitle("Time remaining: \(timeManager.timeRemaining)")//globalTimer)
        }
        
        /*Stepper("Input \(stepperValue)", value: $stepperValue, in: 0...150)
        Button("Start") {
            timeManager.startTimer(initial: stepperValue)
        }
        Label("\(timeManager.timeRemaining)", image: "")
            .labelStyle(TitleOnlyLabelStyle())
         */
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
