
%% Wireless Spectrum Allocation with Dynamic Assignment, Power Control, and Cognitive Radio
clc; clear; close all;

%% Parameters
fs = 1e6; % Sampling frequency (1 MHz)
num_users = 5; % Number of primary users
num_secondary_users = 2; % Number of cognitive radio users
bw = 200e3; % Bandwidth per user (200 kHz)
nfft = 1024; % FFT size for PSD calculation

% Frequency allocation (dynamic)
primary_frequencies = sort(rand(1, num_users) * (fs - bw));
secondary_frequencies = zeros(1, num_secondary_users);

% Power control (initial power levels)
power_levels = ones(1, num_users) * 1; % Default power = 1

%% Generate signals for primary users
signals = zeros(num_users, nfft);
time = (0:nfft-1) / fs;

for i = 1:num_users
    f = primary_frequencies(i);
    signals(i, :) = power_levels(i) * cos(2 * pi * f * time);
end

%% Cognitive Radio: Spectrum Sensing and Allocation
sensed_spectrum = sum(signals, 1); % Combined spectrum of all primary users
threshold = 0.1; % Threshold for detecting an occupied spectrum

for i = 1:num_secondary_users
    available_bands = find(sensed_spectrum < threshold); % Find free spectrum slots
    if ~isempty(available_bands)
        secondary_frequencies(i) = fs * rand(); % Assign a free frequency dynamically
    end
end

%% Generate signals for cognitive radio users
secondary_signals = zeros(num_secondary_users, nfft);
for i = 1:num_secondary_users
    f = secondary_frequencies(i);
    if f > 0 % If an available band was found
        secondary_signals(i, :) = 0.5 * cos(2 * pi * f * time); % Lower power than primary users
    end
end

%% Combine and Plot Power Spectral Density (PSD)
combined_signal = sum(signals, 1) + sum(secondary_signals, 1);
psd_signal = abs(fft(combined_signal, nfft)).^2 / nfft;
freq_axis = linspace(0, fs, nfft);

figure;
plot(freq_axis, 10*log10(psd_signal));
grid on;
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density (dB)');
title('Power Spectral Density of Wireless Spectrum Allocation');

%% Adaptive Power Control: Reduce Power in High Interference Zones
for i = 1:num_users
    if mean(psd_signal) > threshold
        power_levels(i) = power_levels(i) * 0.8; % Reduce power if interference is high
    end
end


