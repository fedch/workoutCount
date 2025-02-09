import SwiftUI

struct ContentView: View {
    @AppStorage("reps") private var reps: Int = 0
    @AppStorage("sets") private var sets: Int = 0
    @AppStorage("weight") private var weight: Double = 0.0
    @State private var history: [(set: Int, reps: Int, weight: Double)] = []
    
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
            
            List(history, id: \ .set) { entry in
                Text("Set \(entry.set): Reps \(entry.reps), Weight \(entry.weight, specifier: "%.1f") kg")
            }
        }
        .padding()
    }
    
    private func saveSet() {
            history.append((set: sets, reps: reps, weight: weight))
            sets += 1
            reps = 0
            weight = 0.0
    }
    
    private func resetCounters() {
        reps = 0
        sets = 0
        weight = 0.0
        history.removeAll()
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


#Preview {
    ContentView()
}
