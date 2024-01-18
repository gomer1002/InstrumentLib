# InstrumentLib
 
Загрузка данных в векторный генератор сигналов CXG N5166B
```
% % upload to CXG vector generator
CXG_id = 'USB0::0x0957::0x1F01::MY59100546::0::INSTR';
cxg = CXG(CXG_id);
cxg.load_data(tx_chirp, freq, fsamp, pLevel);
```


Считывание данных с осциллографа DSO-X 2002A
```
% % read from DSO-X 2002A oscilloscope
DSOX_id = 'USB0::0x0957::0x179B::MY52447315::0::INSTR';
dsx = DSOX("USB0::0x0957::0x179B::MY52447315::0::INSTR");
dsx.set_razvertka(100e-6);
dsox_fsamp = dsx.get_samplerate();
[preabmle, osc_data] = dsx.read_data();
```


Считывание данных с анализатора сигналов ROHDE&SCHWARZ FSV
```
% % Read data from FSV signal analyzer
fsv_id = "TCPIP::192.168.2.194::INSTR";
fsv = FSV(fsv_id);
[I, Q] = fsv.read_data(2000000, 200000);
```

