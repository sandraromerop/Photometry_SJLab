function LEDTuning_TaskParameters(Param)
%
%
%

global S
    S.Names.StateToZero={'CueDelivery','blank'};
    S.Names.Rig=Param.rig;

%% General Parameters    
    S.GUI.Repetition=3;
    S.GUI.TimePreCue=2;
    S.GUI.TimeCue=0.5; %independent of the actual length of the cue
    S.GUI.TimePostCue=3;
    S.GUIPanels.Timing={'Repetition','TimePreCue','TimeCue','TimePostCue'};
    
    S.GUI.SoundDuration=0.2;
    S.GUI.SoundRamp=0.05;
	S.GUI.SoundSamplingRate=192000;    
    S.GUIPanels.WhiteNoise_Properties={'SoundDuration','SoundRamp','SoundSamplingRate'}; 
    
	S.GUI.LED1_Amp_LowWatt=8;
    S.GUI.LED1_Amp_Low=0.2;
    S.GUI.LED1_Amp_HighWatt=30;
    S.GUI.LED1_Amp_High=0.5;
    S.GUI.NbOfPower=4;
    S.GUIPanels.LED_PowerSequence={'LED1_Amp_LowWatt','LED1_Amp_Low','LED1_Amp_HighWatt','LED1_Amp_High','NbOfPower'};
    
    S.GUITabs.GeneralParameters={'WhiteNoise_Properties','LED_PowerSequence','Timing'};

%% Nidaq and Photometry
 	S.GUI.Wheel=0;
    S.GUIMeta.Wheel.Style='checkbox';
    S.GUIMeta.Wheel.String='Auto';
 	S.GUI.Photometry=1;
    S.GUIMeta.Photometry.Style='checkbox';
    S.GUIMeta.Photometry.String='Auto';
    S.GUI.Modulation=1;
    S.GUIMeta.Modulation.Style='checkbox';
    S.GUIMeta.Modulation.String='Auto';
	S.GUI.DbleFibers=0;
    S.GUIMeta.DbleFibers.Style='checkbox';
    S.GUIMeta.DbleFibers.String='Auto';
	S.GUI.NidaqDuration=5;
    S.GUI.NidaqSamplingRate=6100;
    S.GUI.LED1_Wavelength=490;
    S.GUI.LED1_Amp=Param.LED1Amp;
    S.GUI.LED1_Freq=211;
    S.GUI.LED2_Wavelength=405;
    S.GUI.LED2_Amp=Param.LED2Amp;
    S.GUI.LED2_Freq=531;

    S.GUIPanels.Photometry={'Wheel','Photometry','Modulation','DbleFibers','NidaqDuration','NidaqSamplingRate',...
                            'LED1_Wavelength','LED1_Amp','LED1_Freq',...
                            'LED2_Wavelength','LED2_Amp','LED2_Freq'};
                        
    S.GUITabs.Photometry={'Photometry'};

%% Online Plots   
    S.GUI.StateToZero=1;
	S.GUIMeta.StateToZero.Style='popupmenu';
    S.GUIMeta.StateToZero.String=S.Names.StateToZero;
    S.GUI.TimeMin=-1;
    S.GUI.TimeMax=2;
    S.GUIPanels.PlotParameters={'StateToZero','TimeMin','TimeMax'};
    
    S.GUI.DecimateFactor=1;
	S.GUI.BaselineBegin=1.5;
    S.GUI.BaselineEnd=2.5;
    S.GUI.NidaqMin=-0.5;
    S.GUI.NidaqMax=1;
    S.GUI.CueBegin=0;
    S.GUI.CueEnd=0.5;
    S.GUIPanels.PlotNidaq={'DecimateFactor','NidaqMin','NidaqMax','BaselineBegin','BaselineEnd','CueBegin','CueEnd'};
    
    S.GUITabs.OnlinePlot={'PlotNidaq','PlotParameters'};
end
