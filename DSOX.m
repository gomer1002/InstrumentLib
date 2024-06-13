classdef DSOX
    %DSOX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        instrumentId;
    end

    methods
        function obj = DSOX(instrumentId)
            if nargin == 1
                obj.instrumentId = instrumentId;
            end
        end

        function instr_ans = idn(obj)
            instr_obj = visadev(obj.instrumentId);
            instr_ans = writeread(instr_obj, "*IDN?");
        end
        
        % считывание данных с первого канала
        function [preamble, data] = read_data(obj)
            instr_obj = visadev(obj.instrumentId);

            % Установка времени ожидания
            instr_obj.Timeout = 5.0;
            writeline(instr_obj, '*CLS'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':WAVeform:SOURCE CHAN1'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':TIMEBASE:MODE MAIN'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':ACQUIRE:TYPE NORMAL'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':ACQUIRE:COUNT 4'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':WAVeform:POINTS:MODE RAW'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':WAVeform:POINTS MAX'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':WAVeform:FORMAT WORD'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':WAVeform:BYTEORDER LSBFirst'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':DIGITIZE CHAN1'); disp(writeread(instr_obj, 'SYST:ERR?'));
            writeline(instr_obj, ':WAVeform:DATA?');
            data = readbinblock(instr_obj, 'uint16'); disp(writeread(instr_obj, 'SYST:ERR?'));
            pream_chars = writeread(instr_obj,':WAVeform:PREamble?');
            pream_str = convertCharsToStrings(pream_chars);
            preamble = str2double(split(pream_str, ',').');

            data_format =       preamble(1);
            acquire_type =      preamble(2);
            data_points =       preamble(3);
            acquire_count =     preamble(4);
            x_increment =       preamble(5);
            x_origin =          preamble(6);
            x_reference =       preamble(7);
            y_increment =       preamble(8);
            y_origin =          preamble(9);
            y_reference =       preamble(10);
            
            data = (data - y_reference) .* y_increment;
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

