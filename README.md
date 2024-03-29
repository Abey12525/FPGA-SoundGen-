Top Level Entity -> audioController.vhd ("https://github.com/Abey12525/FPGA-SoundGen-/blob/main/audioController.vhd")  
Audio Generator -> audio_gen.vhd ("https://github.com/Abey12525/FPGA-SoundGen-/blob/main/audio_gen.vhd")
# DE-10 Standard Audio Codec
![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/DE-10.PNG?raw=true)
![alt_text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/WM8731-DE10.PNG)

# I2C Multiplexer 
The DE10-Standard board implements an I2C multiplexer for HPS to access the I2C bus originally owned by FPGA.   
HPS can access Audio CODEC and TV Decoder if and only if the `HPS_I2C_CONTROL` signal is set to high 

![alt_text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/I2C_Diagram.PNG)

# WM8731 Diagram
![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/WM8731.PNG?raw=true)
# Pin Discriptions for WM8731 
![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/WM873_PIN.PNG?raw=true)
# Slave Mode Timing Diagram 
![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/TimingDiagramWM8731.PNG)
![alt_text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/TimingDiagram_Table.PNG)
![alt_text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/TimingDiagram_Table2.PNG)

# Code from audio_gen.vhd
```vhdl
process(aud_clock)
begin 
    if rising_edge(aud_clock) then
        if( aud_scale < 260) then 
            aud_scale <=aud_scale + 1; 
        else 
            data_clock <= not data_clock;
            aud_scale <=0;  
        end if;
        if (bk_count<16) then 
            bk_count<=bk_count+1;
        else
            aud_bk_clock<= not aud_bk_clock; 
            bk_count<=0;
        end if; 
    end if; 
end process;
```

![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/1.jpg?raw=true)
# Code from audio_gen.vhd
```vhdl
        if (bk_count<16) then 
            bk_count<=bk_count+1;
        else
            aud_bk_clock<= not aud_bk_clock; 
            bk_count<=0;

        end if; 
```


![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/2.jpg?raw=true)
# Code from audio_gen.vhd
```vhdl
process(data_clock)
begin 
        if rising_edge(data_clock) then
            if (index<31) then 
                aud_out_bit <= aud_out_sample(sample_index)(index);
                index <= index +1; 
            else
                aud_out_bit <= aud_out_sample(sample_index)(index);
                index <= 0;
                sample_index <= (sample_index + 1) mod ARRAY_SIZE;
            end if;
        end if; 
end process;
````

![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/3.jpg?raw=true)

# Matlab Code for generating 1000 samples 
```matlab
for i =1:1000
    B(i)=sin(2*pi*1000*i/48000);
end
sound(B,48000)
x = dec2bin(B, 32)
```


![alt text](https://github.com/Abey12525/FPGA-SoundGen-/blob/main/TestBenchScreenShots/4.jpg?raw=true)

# Code from audio_gen.vhd
data used to stream to AUD_DACDAT
```vhdl
  type BinArrray is array(0 to 999) of std_logic_vector(31 downto 0);
    signal aud_out_sample: BinArrray :=( "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000"
    ,"11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001",
    "00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111",
    "11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000001","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111100000000","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111","11111111111111111111111111111111");
  
```

# Reference Documents  
DE10-Standard Manuel -> "https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/Boards/DE10-Standard/DE10_Standard_User_Manual.pdf"  
WM8731 Auudio Codec -> "https://cdn.sparkfun.com/datasheets/Dev/Arduino/Shields/WolfsonWM8731.pdf"  
Schematic -> "https://www.rocketboards.org/foswiki/pub/Documentation/DE10Standard/DE10-Standard_Schematic.pdf"  

