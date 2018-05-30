function Oddball_TaskParameters(Param)
%
%
%

global S
    S.Names.Phase={'OddBall','Ctl-0.3','Ctl-0.5'};
    S.Names.Sound={'Sweep','Tones'};
    S.Names.Rig=Param.rig;

%% General Parameters    
    S.GUI.Phase = 1;
    S.GUIMeta.Phase.Style='popupmenu';
    S.GUIMeta.Phase.String=S.Names.Phase;
    S.GUI.MaxTrials=100;
    S.GUI.ITI=1;
    S.GUI.BlockITI=5;
    S.GUIPanels.Task={'Phase','MaxTrials','ITI','BlockITI'};
    
    S.GUI.Wheel=1;
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
    S.GUIPanels.General={'Wheel','Photometry','Modulation','DbleFibers'};
     
    S.GUITabs.General={'General','Task'};

%% Task Parameters
    S.GUI.SoundType=2;
    S.GUIMeta.SoundType.Style='popupmenu';
    S.GUIMeta.SoundType.String=S.Names.Sound;
    S.GUI.SoundDuration=0.100;
    S.GUI.SoundFrequency=10000;
    S.GUI.SoundRamp=0;
    S.GUI.NbOfFreq=1;
    S.GUI.FreqWidth=1;
	S.GUI.SoundSamplingRate=192000;
    S.GUIPanels.Cue={'SoundType','SoundDuration','SoundFrequency','SoundRamp','NbOfFreq','FreqWidth','SoundSamplingRate'};
 
    S.GUITabs.Cue={'Cue'};

%% Nidaq and Photometry
	S.GUI.NidaqDuration=180;
    S.GUI.NidaqSamplingRate=6100;
    S.GUI.LED1_Wavelength=470;
    S.GUI.LED1_Amp=Param.LED1Amp;
    S.GUI.LED1_Freq=211;
    S.GUI.LED2_Wavelength=405;
    S.GUI.LED2_Amp=Param.LED2Amp;
    S.GUI.LED2_Freq=531;
	S.GUI.LED1b_Wavelength=470;
    S.GUI.LED1b_Amp=Param.LED1Amp;
    S.GUI.LED1b_Freq=211;

    S.GUIPanels.Photometry={'NidaqDuration','NidaqSamplingRate',...
                            'LED1_Wavelength','LED1_Amp','LED1_Freq',...
                            'LED2_Wavelength','LED2_Amp','LED2_Freq',...
                            'LED1b_Wavelength','LED1b_Amp','LED1b_Freq'};
                        
    S.GUITabs.Photometry={'Photometry'};
end
