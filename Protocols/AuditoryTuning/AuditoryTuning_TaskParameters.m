function AuditoryTuning_TaskParameters(Param)
%
%
%

global S
    S.Names.StateToZero={'CueDelivery','blank'};
    S.Names.Rig=Param.rig;

%% General Parameters    
    S.GUI.Wheel=1;
    S.GUIMeta.Wheel.Style='checkbox';
    S.GUIMeta.Wheel.String='Auto';
    S.GUI.Repetition=3;
    S.GUI.TimePreCue=2;
    S.GUI.TimeCue=0.5; %independent of the actual length of the cue
    S.GUI.TimePostCue=4;
    S.GUIPanels.Timing={'Wheel','Repetition','TimePreCue','TimeCue','TimePostCue'};
    
	S.GUI.WhiteNoise=1;
    S.GUIMeta.WhiteNoise.Style='checkbox';
    S.GUIMeta.WhiteNoise.String='Auto';
	S.GUI.PureTones=1;
    S.GUIMeta.PureTones.Style='checkbox';
    S.GUIMeta.PureTones.String='Auto';
    S.GUI.Sweeps=1;
    S.GUIMeta.Sweeps.Style='checkbox';
    S.GUIMeta.Sweeps.String='Auto';   
    
    S.GUI.SoundSamplingRate=192000;
    
    S.GUIPanels.Sounds={'WhiteNoise','PureTones','Sweeps','SoundSamplingRate'};
    S.GUITabs.GeneralParameters={'Sounds','Timing'};

%% Sounds Parameters   
    S.GUI.SoundDuration_pt=0.5;
	S.GUI.SoundRamp_pt=0;
    S.GUI.LowFreq_pt=4000;
    S.GUI.HighFreq_pt=20000;
    S.GUI.NbOfTones=5;
    S.GUIPanels.PureTones_Properties={'SoundDuration_pt','SoundRamp_pt','LowFreq_pt','HighFreq_pt','NbOfTones'};
     
    S.GUI.SoundDuration_s=0.5;
    S.GUI.LowFreq_s=4000;
    S.GUI.HighFreq_s=20000;
    S.GUIPanels.Sweeps_Properties={'SoundDuration_s','LowFreq_s','HighFreq_s'};
    
    S.GUI.SoundDuration_wn=0.2;
    S.GUI.SoundRamp_wn=0.05;
    S.GUIPanels.WhiteNoise_Properties={'SoundDuration_wn','SoundRamp_wn'};
 
    S.GUITabs.SoundParameters={'PureTones_Properties','Sweeps_Properties','WhiteNoise_Properties'};

%% Nidaq and Photometry
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
    S.GUI.LED1b_Wavelength=470;
    S.GUI.LED1b_Amp=Param.LED1bAmp;
    S.GUI.LED1b_Freq=531;

    S.GUIPanels.Photometry={'Photometry','Modulation','DbleFibers','NidaqDuration','NidaqSamplingRate',...
                            'LED1_Wavelength','LED1_Amp','LED1_Freq',...
                            'LED2_Wavelength','LED2_Amp','LED2_Freq',...
                            'LED1b_Wavelength','LED1b_Amp','LED1b_Freq'};
                        
    S.GUITabs.Photometry={'Photometry'};

%% Online Plots   
    S.GUI.StateToZero=1;
	S.GUIMeta.StateToZero.Style='popupmenu';
    S.GUIMeta.StateToZero.String=S.Names.StateToZero;
    S.GUI.TimeMin=-1;
    S.GUI.TimeMax=2;
    S.GUIPanels.PlotParameters={'StateToZero','TimeMin','TimeMax'};
    
    S.GUI.DecimateFactor=100;
	S.GUI.BaselineBegin=1.5;
    S.GUI.BaselineEnd=2.5;
    S.GUI.NidaqMin=-5;
    S.GUI.NidaqMax=10;
    S.GUI.CueBegin=0;
    S.GUI.CueEnd=0.5;
    S.GUIPanels.PlotNidaq={'DecimateFactor','NidaqMin','NidaqMax','BaselineBegin','BaselineEnd','CueBegin','CueEnd'};
    
    S.GUITabs.OnlinePlot={'PlotNidaq','PlotParameters'};
end
