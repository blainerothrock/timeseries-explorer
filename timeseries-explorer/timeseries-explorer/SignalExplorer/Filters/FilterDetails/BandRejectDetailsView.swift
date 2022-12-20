//
//  BandRejectDetailsView.swift
//  timeseries-explorer
//
//  Created by Blaine Rothrock on 12/20/22.
//

import SwiftUI
import flexiBLE_signal

struct BandRejectDetailsView: View {
    var timeSeries: TimeSeries<Float>
    var filter: BandRejectFilter
    var update: (()->())?
    
    @State private var cutoffFreqLow: Float = 0.0
    @State private var cutoffFreqLowString = String(0.0)
    @State private var transitionFreqLow: Float = 0.0
    @State private var transitionFreqLowString = String(0.0)
    
    @State private var cutoffFreqHigh: Float = 0.0
    @State private var cutoffFreqHighString = String(0.0)
    @State private var transitionFreqHigh: Float = 0.0
    @State private var transitionFreqHighString = String(0.0)
    
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
    
    init(timeSeries: TimeSeries<Float>, filter: BandRejectFilter, onUpdate: (()->())?) {
        self.timeSeries = timeSeries
        self.filter = filter
        self.update = onUpdate
        
        self.cutoffFreqLow = filter.cutoffFrequencyLow
        self.cutoffFreqLowString = String(filter.cutoffFrequencyLow)
        self.transitionFreqLow = filter.transitionFrequencyLow
        self.transitionFreqLowString = String(filter.transitionFrequencyLow)
        
        self.cutoffFreqHigh = filter.cutoffFrequencyHigh
        self.cutoffFreqHighString = String(filter.cutoffFrequencyHigh)
        self.transitionFreqHigh = filter.transitionFrequencyHigh
        self.transitionFreqHighString = String(filter.transitionFrequencyHigh)
        
        self.nyquistFreq = Float(timeSeries.nyquistFrequencyHz())
        
        filter.frequency = Float(timeSeries.frequencyHz())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FrequencySlider(
                title: "Low Cutoff Frequency",
                sampleRate: filter.frequency,
                percent: filter.cutoffFrequencyLow / filter.frequency,
                maxPercent: 0.49
            ) { percent in
                filter.cutoffFrequencyLow = percent * filter.frequency
                update?()
            }
            
            FrequencySlider(
                title: "Low Transition Frequency",
                sampleRate: filter.frequency,
                percent: filter.transitionFrequencyLow / filter.frequency,
                maxPercent: 0.49
            ) { percent in
                filter.transitionFrequencyLow = percent * filter.frequency
                update?()
            }
            
            FrequencySlider(
                title: "High Cutoff Frequency",
                sampleRate: filter.frequency,
                percent: filter.cutoffFrequencyHigh / filter.frequency,
                maxPercent: 0.49
            ) { percent in
                filter.cutoffFrequencyHigh = percent * filter.frequency
                update?()
            }
            
            FrequencySlider(
                title: "High Transition Frequency",
                sampleRate: filter.frequency,
                percent: filter.transitionFrequencyHigh / filter.frequency,
                maxPercent: 0.49
            ) { percent in
                filter.transitionFrequencyHigh = percent * filter.frequency
                update?()
            }
        }
    }
}

struct BandRejectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BandRejectDetailsView(
            timeSeries: TimeSeries<Float>(persistence: 0),
            filter: BandRejectFilter(
                frequency: 100.0,
                cutoffFrequencyHigh: 10,
                transitionFrequencyHigh: 1,
                cutoffFrequencyLow: 5,
                transitionFrequencyLow: 1
            ),
            onUpdate: nil
        )
    }
}
