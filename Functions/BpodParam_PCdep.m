function Param=BpodParam_PCdep()

switch getenv('computername')
    case 'LARS-HP'
        Param.rig='Photometry1';
        Param.nidaqDev='Dev1';
        Param.LED1Amp=0.5;
        Param.LED2Amp=0;
        Param.LED1bAmp=0;

end
end