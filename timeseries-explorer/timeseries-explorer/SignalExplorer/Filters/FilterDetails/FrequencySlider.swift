//
//  FrequencySlider.swift
//  timeseries-explorer
//
//  Created by Blaine Rothrock on 12/19/22.
//

import SwiftUI

struct FrequencySlider: View {
    
    var title: String
    var sampleRate: Float
    
    var maxPercent: Float = 0.49
    
    var didChange: ((_ percent: Float)->())?
    
    @State var percent: Float = 0.0
    @State var frequencyString: String = "0.0"
    @State var percentString: String = "0.0"
    
    init(title: String, sampleRate: Float, percent: Float, maxPercent: Float, didChange: ((_ percent: Float)->())?) {
        self.title = title
        self.sampleRate = sampleRate
        self.maxPercent = maxPercent
        _percent = .init(initialValue: percent)
        _frequencyString = .init(initialValue: String(format: "%.2f", percent*sampleRate))
        _percentString = .init(initialValue: String(format: "%.1f", percent*100))
        self.didChange = didChange
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title):")
                .font(.title3.bold())
            HStack {
                Spacer().frame(width: 16)
                TextField(title, text: $percentString)
                    .onSubmit {
                        guard let value = Float(percentString),
                              value < maxPercent, value > 0 else {
                            return
                        }
                        percent = value
                    }
                    .labelsHidden()
                    .frame(maxWidth: 50)
                    .textFieldStyle(.roundedBorder)
                Text("%")
                Spacer().frame(width: 32)
                TextField(title, text: $frequencyString)
                    .onSubmit {
                        guard let value = Float(frequencyString),
                              value < maxPercent * sampleRate, value > 0 else {
                            frequencyString = String(frequencyString)
                            return
                        }
                        percent = value / sampleRate
                    }
                    .labelsHidden()
                    .frame(maxWidth: 75)
                    .textFieldStyle(.roundedBorder)
                Text("Hz")
            }
            HStack {
                Spacer().frame(width: 16)
                Slider(value: $percent, in: 0.01...maxPercent, step: 0.01) { editing in
                    guard !editing else { return }
                    didChange?(percent)
                }
                    .onChange(of: percent) { newValue in
                        percentString = String(format: "%.1f", percent*100)
                        frequencyString = String(format: "%.2f", percent*sampleRate)
                    }
            }
        }
    }
}

struct FrequencySlider_Previews: PreviewProvider {
    static var previews: some View {
        Group
        {
            FrequencySlider(title: "Cutoff Frequency", sampleRate: 20.0, percent: 10.0, maxPercent: 0.49, didChange: nil)
                .previewLayout(.sizeThatFits)
                .padding()
//                .frame(width: 300, height: 100)
        }
    }
}
