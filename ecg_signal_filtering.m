Fs = 1000; 
Fc = 1000; 
filter_order = 200; 
passband_ripple = 0.01; 
stopband_attenuation = 60; 

normalized_cutoff = Fc / (Fs / 2);
fir_highpass_filter = firpm(filter_order, [0 normalized_cutoff 1.5*normalized_cutoff 1], [0 0 1 1], [1 stopband_attenuation]);

fvtool(fir_highpass_filter, 'Fs', Fs);

t = 0:1/Fs:10; % 10 seconds of ECG
ecg_clean_signal = 1.5*sin(2*pi*1*t);
baseline_drift = 0.3*sin(2*pi*0.1*t);
random_noise = 0.2 * randn(size(t));
ecg_with_noise = ecg_clean_signal + baseline_drift + random_noise;

% 1. Adaptive Filtering (LMS) for Noise Reduction
lms_step_size = 0.01; 
lms_filter_order = 50; 
len = length(ecg_with_noise);
lms_filter_weights = zeros(lms_filter_order, 1);
lms_filtered_ecg = zeros(len, 1); 
lms_error_signal = zeros(len, 1); 

for n = lms_filter_order+1:len
    x = ecg_with_noise(n-lms_filter_order+1:n)';
    d = random_noise(n); 
    lms_filtered_ecg(n) = dot(lms_filter_weights, x); 
    lms_error_signal(n) = d - lms_filtered_ecg(n);
    lms_filter_weights = lms_filter_weights + 2 * lms_step_size * lms_error_signal(n) * x; 
end

% 2. Real-Time Filtering Simulation (Processing in Chunks)
chunk_size = Fs; 
filtered_ecg_realtime = zeros(size(ecg_with_noise)); 

for i = 1:chunk_size:length(ecg_with_noise)
    chunk_end = min(i + chunk_size - 1, length(ecg_with_noise)); 
    chunk = ecg_with_noise(i:chunk_end); 
    filtered_ecg_realtime(i:chunk_end) = filter(fir_highpass_filter, 1, chunk); 
end

% 3. Compare FIR Filter with IIR Filter
[iir_filter_coeff_b, iir_filter_coeff_a] = butter(4, 0.1); 
iir_filtered_ecg = filter(iir_filter_coeff_b, iir_filter_coeff_a, ecg_with_noise); 

% Plot the results
figure;
subplot(4, 1, 1);
plot(t, ecg_with_noise);
title('Noisy ECG with Baseline Wander');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 1, 2);
plot(t, baseline_drift, 'r');
title('Baseline Wander');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 1, 3);
plot(t, filtered_ecg_realtime, 'g');
title('Real-Time Filtered ECG Signal (FIR)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 1, 4);
plot(t, lms_filtered_ecg, 'b');
title('LMS Adaptive Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

figure;
subplot(3, 1, 1);
plot(t, filtered_ecg_realtime, 'g');
title('FIR Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, iir_filtered_ecg, 'm');
title('IIR Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(t, lms_filtered_ecg, 'b');
title('LMS Adaptive Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
