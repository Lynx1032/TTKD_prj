% Thông số mô phỏng
numSymbols = 100;  % Số ký hiệu cần truyền
snr_dB = 10;       % Tỉ số SNR theo giai dB
fadeStdDev = 1;    % Độ lệch chuẩn kênh fading

% Tạo chuỗi ký hiệu - tín hiệu nhị phân ngẫu nhiên
symbols = randi([0 1], 1, numSymbols);

% Điều chế tín hiệu (BPSK)
modulatedSymbols = 2 * symbols - 1;

% Thêm nhiễu Guassian phức vào tín hiệu
snr = 10^(snr_dB/10);  % Chuyển tỉ số SNR từ giai dB về giai tuyến tính
noiseVar = 1 / (2 * snr);  % Phương sai nhiễu
noise = sqrt(noiseVar/2) * (randn(1, numSymbols) + 1i * randn(1, numSymbols));

% Khởi tạo các thông số kênh fading phẳng
fadingChannel = (randn(1, numSymbols) + 1i * randn(1, numSymbols)) * fadeStdDev;

% Nhân chập và thêm nhiễu vào tín hiệu nhận được
receivedSymbols = modulatedSymbols .* fadingChannel + noise;

% Giải điều chế tín hiệu nhận (BPSK)
demodulatedSymbols = real(receivedSymbols) > 0;

% Tính tỉ lệ lỗi bit (BER)
ber = sum(demodulatedSymbols ~= symbols) / numSymbols;

% Vẽ đồ thị
subplot(3,1,1);
stem(real(modulatedSymbols), 'k');
xlabel('Vị trí ký hiệu');
ylabel('Giá trị ký hiệu');
title('Tín hiệu truyền');
grid on;
hold on;

subplot(3,1,2);
stem(real(receivedSymbols), 'r');
xlabel('Vị trí ký hiệu');
ylabel('Giá trị ký hiệu');
title('Tín hiệu nhận');
grid on;
hold on;

subplot(3,1,3);
stem(real(demodulatedSymbols), 'b');
xlabel('Vị trí ký hiệu');
ylabel('Giá trị ký hiệu');
title('Giải điều chế');
grid on;
hold off;
