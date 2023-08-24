% Simulation parameters
numSymbols = 100;              % Number of symbols to transmit
numTaps = 5;                    % Number of channel taps (multipath components)
snr = -2.5;                       % Signal-to-Noise Ratio in dB

% Generate random symbols
symbols = 2 * randi([0 1], numSymbols, 1) - 1;  % BPSK symbols (-1 and +1)

% Generate channel taps (complex Gaussian)
channelTaps = (randn(numTaps, 1) + 1i * randn(numTaps, 1)) / sqrt(2);

% Create frequency-selective fading channel
channelFilter = zeros(numSymbols, numTaps);
for i = 1:numTaps
    channelFilter(i:numSymbols, i) = symbols(1:numSymbols-i+1);
end

% Apply channel fading
fadedSymbols = channelFilter * channelTaps;

% Add noise to the received signal
noise = sqrt(0.5 / (10^(snr/10))) * (randn(numSymbols, 1) + 1i * randn(numSymbols, 1));
receivedSymbols = fadedSymbols + noise;

% Calculate channel magnitude
channelMagnitude = abs(channelTaps);

% Calculate received signal amplitude
receivedAmplitude = abs(receivedSymbols);

% Plot channel magnitude
figure;
stem(1:numTaps, channelMagnitude, 'b', 'LineWidth', 1.5);
xlabel('Tap Index');
ylabel('Magnitude');
title('Channel Magnitude');

% Plot received signal amplitude
figure;
plot(1:numSymbols, 10*log10(receivedSymbols.^2), 'r', 'LineWidth', 1.5);
xlabel('Symbol Index');
ylabel('Amplitude');
title('Received Signal Amplitude');
