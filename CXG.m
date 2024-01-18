classdef CXG
%       methods:
%       

    properties
        instrumentId
    end

%     methods (Static)
    methods
        % constructor
        function obj = CXG(instrumentId)
            if nargin == 1
                obj.instrumentId = instrumentId;
            end
        end

        % load ARB data to instrument
        function load_data(obj, IQData, frequency, sampleRate, pLevel, ArbFileName)
            if nargin < 6
                ArbFileName = 'IQ_Data';
            end
            if nargin < 5
                pLevel = -10;
            end
            if nargin < 4
                sampleRate = 10e6;
            end
            if nargin < 3
                frequency = 50e6;
            end
            if nargin < 2
                error('Нужно передать как минимум один аргумент');
            end

            instr_obj = visadev(obj.instrumentId);

            % Set up the output buffer size to hold at least the number of bytes we are
            % transferring
            % Set output to Big Endian with TCPIP objects, because we do the interleaving 
            % and the byte ordering in code. For VISA or GPIB objecs, use littleEndian.

            % Adjust the timeout to ensure the entire waveform is downloaded before a
            % timeout occurs
            instr_obj.Timeout = 5.0;

            % Seperate out the real and imaginary data in the IQ Waveform
            wave = [real(IQData); imag(IQData)];
            wave = wave(:)';    % transpose the waveform

            % normalization
            wave = wave / max(abs(wave));

            %scale
            scale = 2^14;
%             scale = 2^15-1;
            wave = round(wave * scale);

            % preserve bit pattern
            modval = 2^16;
            wave = uint16(mod(modval + wave, modval));

            % swap bytes
            wave = bitor(bitshift(wave, -8), bitshift(wave, 8));

            % Some more commands to make sure we don't damage the instrument
            write(instr_obj, '*CLS');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':OUTPut:STATe OFF');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':SOURce:RADio:ARB:STATe ON');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':OUTPut:MODulation:STATe ON');
            disp(writeread(instr_obj, 'SYST:ERR?'));

            % Set the instrument source freq
            write(instr_obj, ['RADio:ARB:SCLock:RATE ', num2str(sampleRate)]);
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ['SOURce:FREQuency ', num2str(frequency)]);
            disp(writeread(instr_obj, 'SYST:ERR?'));
            % Set the source power
            write(instr_obj, ['POWer ', num2str(pLevel)]);
            disp(writeread(instr_obj, 'SYST:ERR?'));

            % convert data to uint8
            wave = typecast(wave, 'uint8');

            % Write the data to the instrument
            n = size(wave);
            SENT_Bytes = num2str(n(2)); 
            disp(['Starting Download of ' SENT_Bytes ' Points'])

            % the number of decimal digits present in B
            A = num2str(length(SENT_Bytes));
            % a decimal number specifying the number of data bytes to follow in C
            B = SENT_Bytes;
            % the actual binary waveform data
            C = wave;

            file_path = [':MMEM:DATA "WFM1:' ArbFileName '"'];
            data_block = ['#' A B C];
            command = [file_path ',' data_block]; 
            write(instr_obj, command);
            disp(writeread(instr_obj, 'SYST:ERR?'));

            % Some more commands to start playing back the signal on the instrument
            write(instr_obj, ':SOURce:RADio:ARB:STATe ON');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':OUTPut:MODulation:STATe ON');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, 'POW:ALC OFF');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, ':OUTPut:STATe ON');
            disp(writeread(instr_obj, 'SYST:ERR?'));
            write(instr_obj, [':SOURce:RADio:ARB:WAV "ARBI:' ArbFileName '"']);
            disp(writeread(instr_obj, 'SYST:ERR?'));

            % Close the connection to the instrument
            delete(instr_obj); clear instr_obj
        end
    end
end