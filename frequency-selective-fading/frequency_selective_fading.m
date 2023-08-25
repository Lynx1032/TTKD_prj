% Thông số mô phỏng
numSymbols = 100;      % Số lượng ký hiệu - mẫu thử
numSubcarriers = 50;    % Số lượng sóng mang con
symbolRate = 10^2;       % Tốc độ truyền ký hiệu - tính bằng Hz
channelBandwidth = 10^3; % Băng thông kênh truyền - tính bằng Hz

% Khởi tạo nguồn dữ liệu truyền - mỗi sóng mang con sẽ truyền số ký hiệu = tống ký hiệu/số sóng mang
bits = randi([0, 1], numSubcarriers, numSymbols/numSubcarriers);
plt_bits = reshape(transpose(bits), [1, numSymbols]);

% Điều chế BPSK
symbols = zeros(numSubcarriers, numSymbols/numSubcarriers);
for i = 1:numSubcarriers
    symbols(i, :) = 2*(bits(i, :)) - 1;
end

% Khởi tạo kênh
fadingCoefficients = (randn(numSubcarriers, numSymbols/numSubcarriers) + 1i * randn(numSubcarriers, numSymbols/numSubcarriers)) / sqrt(2);

% Khởi tạo đáp ứng tần số cho kênh
frequencyResponse = zeros(numSubcarriers, numSymbols/numSubcarriers);
for i = 1:numSubcarriers
    magnitude = rand(1, numSymbols/numSubcarriers);
    phase = 2 * pi * rand(1, numSymbols/numSubcarriers);
    frequencyResponse(i, :) = magnitude .* exp(1i * phase);
end

% Thêm kênh truyền vào đường truyền tín hiệu
receivedSymbols = zeros(numSubcarriers, numSymbols/numSubcarriers);
for i = 1:numSymbols/numSubcarriers
    receivedSymbols(:, i) = symbols(:, i) .* frequencyResponse(:, i) .* fadingCoefficients(:, i);
end

% Giải điều chế BPSK
receivedSymbols_ts = reshape(transpose(receivedSymbols), [1, numSymbols]);
receivedSymbols_demodulation = real(receivedSymbols_ts) > 0;

% Tính tỉ lệ lỗi bit (BER)
numErrors = sum(plt_bits ~= receivedSymbols_demodulation);
ber = numErrors / numSymbols;

% Vẽ đồ thị đáp ứng
figure;
subplot(2, 1, 1);
plot(1:numSubcarriers, abs(frequencyResponse(:, 1)));
title('Đáp ứng độ lớn kênh');
xlabel('Số sóng mang con');
ylabel('Độ lớn của kênh');
grid on;

subplot(2, 1, 2);
plot(1:numSubcarriers, angle(frequencyResponse(:, 1)));
title('Đáp ứng pha kênh');
xlabel('Số sóng mang con');
ylabel('Pha của kênh');
grid on;

% Plot the received symbols
figure;
plot(1:numSubcarriers, 10*log10(abs(real(receivedSymbols(:, 1)).^2)), 'b');
hold on;
plot(1:numSubcarriers, 10*log10(abs(imag(receivedSymbols(:, 1)).^2)), 'r');
xlabel('Số sóng mang con');
ylabel('Cường đô tín hiệu nhận tại đầu thu (dB)');
title('Cường độ tín hiệu tại đầu thu');
legend('Phần thực','Phần ảo');
hold off;
grid on;

% Vẽ đồ thị tín hiệu truyền, nhận và BER
figure;
t = 1:numSymbols;

subplot(2,1,1);
stem(t, plt_bits, 'b')
title('Tín hiệu truyền');
xlabel('Mẫu kí hiệu');
ylabel('Giá trị');
hold on;

subplot(2,1,2);
stem(t, receivedSymbols_demodulation, 'r');
title('Tín hiệu nhận sau giải điều chế');
xlabel('Mẫu kí hiệu');
ylabel('Giá trị');
text(0.45, 1.3, ['BER: ' num2str(ber)], 'Units', 'normalized', 'Fontsize', 22);
hold off;
