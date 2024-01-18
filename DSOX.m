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
        
        function [preamble, data] = read_data(obj)
            instr_obj = visadev(obj.instrumentId);

            % Установка размера буфера
%             OSCI_Obj.InputBufferSize = 1000000;
            % Установка времени ожидания
            instr_obj.Timeout = 5.0;
            write(instr_obj, '*CLS'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':STOP'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':WAVeform:SOURCE CHAN1'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':TIMEBASE:MODE MAIN'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':ACQUIRE:TYPE NORMAL'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':ACQUIRE:COUNT 4'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':WAVeform:POINTS:MODE RAW'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':WAVeform:POINTS 500000'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':WAVeform:FORMAT WORD'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':WAVeform:BYTEORDER LSBFirst'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':DIGITIZE CHAN1'); disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':WAVeform:DATA?');
            data = readbinblock(instr_obj, 'uint16'); disp(writeread(instr_obj, 'SYST:ERR?'));
            pream_chars = writeread(instr_obj,':WAVeform:PREamble?');
            pream_str = convertCharsToStrings(pream_chars);
            preamble = str2double(split(pream_str, ',').');

            points = preamble(3);
            V_incr = preamble(8);
            V_ref = preamble(10);
            
            data = (data - V_ref) .* V_incr;
         end

         function sample_rate = get_samplerate(obj)
            instr_obj = visadev(obj.instrumentId);
            sample_rate = str2double(writeread(instr_obj, ':ACQuire:SRATe?'));
         end

         function set_razvertka(obj, time_div)
            instr_obj = visadev(obj.instrumentId);
            time_disp = time_div*10;
            write(instr_obj, [':TIMebase:RANGe ', num2str(time_disp)]);
         end
    end
end

