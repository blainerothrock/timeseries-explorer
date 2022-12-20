//
//  HighPassDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct HighPassDetailsView: View {
    var timeSeries: TimeSeries<Float>
    var filter: HighPassFilter
    var update: (()->())?
    
    @State private var cutoffFreq: Float = 0.0
    @State private var cutoffFreqString = String(0.0)
    @State private var transitionFreq: Float = 0.0
    @State private var transitionFreqString = String(0.0)
    
    private var nyquistFreq: Float
    private var maxCutoff: Float {
        return nyquistFreq / 10
    }
    
    private var step: Float {
        if nyquistFreq >= 100 {
            return 1.0
        } else if nyquistFreq >= 50 {
            return 0.5
        } else {
            return 0.1
        }
    }
    
    init(timeSeries: TimeSeries<Float>, filter: HighPassFilter, onUpdate: (()->())?) {
        self.timeSeries = timeSeries
        self.filter = filter
        self.update = onUpdate
        
        self.cutoffFreq = filter.cutoffFrequency
        self.cutoffFreqString = String(filter.cutoffFrequency)
        self.transitionFreq = filter.transitionFrequency
        self.transitionFreqString = String(filter.transitionFrequency)
        
        self.nyquistFreq = Float(timeSeries.nyquistFrequencyHz())
        
        filter.frequency = Float(timeSeries.frequencyHz())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FrequencySlider(
                title: "Cutoff Frequency",
                sampleRate: filter.frequency,
                percent: filter.cutoffFrequency / filter.frequency,
                maxPercent: 0.49
            ) { percent in
                filter.cutoffFrequency = percent * filter.frequency
                update?()
            }
            
            FrequencySlider(
                title: "Transition Frequency",
                sampleRate: filter.frequency,
                percent: filter.transitionFrequency / filter.frequency,
                maxPercent: 0.49
            ) { percent in
                filter.transitionFrequency = percent * filter.frequency
                update?()
            }
            
        }
    }
}

struct HighPassDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HighPassDetailsView(
            timeSeries: TimeSeries<Float>(persistence: 0),
            filter: HighPassFilter(frequency: 100.0, cutoffFrequency: 10.0, transitionFrequency: 1.0),
            onUpdate: nil
        )
    }
}
