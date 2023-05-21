%%%%%%%%%%%%%%%%%%%%%%%%        AUDIO PCM      %%%%%%%%%%%%%%%%%%%%%%%
                           %* Kassem Bou Zeid *%
                             %www.infaix.com%
%%%%%%%%%%%%%%%%%%%%%%%%        Copyright      %%%%%%%%%%%%%%%%%%%%%%%
function AUDIOPcm
clc 
close all
clear all

figure;

disptext = uicontrol('style','text','position',[400 570 500 50],'BackgroundColor',[0.94 0.94 0.94],'String','AUDIO PCM',...
    'FontSize',30,'FontWeight','bold');


out2 = uicontrol('style', 'text', 'position', [800 50 390 20]);
colspec1 = [0 0 0];
set(out2, 'BackgroundColor', [0.94 0.94 0.94]); 
set(out2, 'FontSize', 12);
colspec2 = [0 0 0];
set(out2, 'ForegroundColor', colspec2);
set(out2, 'FontWeight', 'bold');
set(out2, 'string', 'Kassem Bou Zeid');


input_parameter = uicontrol('style','pushbutton','position',[200 500 100 30],'string','Input Parameter','callback',{@push});
select_music  = uicontrol('style','pushbutton','position',[200 450 100 30],'string','Select & Process ','callback',{@push1});
plot_input_signal = uicontrol('style','pushbutton','position',[200 400 100 30],'string','Plot Input Signal','callback',{@push2});
sample = uicontrol('style','pushbutton','position',[200 350 100 30],'string','Sample','callback',{@push3});
quantize = uicontrol('style','pushbutton','position',[200 300 100 30],'string','Quantize','callback',{@push4});
encode = uicontrol('style','pushbutton','position',[200 250 100 30],'string','Encode','callback',{@push5});
playoriginal = uicontrol('style','pushbutton','position',[200 200 100 30],'string','Play Original Music','callback',{@push6});
decoder = uicontrol('style','pushbutton','position',[200 150 100 30],'string','Decode','callback',{@push7});
playdecoder = uicontrol('style','pushbutton','position',[200 100 100 30],'string','Play Decode','callback',{@push8});
clearall = uicontrol('style','pushbutton','position',[200 50 100 30],'string','Quit','callback',{@push9});
Plotall = uicontrol('style','pushbutton','position',[500 330 100 30],'string','Plot All','callback',{@push10});
error = uicontrol('style','pushbutton','position',[500 400 100 30],'string','Error','callback',{@push11});

%axisbg1 = axes('Position',[0 0 1 1 ]);
%imshow('')
%axisbg2 = axes('Position',[0.6 0.8 0.35 0.2]);
%imshow('')

    global fs;
    global input_sig;  
    global sampled_signal;
    global quantiz_signal;
    global word_length;
    global scrsz;
    global dec_val;
    global vmin;
    global vmax;
    global lsb;
    global orgnal_sampl_freq;
    global reconst_sig;
    h1='o';
    h2='o';
    h3='o';
    h4='o';
    h5='o';

function push(~, ~)
%==========================PCM parameters=========================
prompt={'Enter n value for n-bit PCM','Enter number of samples/sec'};
dlg_title='PCM Parameters';
num_lines=1;
def={'8','8000'};
options.Resize='on';
answer=inputdlg(prompt,dlg_title,num_lines,def,options);
% Conversion from string to number required
word_length=str2double(answer{1});
fs=str2double(answer{2});
end
%=============To generate input signal================================

function push1(~, ~)

%word_length=4
%fs=8000
[fn, kassemBouzeid]=uigetfile('.M4a','select Music ');
[input_sig, orgnal_sampl_freq]=audioread(strcat(kassemBouzeid, fn));
disp('Processing input data........')
tic;

%========Used later to create a window using 'figure' function========
scrsz = get(0,'ScreenSize');    %get dimension of screen
%=================================================================
[a,~]=size(input_sig);
time=(a/orgnal_sampl_freq);
fs=round(fs*time);
%===================SAMPLING======================================
samples=round(linspace(1,a,fs));  %To get n samples I divide data by n-1 so to get n points(samples)                                           
sampled_signal=zeros(1,fs);       %Input signal divided into samples with each sample separated by sample_size                                        
index=1;

for i=samples
    sampled_signal(index)=input_sig(i);
	index=index+1;
end
%=================End of Sampling=================================

%=================Begin Quantization==============================
vmax=0.5;                   %get upper limit of quantization
vmin=-0.5;                  %get lower limit of quantization
lsb=(vmax-vmin)/((2^word_length)-1);     %concept-if I divide a line segment in 2 parts  we get three points
levels=vmin:lsb:vmax;                    %generate level vector

partition=(vmin-(.5*lsb)):lsb:(vmax+(.5*lsb));  %introduce +(-)1/2*LSB into levels
[~,index_levels]=size(levels);

%========generate quantized value out of sample data =========

quantiz_signal=zeros(1,index-1);    %index-1??? see previous for loop, there index value exceeds size of sampled_signal in the last iteration

for i=1:index-1                     %to increment the sampled_signal vector
 
    for j=1:index_levels                         %to increment the 'partition' & 'levels' vectors check if input is less than vmin
        if (sampled_signal(i)<partition(1))      %Compare sample with upper and lower partition of a level
                                                 %if sample is between partitions, give that value of level to 
                                                 %the quantize signal array at the index equal to that of sample.
             quantiz_signal(i)=vmin;             %This will generate quantized array of same size of samples array
             bin_val=dec2bin(0,word_length);     % example In 4-bit PCM quantize level 1 corresponds to 0x0 & level 16 is eqv to 0xf         
          % to arrange string bits column  and put it at appropriate index of data stream
              val_rearrange=bin_val(:);                %Make it i:1 matrix 
              rearrange_index=((i-1)*word_length)+1;   %like if I have for 4 bit insert at 1st,5th,9th,13th..index
              data_stream(rearrange_index:(rearrange_index+word_length-1),1)=val_rearrange;
        end
 %==============check if input is greater than vmax===========================================================
        if (sampled_signal(i)>partition(end))
            quantiz_signal(i)=vmax;
             bin_val=dec2bin((2^word_length)-1,word_length);  %for example- In 4-bit PCM quantize level 1 corresponds to 0x0 & level 16 is eqv to 0xf         
              %**********************Kassem BouZeid **********************************
         % to arrange string bits column and put it at appropriate index of data stream
              val_rearrange=bin_val(:);                %Make it i:1 matrix 
              rearrange_index=((i-1)*word_length)+1;   %Example- for 4 bit insert at 1st,5th,9th,13th..index
              data_stream(rearrange_index:(rearrange_index+word_length-1),1)=val_rearrange;
        end
 %=========================================================================       
        if (sampled_signal(i)>=partition(j))
        if (sampled_signal(i)<partition(j+1))
        quantiz_signal(i)=levels(j);
 %=====Simultaneously generating binary stream for each quantized value====
     bin_val=dec2bin(j-1,word_length);   %"like if we have In 4-bit PCM quantize level 1 corresponds to 0x0 & level 16 is eqv to 0xf"        
 %To arrange string bits columnwise and put it at appropriate index of data stream
   val_rearrange=bin_val(:);                %Make it i:1 matrix 
   rearrange_index=((i-1)*word_length)+1;   %"like if we have 4 bit insert at 1st,5th,9th,13th..index"
   data_stream(rearrange_index:(rearrange_index+word_length-1),1)=val_rearrange;       
             end
        end
    end
end
%==========================================================================
[size_data,~]=size(data_stream);
%=================create Encoded data stream array ========================
%==============Encoded according to Natural Binary Coding==================
dec_val=zeros(size_data,1);
for i=1:size_data
dec_val(i,1)=str2double(data_stream(i,1));  %cant plot string array. so convert to numbers
end
%length(dec_val)
%==============================Decoding====================================
k=1;
for i=1:length(data_stream)/word_length %Arrange data stream into word_length sized binary strings for conversion
    for j=1:1:word_length
        bin_rearrange(i,j)=data_stream(k);
        k=k+1;
    end
end
bin_rearrange
bin_dec=bin2dec(bin_rearrange);
decoded_val=zeros(length(bin_dec),1);
for i=1:length(bin_dec) %bin_dec contain dec equivalents ranging from 0 to max for the word
decoded_val(i)=levels(bin_dec(i)+1);%therefore dec equivalent 0 corresponds to level 1.
  %thus get quantized values from level(dec.equiv+1) and store in an array
end
%================Reconstruction from decoded signal========================
index=1;
reconst_sig=zeros(a,1); %reconstructed signal is of same size as input signal
for i=samples 
reconst_sig(i,1)=decoded_val(index,1);
index=index+1;
end    
%time
disp('Processing done');
toc;
end
%=============================Plot Input Signal Only======================= 
function push2(~, ~)
h1=figure('Name','Input Signal','NumberTitle','off','Position',[122 scrsz(4)/3 scrsz(3)/2.2 scrsz(4)/2.2]); %Position figure accordingly
plot(input_sig);
xlabel('time')
ylabel('Amplitude')
end
%=============================Plot Sampled Signal Only===================== 
function push3(~, ~)
h2=figure('Name','Sampled Signal','NumberTitle','off','Position',[scrsz(3)/1.8 scrsz(4)/3 scrsz(3)/2.2 scrsz(4)/2.2]);
stem(sampled_signal);
xlabel('time')
ylabel('Amplitude')
end
%============================Plot Quantized Signal Only ===================
function push4(~, ~)
%     if(~ischar(h1))
% close(h1);
% end
h3=figure('Name','Quantized Signal','NumberTitle','off','Position',[122 1 scrsz(3)/2.2 scrsz(4)]);
stairs(quantiz_signal)
ylim([vmin vmax])                                                                      
set(gca,'YTick',vmin:lsb:vmax)
xlabel('time')
ylabel('L-Level Quantizer')
end
%=============================Plot Encoded Signal Only ====================
function push5(~, ~)
 h4=figure('Name','Encode Signal','NumberTitle','off','Position',[1 scrsz(4)/3 scrsz(3) scrsz(4)/2.5]);
stairs(dec_val');
axis([1 1000 -3 4]);
set(gca,'YTick',-3:1:4);
set(gca,'YTicklabel',{' ',' ',' ','0','1',' ',' ',' '});
xlabel('time')
ylabel('Amplitude')
end
%=============================Play Orignal Signal =========================
function push6(~, ~)
 sound(input_sig,orgnal_sampl_freq);
end
%=============================Plot Decoded Signal Only ====================
function push7(~, ~)
%    if(~ischar(h2))
%     close(h2);
%     end
%     if(~ischar(h4))
%     close(h4);
%     end
h5=figure('Name','Decoded Signal','NumberTitle','off','Position',[scrsz(3)/1.8 scrsz(4)/3 scrsz(3)/2.2 scrsz(4)/2.2]);
plot(reconst_sig);
grid on;
ylim([vmin vmax]) 
xlabel('time')
ylabel('Amplitude')
end
%==============================Play Decoder================================
function push8(~, ~)
sound(reconst_sig,orgnal_sampl_freq);
end
%==============================Quit from Code==============================
function push9(~, ~)
clc 
close all
clear all
end
%=============================Ploting All Figure===========================
function push10(~, ~)
figure
%============================Plot Input Signal=============================
subplot(6,1,1)
plot(input_sig);
title('Original Signal');
%============================Plot Sampled Signal===========================
subplot(6,1,2)
stem(sampled_signal);
title('Sampled Signal');
%============================Plot Quantized Signal=========================
subplot(6,1,3)
stairs(quantiz_signal)
ylim([vmin vmax])
set(gca,'YTick',vmin:lsb:vmax)
title('Quantized Signal');
%============================Plot Encoded Signal===========================
subplot(6,1,4)
stairs(dec_val');
axis([1 1000 -3 4]);
set(gca,'YTick',-3:1:4);
set(gca,'YTicklabel',{' ',' ',' ','0','1',' ',' ',' '});
title('Encoded Signal');
%============================Plot Decoded Signal===========================
subplot(6,1,5)
plot(reconst_sig);
grid on;
ylim([vmin vmax]);
title('Decoded Signal');
%=============================Plot Error===================================
subplot(6,1,6)
error1= sampled_signal - quantiz_signal;
plot(error1);
title('Error');
end
%==========================Error difference================================
function push11(~, ~)
figure
error1= sampled_signal - quantiz_signal;
plot(error1);
xlabel('time')
ylabel('Difference between two Signals')
end
end