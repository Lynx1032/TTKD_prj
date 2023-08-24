% Thông số mô phỏng
numSamples = 100;           % Số mẫu thử
fadeDuration = 1;           % Độ rộng khối phẳng (tính theo mẫu thử)
K = 10;                     % Hệ số K Rician
SNRdB = -2.5;                 % Tỉ số SNR theo giai dB

% Khởi tạo kênh phẳng Rician
h = sqrt(0.5*(1 + K/(K+1))) * ones(1, numSamples); % Thành phần LoS
h = h + sqrt(0.5/(K+1)) * (randn(1, numSamples) + 1i*randn(1, numSamples)); % Thành phần phân phối

% Khởi tạo tín hiệu phát theo số mẫu
txSignal = randi([0, 1], 1, numSamples);

% Điều chế tín hiệu BPSK: 0 -> -1 , 1 -> 1
txSignal_modulated = 2*txSignal - 1;

% Thêm nhiễu AWGN
SNR = 10^(SNRdB/10);            % Đổi SNR từ dB sang tuyến tính
noiseVar = 1 / (2 * SNR);       % Phương sai nhiễu
noise = sqrt(noiseVar/2) * (randn(1, numSamples) + 1i*randn(1, numSamples)); % Guassian phức
rxSignal = h .* txSignal_modulated + noise;   % Tín hiệu nhận tại đầu thu sau khi thêm nhiễu

% Giải điều chế tín hiệu
rxSignal_demodulated = real(conj(h) .* rxSignal) > 0;

% Tính tỉ lệ lỗi bit (BER)
numErrors = sum(txSignal ~= rxSignal_demodulated);
ber = numErrors / numSamples;

% Vẽ đồ thị mô phỏng kênh flat fading - Rician
figure;
plot(abs(h));
xlabel('Thời gian (theo số mẫu)');
ylabel('Độ lớn của kênh');
title('Kênh Flat-fading dùng phân phối Rician');

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
