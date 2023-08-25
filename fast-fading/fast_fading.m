% Các thông số mô phỏng
numSamples = 100;       % Số mẫu thử
samplingRate = 1e6;     % tốc độ lấy mẫu - Hz
carrierFreq = 2.4e9;    % Tần số sóng mang - Hz
velocity = 33.33;         % Tốc độ di chuyển của trạm thu m/s
pathLossExponent = 2;   % hệ số path loss 
shadowingStdDev = 4;    % Phương sai shadowing chuẩn

% Tạo kênh rayleigh làm mẫu
t = (0:numSamples-1) / samplingRate;
fd = velocity / carrierFreq;               % tần số Doppler tối đa
tau = 1 / fd;                              % Độ trễ trải tối đa
pathGain = sqrt(1/2) * (randn(numSamples, 1) + 1i * randn(numSamples, 1));  % guassian phức rayleigh
shadowing = db2mag(shadowingStdDev * randn(numSamples, 1));  % độ lợi shadowing
pathLoss = (carrierFreq / (4*pi)) .^ pathLossExponent;  % Path loss

% Nội suy độ lợi và khớp với trục thời gian
interpPathGain = interp1([0, tau], [1, 1], t, 'linear', 'extrap');

% Tính toán việc lấy mẫu của kênh
channelSamples = sqrt(pathLoss) .* shadowing .* interpPathGain;

% Đồ thị đáp ứng xung
impulseResponse = ifft(pathGain);
timeAxis = (0:length(impulseResponse)-1) / samplingRate;
figure;
plot(timeAxis, 10*log10(impulseResponse));
xlabel('Thời gian (s)');
ylabel('Biên độ (dB)');
title('Đáp ứng xung kênh truyền');

% Đồ thị lấy mẫu kênh
timeAxis = (0:numSamples-1) / samplingRate;
figure;
plot(timeAxis, abs(channelSamples).^2);
xlabel('Thời gain (s)');
ylabel('Độ lớn');
title('Lấy mẫu kênh');