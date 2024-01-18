classdef FSV
    properties
        instrumentId
    end
    methods
        % constructor
        function obj = FSV(instrumentId)
            if nargin == 1
                obj.instrumentId = instrumentId;
            end
        end

        function [I, Q] = read_data(obj, SRate, Count, TrigMode, TrigSope, Pretrigger, FilterType)  
            if nargin < 7
                FilterType = 'NORMal';
            end
            if nargin < 6
                Pretrigger = 0;
            end
            if nargin < 5
                TrigSope = 'POSitive';
            end
            if nargin < 4
                TrigMode = 'IMMediate';
            end
            if nargin < 3
                Count = 200000;
            end
            if nargin < 2
                SRate = 2000000;
            end
            BWID = 50000;
            IQinput = 'RF';
            
%             rohde_schwartz_ip = "TCPIP::192.168.2.194::INSTR";
            instr_obj = visadev(obj.instrumentId);
            
            fprintf("OPC = %s\n", writeread(instr_obj, "*CLS;*OPC?"))
            fprintf("IDN = %s\n", writeread(instr_obj, "*IDN?"))
            
            % BWID = writeread(instr_obj, 'TRAC:IQ:BWID?')
            fprintf("OPT = %s\n", writeread(instr_obj, '*OPT?'));
            fprintf("SYST:ERR:CLE:ALL OPC = %s\n", writeread(instr_obj, 'SYST:ERR:CLE:ALL;*OPC?'));
            fprintf("INST:NSEL = %s\n", writeread(instr_obj, "INST:NSEL?;*WAI"));
            fprintf("UNIT:POW DBM OPC = %s\n",writeread(instr_obj, "UNIT:POW DBM;*OPC?"));
            fprintf("DISP:TRAC:Y:RLEV = %s\n",writeread(instr_obj, "DISP:TRAC:Y:RLEV?;*WAI"));
            freq = writeread(instr_obj, "FREQ:CENT?;*WAI");
            fprintf("FREQ:CENT = %s\n",freq);
            fprintf("INP:ATT = %s\n",writeread(instr_obj, "INP:ATT?;*WAI"));
            fprintf("TRAC:IQ ON OPC = %s\n",writeread(instr_obj, "TRAC:IQ ON;*OPC?"));
            fprintf("TRAC:IQ:DATA:FORM IQP OPC = %s\n",writeread(instr_obj, "TRAC:IQ:DATA:FORM IQP;*OPC?"));
            fprintf("SYST:ERR = %s\n",writeread(instr_obj, "SYST:ERR?"));
            fprintf("TRAC:IQ:SET OPC = %s\n",writeread(instr_obj, "TRAC:IQ:SET "+FilterType+","+num2str(BWID)+","+num2str(SRate)+","+TrigMode+","+TrigSope+","+num2str(Pretrigger)+","+num2str(Count)+";*OPC?"));
            fprintf("SYST:ERR = %s\n",writeread(instr_obj, "SYST:ERR?"));
            fprintf("FORM REAL, 32 OPC = %s\n",writeread(instr_obj, "FORM REAL, 32;*OPC?"));
            write(instr_obj, "TRAC:IQ:DATA?");
            raw_data = readbinblock(instr_obj, 'single');
            I = raw_data(1:2:end);
            Q = raw_data(2:2:end);
                        
            fprintf("TRAC:IQ OFF OPC = %s\n\n",writeread(instr_obj, "TRAC:IQ OFF;*OPC?"))
        end
    end
end





