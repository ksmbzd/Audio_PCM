# Audio_PCM
 Audio Pulse Code Modulation - Using MATLAB


# AudioPCM
 Pulse Code Modulation - Using MATLAB

Audio Pulse Code Modulation
This repository contains a MATLAB script for Audio Pulse Code Modulation (PCM). 

The code is a complete implementation of audio sampling, quantization, encoding, decoding, and reconstruction using PCM.

# Description
PCM is a digital representation of an analog signal in which the amplitude of the signal is sampled regularly at uniform intervals, and each sample is quantized to the nearest value within a range of digital steps. 

This code provides a complete workflow for audio processing using PCM, including selecting an audio file, processing the audio file, plotting various signals, and playing the original and reconstructed audio.

# Usage
1. Download the repository and open the audio_pcm.m file in MATLAB.
2. Run the script in MATLAB.
3. Use the GUI provided to perform various tasks such as selecting an audio file, setting the PCM parameters, and plotting various signals.
4. You can play the original and reconstructed audio using the GUI.

# Functions
The code contains several functions for different tasks:

- push: Sets the PCM parameters.
- push1: Selects an audio file and processes it using PCM.
- push2: Plots the input signal.
- push3: Plots the sampled signal.
- push4: Plots the quantized signal.
- push5: Plots the encoded signal.
- push6: Plays the original audio.
- push7: Plots the decoded signal.
- push8: Plays the reconstructed audio.
- push9: Quits the application.
- push10: Plots all signals in one figure.
- push11: Plots the error difference between the original and reconstructed signals.

## Result

![Interface Screenshot](https://raw.githubusercontent.com/ksmbzd/Audio_PCM/main/results/interface.PNG)

This is the interface of our application. From here, you can choose the input audio file and start processing it.

## Visualizing All Signals

![All Signals Screenshot](https://raw.githubusercontent.com/ksmbzd/Audio_PCM/main/results/all_signals.PNG)

This image represents the visualization of all signals processed by our application. 



