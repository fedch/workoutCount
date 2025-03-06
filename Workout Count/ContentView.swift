import SwiftUI

struct ContentView: View {
    @AppStorage("reps") private var reps: Int = 0
    @AppStorage("sets") private var sets: Int = 0
    @AppStorage("weight") private var weight: Double = 0.0
    @State private var history: [(id: UUID, set: Int, reps: Int, weight: Double)] = []
    @State private var restTime: Int = 60
    @State private var timerActive = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Workout Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            CounterView(title: "Reps", value: $reps)
            CounterView(title: "Sets", value: $sets)
            WeightCounterView(weight: $weight)
            
            Button(action: saveSet) {
                Text("Save Set")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: resetCounters) {
                Text("Reset")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Text("Rest Timer: \(restTime) sec")
                .font(.title2)
            
            Button(action: startTimer) {
                Text(timerActive ? "Stop Timer" : "Start Timer")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(timerActive ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            List(history, id: \ .id) { entry in
                HStack {
                    Text("Set \(entry.set): Reps \(entry.reps), Weight \(entry.weight, specifier: "%.1f") kg")
                    Spacer()
                    Button(action: { deleteSet(id: entry.id) }) {
                        Image(systemName: "trash").foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: loadHistory)
    }
    
    private func saveSet() {
        let newSet = (id: UUID(), set: sets, reps: reps, weight: weight)
        history.append(newSet)
        sets += 1
        reps = 0
        weight = 0.0
        saveHistory()
    }
    
    private func resetCounters() {
        reps = 0
        sets = 0
        weight = 0.0
        history.removeAll()
        saveHistory()
    }
    
    private func deleteSet(id: UUID) {
        history.removeAll { $0.id == id }
        saveHistory()
    }
    
    private func startTimer() {
        if timerActive {
            timer?.invalidate()
            timerActive = false
            restTime = 60
        } else {
            timerActive = true
            restTime = 60
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if restTime > 0 {
                    restTime -= 1
                } else {
                    timer?.invalidate()
                    timerActive = false
                }
            }
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: "history")
        }
    }
    
    private func loadHistory() {
        if let savedData = UserDefaults.standard.data(forKey: "history"),
           let decoded = try? JSONDecoder().decode([(id: UUID, set: Int, reps: Int, weight: Double)].self, from: savedData) {
            history = decoded
        }
    }
}

struct CounterView: View {
    let title: String
    @Binding var value: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Button(action: { if value > 0 { value -= 1 } }) {
                Image(systemName: "minus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            Text("\(value)")
                .font(.title)
                .frame(width: 50)
            Button(action: { value += 1 }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

struct WeightCounterView: View {
    @Binding var weight: Double
    
    var body: some View {
        HStack {
            Text("Weight (kg)")
                .font(.title2)
                .frame(width: 100, alignment: .leading)
            Spacer()
            Button(action: { if weight > 0 { weight -= 2.5 } }) {
                Image(systemName: "minus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            Text(String(format: "%.1f", weight))
                .font(.title)
                .frame(width: 60)
            Button(action: { weight += 2.5 }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}