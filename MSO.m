classdef MSO
    % MSO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        instrumentId;
    end

    methods
        function obj = MSO(instrumentId)
            if nargin == 1
                obj.instrumentId = instrumentId;
            end
        end

        function instr_ans = rst(obj)
            instr_obj = visadev(obj.instrumentId);
            instr_ans = writeread(instr_obj, "*RST");
        end

        function instr_ans = idn(obj)
            instr_obj = visadev(obj.instrumentId);
            instr_ans = writeread(instr_obj, "*IDN?");
        end

        function autoscale(obj)
            instr_obj = visadev(obj.instrumentId);
            write(instr_obj, ":AUToscale"); disp(writeread(instr_obj, 'SYST:ERR?'));
        end

        
        % считывание данных с первого канала
        function [preamble, data] = read_data(obj)
            instr_obj = visadev(obj.instrumentId);

            % Установка времени ожидания
            writeline(instr_obj, ':RUN'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':ACQuire:MDEPth 10k');
            writeline(instr_obj, ':WAVeform:SOURCE CHAN1');
            writeline(instr_obj, ':WAVeform:MODE RAW');
            writeline(instr_obj, ':WAVeform:FORMAT BYTE');
            pause(0.5)
            writeline(instr_obj, ':STOP');
            pause(0.5)
            writeline(instr_obj, ':WAVeform:DATA?');
            data = readbinblock(instr_obj, 'uint8'); 
            disp(writeread(instr_obj, 'SYST:ERR?'));
            pream_chars = writeread(instr_obj,':WAVeform:PREamble?');
            pream_str = convertCharsToStrings(pream_chars);
            preamble = str2double(split(pream_str, ',').');

            T_points = preamble(3); % количество считанных точек
            T_incr = preamble(5); % горизонтальный инкремент
            T_orig = preamble(6); % горизонтальное смещение
            V_incr = preamble(8); % вертикальный инкремент
            V_orig = preamble(9); % вертикальное смещение
            V_ref = preamble(10); % смещение данных, константа
            data = (osc_data_raw - V_ref - V_orig) .* V_incr;
            time = (1 : T_points) .* T_incr + T_orig;
            
            data = (data - V_ref) .* V_incr;
        end

        % получение частоты семплирования
        function sample_rate = get_samplerate(obj)
            instr_obj = visadev(obj.instrumentId);
            sample_rate = str2double(writeread(instr_obj, ':ACQuire:SRATe?'));
        end

        % установка горизонтальной развертки на деление
        function set_time_per_div(obj, time_div)
            instr_obj = visadev(obj.instrumentId);
            writeline(instr_obj, [':TIMebase:SCALe ', num2str(time_div)]);
        end

        % установка горизонтальной развертки на 10 делений
        function set_time_per_disp(obj, time_disp)
            instr_obj = visadev(obj.instrumentId);
            writeline(instr_obj, [':TIMebase:RANGe ', num2str(time_disp)]);
        end

        % установка вертикальной развертки на деление
        function set_volt_per_div(obj, channel, volt_div)
            instr_obj = visadev(obj.instrumentId);
            writeline(instr_obj, [':CHANnel', num2str(channel), ':SCALe ', num2str(volt_div)]);
        end

        % установка вертикальной развертки на 8 делений
        function set_volt_per_disp(obj, channel, volt_disp)
            instr_obj = visadev(obj.instrumentId);
            writeline(instr_obj, [':CHANnel', num2str(channel), ':RANGe ', num2str(volt_disp)]);
        end
    end
end

