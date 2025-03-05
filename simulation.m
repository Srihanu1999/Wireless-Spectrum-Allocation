clc; clear; close all;

fs = 1e6;        % Sampling frequency (1 MHz)
t = 0:1/fs:1-1/fs; % Time vector (1 second)
N = length(t);   % Number of samples

% Define carrier frequencies for different users
f1 = 100e3; % User 1: 100 kHz
f2 = 120e3; % User 2: 120 kHz (close frequency, potential interference)
f3 = 300e3; % User 3: 300 kHz (far frequency, less interference)

% Generate signals for each user
s1 = cos(2*pi*f1*t); % User 1 signal
s2 = cos(2*pi*f2*t); % User 2 signal (may cause interference with User 1)
s3 = cos(2*pi*f3*t); % User 3 signal (less interference)

% Combine signals (simulating shared spectrum usage)
signal = s1 + s2 + s3;

% Compute Power Spectral Density (PSD) using FFT
f = linspace(-fs/2, fs/2, N); % Frequency axis
PSD = abs(fftshift(fft(signal))).^2 / N; 

% Plot Power Spectral Density
figure;
plot(f/1e3, 10*log10(PSD), 'b', 'LineWidth', 1.5);
xlabel('Frequency (kHz)');
ylabel('Power Spectral Density (dB)');
title('Wireless Spectrum Usage and Interference Analysis');
grid on;
xlim([-500 500]);
