clear; clc; close all;

%% Chapter 3 - Spectral Analysis

%% 3.1 Computation of the density spectrum 

%% Load the data 

%Loading the files LowTide.txt, midtide and highTide.txt
lowTide = load('lowTide.txt');
midTide = load('midTide.txt')
highTide = load('highTide.txt');
data = [lowTide midTide highTide]
lowP1 = lowTide(:,1);
lowP3 = lowTide(:,2);
lowP4 = lowTide(:,3);
lowP5 = lowTide(:,4);
lowP6 = lowTide(:,5);

highP1 = highTide(:,1);
highP3 = highTide(:,2);
highP4 = highTide(:,3);
highP5 = highTide(:,4);
highP6 = highTide(:,5);

%Loading the statistics from Chapter 1 
x = load('StatisticsEgmond','Hm_tot','Hrms_tot','H13_tot');

%% Compute the variance density spectrum 

% Computing the variance density spectrum for the most offshore location at 
% low tide using only one block. 

[S f edf conf95Interval] = VarianceDensitySpectrum(lowP1,length(lowP1),2);

% Plotting the spectrum and lines representing the confidence interval.
figure;
plot(f,S);
hold on;
line([conf95Interval(1) conf95Interval(1)],[0 6],'Color','k','LineWidth',2);
line([conf95Interval(2) conf95Interval(2)],[0 6],'Color','k','LineWidth',2);
title('Spectrum and confidence interval for 1 block');
xlabel('Frequency [Hz]','FontWeight','bold');
ylabel('Spectrum [m^2/Hz]','FontWeight','bold');
legend('Spectrum','Confidence interval (95%)');
grid on;
savefig('Matlab2_i');

%Compare with the spectra obtained using 3, 7, 15, 31 blocks. 
figure;
%legen = [['Spectrum (N =3)'] ['Spectrum (N = 7)'] ['Spectrum (N = 15)'] ['Spectrum (N = 31)']]
for i=1:4
    subplot(4,1,i);
    [S f edf conf95Interval] = VarianceDensitySpectrum(lowP1,0.5^i*length(lowP1),2);
    plot(f,S);
    hold on;
    line([conf95Interval(1) conf95Interval(1)],[0 6],'Color','k','LineWidth',2);
    line([conf95Interval(2) conf95Interval(2)],[0 6],'Color','k','LineWidth',2); 
    %legend(legen(i));
end
title('Spectrum and confidence interval for N=3,7,15 and 31 blocks');
xlabel('Frequency [Hz]','FontWeight','bold');
ylabel('Spectrum [m^2/Hz]','FontWeight','bold');
legend('Spectrum (N=3)','Confidence interval (95%) (N=3)','Spectrum (N=3)','Confidence interval (95%) (N=3)');
grid on;
savefig('Matlab2_ii');

%% Extend to multiple sensors at low tide

% We use 15 blocks as this is the best balance of resolution and
% reliablility

% Plot the spectra at the positions P1 to P6 for the low tide Egmond data. 

% Create vector for sensor data
lowP=[lowP1 lowP3 lowP4 lowP5 lowP6];

% Compute and plot spectra at different locations 
figure;
for i=1:5
    subplot(5,1,i);
    [S f edf conf95Interval] = VarianceDensitySpectrum(lowP(:,i),0.5^3*length(lowP(:,i)),2);
    plot(f,S);
    ylim([0 2]);
    
   
    %hold on;
    %line([conf95Interval(1) conf95Interval(1)],[0 6],'Color','k','LineWidth',2);
    %line([conf95Interval(2) conf95Interval(2)],[0 6],'Color','k','LineWidth',2); 
end
title('Spectrum and for P1, P3, P4, P5 and P6 for N=15 blocks');
xlabel('Frequency [Hz]','FontWeight','bold');
ylabel('Spectrum [m^2/Hz]','FontWeight','bold');
legend('Spectrum (N=15)');
grid on;
savefig('Matlab2_iii');

% As we get closer to shore we have less waves with smaller frequencies
% because waves get smaller with higher frequencies?

% The separation between infragravity-wave and sea-swell frequencies is
% often set to 0.05 Hz. Based on the spectra at the most off-shore sensor,
% do you feel that this choice is appropriate for Egmond? 
% NO, should be around 0.06Hz (see below). 

figure;
[S f edf conf95Interval] = VarianceDensitySpectrum(lowP(:,1),0.5^3*length(lowP(:,1)),2);
plot(f,S);


% Comment the cross-shore evolution of the spectra.
% Infragravity waves are more present offshore? Wind and swell waves disappear close to shore...
% NOTE: Spectrum is ENERGY 

%Computation of spectral wave characteristics:
%- if fmin = 0 Hz and fmax = fN adn fN = 1/(2*0.5) = 1Hz 


for j = 1:3
    for i=1:5
        [S f edf conf95Interval] = VarianceDensitySpectrum(data(:,i+(j-1)*5),0.5^3*length(lowP(:,i)),2);
        
        m0(i,j) = spectral_moment(f,S,0,1);
        H_m0 = 4*sqrt(m0);   %So now H_m0 = 4*sqrt(m_0)

    end
end
%Now we can compare those values of the H_m0 with the matrix H13_tot that
%we obtained in the previous practical 

%Infragravity:
for j = 1:3
    for i=1:5
        [S f edf conf95Interval] = VarianceDensitySpectrum(data(:,i+(j-1)*5),0.5^3*length(lowP(:,i)),2);
        
        m0inf(i,j) = spectral_moment(f,S,0.005,0.05);
        H_m0inf = 4*sqrt(m0inf);   %So now H_m0 = 4*sqrt(m_0)

    end
end

%Sea swell (In this loop we also calculate the peak period for the bonus question T_maxs)
for j = 1:3
    for i=1:5
        [S f edf conf95Interval] = VarianceDensitySpectrum(data(:,i+(j-1)*5),0.5^3*length(lowP(:,i)),2);
        [maxf Imaxf] = max(S); 
        T_maxs(i,j) = 1/(f(Imaxf)); %Computing the peak period for the different time series
        m0ss(i,j) = spectral_moment(f,S,0.05,1);
        H_m0ss = 4*sqrt(m0ss);   %So now H_m0 = 4*sqrt(m_0)
            
    end
end
%Now we can compare the cross-shore evolution of H_m0inf and H_m0ss  
save("StatisticsEgmond_2","H_m0","H_m0inf","H_m0ss");


