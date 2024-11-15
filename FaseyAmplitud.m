% Seleccionar archivos para frecuencia de corte de 1000 Hz
[files_1000, path_1000] = uigetfile('*.xlsx', 'Selecciona los archivos Excel para 1000 Hz', 'MultiSelect', 'on');

% Seleccionar archivos para frecuencia de corte de 3000 Hz
[files_3000, path_3000] = uigetfile('*.xlsx', 'Selecciona los archivos Excel para 3000 Hz', 'MultiSelect', 'on');

% Verificar si se seleccionaron múltiples archivos y convertirlos a celdas si solo se seleccionó un archivo
if ischar(files_1000)
    files_1000 = {files_1000};
end
if ischar(files_3000)
    files_3000 = {files_3000};
end

% Frecuencias originales específicas para cada corte
frecuencias_originales_1000 = 500:100:1500; % Desde 500 Hz hasta 1500 Hz, con incrementos de 500 Hz
frecuencias_originales_3000 = 1500:100:4500; % Desde 1500 Hz hasta 4500 Hz, con incrementos de 1000 Hz

% Inicializar variables para almacenar los resultados
razon_amplitud_1000 = zeros(1, length(files_1000));
razon_amplitud_3000 = zeros(1, length(files_3000));
frecuencia_relativa_1000 = zeros(1, length(files_1000));
frecuencia_relativa_3000 = zeros(1, length(files_3000));
diferencia_fase_1000 = zeros(1, length(files_1000));  % Para almacenar la diferencia de fase
diferencia_fase_3000 = zeros(1, length(files_3000));  % Para almacenar la diferencia de fase

% Definir frecuencias de corte
frecuencia_corte_1000 = 1000;
frecuencia_corte_3000 = 3000;

% Procesar archivos para frecuencia de corte de 1000 Hz
for i = 1:length(files_1000)
    % Leer datos del archivo
    filename = fullfile(path_1000, files_1000{i});
    data = readmatrix(filename);
    
    % Extraer columnas de tiempo, señal original y señal filtrada
    time = data(:, 1);            % Tiempo en ms
    signal_original = data(:, 2); % Señal original en Volts
    signal_filtered = data(:, 3); % Señal filtrada en Volts
    
    % Ajustar el vector de tiempo para que comience en cero
    time = time - time(1);
    
    % Calcular la frecuencia de muestreo
    fs = 1 / (time(2) - time(1)) * 1000; % Convertir de ms a Hz
    
    % Calcular la FFT de ambas señales
    Y_original = fft(signal_original);
    Y_filtered = fft(signal_filtered);
    
    % Obtener la frecuencia fundamental correspondiente a la señal original
    N = length(time); % Número de puntos
    f = (0:N-1) * (fs / N); % Vector de frecuencias
    [~, idx_fundamental] = min(abs(f - frecuencias_originales_1000(i))); % Índice de frecuencia fundamental
    
    % Calcular la amplitud en la frecuencia fundamental
    amp_original = abs(Y_original(idx_fundamental));
    amp_filtered = abs(Y_filtered(idx_fundamental));
    
    % Calcular la razón de amplitud
    razon_amplitud_1000(i) = amp_filtered / amp_original;
    
    % Calcular la frecuencia relativa (frecuencia de señal / frecuencia de corte)
    frecuencia_relativa_1000(i) = frecuencias_originales_1000(i) / frecuencia_corte_1000;
    
    % Calcular la fase de ambas señales
    phase_original = angle(Y_original);
    phase_filtered = angle(Y_filtered);
    
    % Calcular la diferencia de fase
    phase_diff = phase_filtered(idx_fundamental) - phase_original(idx_fundamental);
    
    % Convertir la diferencia de fase a grados
    phase_diff_degrees = rad2deg(phase_diff);
    
    % Almacenar la diferencia de fase
    diferencia_fase_1000(i) = phase_diff_degrees;
end

% Procesar archivos para frecuencia de corte de 3000 Hz
for i = 1:length(files_3000)
    % Leer datos del archivo
    filename = fullfile(path_3000, files_3000{i});
    data = readmatrix(filename);
    
    % Extraer columnas de tiempo, señal original y señal filtrada
    time = data(:, 1);            % Tiempo en ms
    signal_original = data(:, 2); % Señal original en Volts
    signal_filtered = data(:, 3); % Señal filtrada en Volts
    
    % Ajustar el vector de tiempo para que comience en cero
    time = time - time(1);
    
    % Calcular la frecuencia de muestreo
    fs = 1 / (time(2) - time(1)) * 1000; % Convertir de ms a Hz
    
    % Calcular la FFT de ambas señales
    Y_original = fft(signal_original);
    Y_filtered = fft(signal_filtered);
    
    % Obtener la frecuencia fundamental correspondiente a la señal original
    N = length(time); % Número de puntos
    f = (0:N-1) * (fs / N); % Vector de frecuencias
    [~, idx_fundamental] = min(abs(f - frecuencias_originales_3000(i))); % Índice de frecuencia fundamental
    
    % Calcular la amplitud en la frecuencia fundamental
    amp_original = abs(Y_original(idx_fundamental));
    amp_filtered = abs(Y_filtered(idx_fundamental));
    
    % Calcular la razón de amplitud
    razon_amplitud_3000(i) = amp_filtered / amp_original;
    
    % Calcular la frecuencia relativa (frecuencia de señal / frecuencia de corte)
    frecuencia_relativa_3000(i) = frecuencias_originales_3000(i) / frecuencia_corte_3000;
    
    % Calcular la fase de ambas señales
    phase_original = angle(Y_original);
    phase_filtered = angle(Y_filtered);
    
    % Calcular la diferencia de fase
    phase_diff = phase_filtered(idx_fundamental) - phase_original(idx_fundamental);
    
    % Convertir la diferencia de fase a grados
    phase_diff_degrees = rad2deg(phase_diff);
    
    % Almacenar la diferencia de fase
    diferencia_fase_3000(i) = phase_diff_degrees;
end

% Graficar las razones de amplitud y la diferencia de fase en función de la frecuencia relativa para ambas frecuencias de corte
figure;
subplot(2, 1, 1); % Primer subplot para razón de amplitud
plot(frecuencia_relativa_1000, razon_amplitud_1000, '-o', 'DisplayName', 'Filtro HP 1000 Hz');
hold on;
plot(frecuencia_relativa_3000, razon_amplitud_3000, '-x', 'DisplayName', 'Filtro HP 3000 Hz');
xlabel('Frecuencia Relativa (f_{señal} / f_{corte})');
ylabel('Razón de Amplitud (Filtrada / Original)');
title('Razón de Amplitud vs Frecuencia Normalizada');
legend;
grid on;
hold off;

subplot(2, 1, 2); % Segundo subplot para diferencia de fase
plot(frecuencia_relativa_1000, diferencia_fase_1000, '-o', 'DisplayName', 'Filtro HP 1000 Hz');
hold on;
plot(frecuencia_relativa_3000, diferencia_fase_3000, '-x', 'DisplayName', 'Filtro HP 3000 Hz');
xlabel('Frecuencia Relativa (f_{señal} / f_{corte})');
ylabel('Diferencia de Fase (grados)');
title('Diferencia de Fase vs Frecuencia Normalizada');
legend;
grid on;
hold off;
