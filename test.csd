<CsoundSynthesizer>
<CsOptions>
-odac -d
-b512
-B2048
</CsOptions>
<CsInstruments>

sr = 96000
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1

; controls
kOct chnget "octave1"
kOct =       2 ^ kOct

;kFreq port    kFreq, 0.1

iCps  cpsmidi
iAmp  ampmidi 0dbfs * 0.3

a1    vco2    iAmp, iCps * kOct
      outs    a1, a1
   
endin

</CsInstruments>
<CsScore>
;f1 0 512 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111

i 1 0 600

</CsScore>
</CsoundSynthesizer>

