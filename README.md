# ecg-signal-denoising

This repository demonstrates the use of different filters (FIR, LMS, and IIR) for denoising an ECG signal.
It includes synthetic ECG signal generation, filter design, and real-time filtering simulation.

## Specifications
- **Sampling Frequency (Fs)**: 1000 Hz
- **Cutoff Frequency (Fc)**: 0.5 Hz (for high-pass filter)
- **Filter Order**: 200 for FIR filter, 50 for LMS filter
- **Passband Ripple**: 0.01 (for FIR filter)
- **Stopband Attenuation**: 60 dB (for FIR filter)

## Signal
A synthetic ECG signal is used, generated as a 1 Hz sinusoidal waveform, with added baseline wander (0.1 Hz) and Gaussian noise.

## Features
- **ECG Signal Simulation**: Synthetic ECG signal with baseline wander and noise.
- **Filter Implementations**:
  - **FIR High-Pass Filter**: Removes low-frequency noise and baseline wander.
  - **LMS Adaptive Filter**: Adapts filter weights to reduce noise.
  - **IIR Low-Pass Filter**: Compares performance with a 4th-order Butterworth filter.
- **Real-Time Filtering Simulation**: Processes ECG signal in real-time in chunks.
- **Visualization**: Plots noisy ECG signal, filtered outputs, and filter comparisons.
