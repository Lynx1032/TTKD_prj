% Các thông số mô phỏng
numSamples = 100; % Số mẫu tín hiệu tạo ra ở đầu phát
snr_dB = -2.5; % Tỉ số SNR theo giai dB

% Tạo mẫu giá trị Guassian phức ngẫu nhiên, bằng với số mẫu tín hiệu phát
h = (randn(1, numSamples) + 1i * randn(1, numSamples)) / sqrt(2);

% Khởi tạo kênh fading phẳng - Rayleigh
n = sqrt(0.5 / 10^(snr_dB/10)) * (randn(1, numSamples) + 1i * randn(1, numSamples));

% Ghép kênh fading phẳng vào tín hiệu
txSignal = randi([0, 1], 1, numSamples);
txSignal_modulated = 2*txSignal - 1; % Điều chế tín hiệu BPSK: 0 -> -1 , 1 -> 1
rxSignal = h .* txSignal_modulated + n; % Tín hiệu nhận được từ việc ghép kênh fading vào tín hiệu phát

% Giải điều chế tín hiệu
rxSignal_demodulated = real(conj(h) .* rxSignal) > 0; % BPSK demodulation

% Tính tỉ lệ lỗi bit (BER)
numErrors = sum(txSignal ~= rxSignal_demodulated);
ber = numErrors / numSamples;

% Vẽ đồ thị mô phỏng kênh flat fading - Rayleigh
figure;
plot(abs(h));
xlabel('Thời gian (theo số mẫu)');
ylabel('Độ lớn của kênh');
title('Kênh Flat-fading dùng phân phối Rayleigh');

% Vẽ đồ thị cường độ tín hiệu nhận tại đầu thu
figure;
plot(10*log10(abs(real(rxSignal)).^2), 'b');
hold on;
plot(10*log10(abs(imag(rxSignal)).^2), 'r');
xlabel('Thời gian (theo số mẫu)');
ylabel('Cường độ tín hiệu (dB)');
title('Tín hiệu nhận tại đầu thu');
legend('Phần thực', 'Phần ảo');

% Vẽ đồ thị tín hiệu truyền, nhận và BER
figure;
t = 1:numSamples;

subplot(2,1,1);
stem(t, txSignal, 'b')
title('Tín hiệu truyền');
xlabel('Mẫu kí hiệu');
ylabel('Giá trị');
hold on;

subplot(2,1,2);
stem(t, rxSignal_demodulated, 'r');
title('Tín hiệu nhận sau giải điều chế');
xlabel('Mẫu kí hiệu');
ylabel('Giá trị');
text(0.45, 1.3, ['BER: ' num2str(ber)], 'Units', 'normalized', 'Fontsize', 22);
hold off;
