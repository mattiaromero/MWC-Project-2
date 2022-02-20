clear; clc; close all;

%% Chapter 3 - Spectral Analysis

%% 3.1 Computation of the density spectrum 

%% Load the data 

%Loading the files LowTide.txt, midTide.txt and highTide.txt
lowTide = load('lowTide.txt');
midTide = load('midTide.txt')
highTide = load('highTide.txt');
data = [lowTide midTide highTide];
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
ylabel('E [m^2/Hz]','FontWeight','bold');
legend('Spectrum','Confidence interval (95%)');
grid on;
savefig('Matlab2_i');

%Compare with the spectra obtained using 3, 7, 15, 31 blocks. 
figure;
for i=1:4
    subplot(4,1,i);
    [S f edf conf95Interval] = VarianceDensitySpectrum(lowP1,0.5^i*length(lowP1),2);
    plot(f,S);
    hold on;
    line([conf95Interval(1) conf95Interval(1)],[0 6],'Color','k','LineWidth',2);
    line([conf95Interval(2) conf95Interval(2)],[0 6],'Color','k','LineWidth',2); 
    ylabel('E [m^2/Hz]','FontWeight','bold');
    if i==1
    title('Spectrum and confidence interval for N=3,7,15 and 31 blocks');
    legend('Spectrum (N=3)','Confidence interval (95%) (N=3)');
    end
    if i==2
    legend('Spectrum (N=7)','Confidence interval (95%) (N=7)');
    end
    if i==3
    legend('Spectrum (N=15)','Confidence interval (95%) (N=15)');
    end
    if i==4
    legend('Spectrum (N=31)','Confidence interval (95%) (N=31)');
    end
end
xlabel('Frequency [Hz]','FontWeight','bold');
grid on;
savefig('Matlab2_ii');

%% Extend to multiple sensors at low tide

% We use 15 blocks as this is the best balance of resolution and
% reliablility

% Create vector for sensor data
lowP=[lowP1 lowP3 lowP4 lowP5 lowP6];

% Plot the spectra at the positions P1 to P6 for the low tide Egmond data 
figure;
for i=1:5
    subplot(5,1,i);
    [S f edf conf95Interval] = VarianceDensitySpectrum(lowP(:,i),0.5^3*length(lowP(:,i)),2);
    plot(f,S);
    ylim([0 2]);
    if i==1 
        title('Spectra for P1, P3, P4, P5 and P6 for N=15 blocks');
    end 
    ylabel('E [m^2/Hz]','FontWeight','bold');
    legend('Spectrum (N=15)');
end
xlabel('Frequency [Hz]','FontWeight','bold');
grid on;
savefig('Matlab2_iii');

% As we get closer to shore we have less waves with smaller frequencies
% because waves get smaller with higher frequencies?

%% Computation of spectral wave characteristics
% The separation between infragravity-wave and sea-swell frequencies is
% often set to 0.05 Hz. Based on the spectra at the most off-shore sensor,
% we investigate if this choice is appropriate for Egmond.
figure;
[S f edf conf95Interval] = VarianceDensitySpectrum(lowP(:,1),0.5^3*length(lowP(:,1)),2);
plot(f,S);
title('Spectrum at P1 for N=15 blocks');
ylabel('E [m^2/Hz]','FontWeight','bold');
xlabel('Frequency [Hz]','FontWeight','bold');

% Whole spectrum (if fmin = 0 Hz and fmax = fN adn fN = 1/(2*0.5) = 1Hz)
for j = 1:3
    for i=1:5
        [S f edf conf95Interval] = VarianceDensitySpectrum(data(:,i+(j-1)*5),0.5^3*length(lowP(:,i)),2);
        
        m0(i,j) = spectral_moment(f,S,0,1);
        H_m0 = 4*sqrt(m0);   %So now H_m0 = 4*sqrt(m_0)

    end
end

%Now we can compare those values of the H_m0 with the matrix H13_tot that
%we obtained in the previous practical

display(H_m0);
display(x.H13_tot);

%Infragravity waves:
for j = 1:3
    for i=1:5
        [S f edf conf95Interval] = VarianceDensitySpectrum(data(:,i+(j-1)*5),0.5^3*length(lowP(:,i)),2);
        
        m0inf(i,j) = spectral_moment(f,S,0.005,0.05);
        H_m0inf = 4*sqrt(m0inf);   %So now H_m0 = 4*sqrt(m_0)

    end
end

display(H_m0inf);

%Sea swell waves (In this loop we also calculate the peak period for the bonus question T_maxs)
for j = 1:3
    for i=1:5
        [S f edf conf95Interval] = VarianceDensitySpectrum(data(:,i+(j-1)*5),0.5^3*length(lowP(:,i)),2);
        [maxf Imaxf] = max(S); 
        T_maxs(i,j) = 1/(f(Imaxf)); %Computing the peak period for the different time series
        m0ss(i,j) = spectral_moment(f,S,0.05,1);
        H_m0ss = 4*sqrt(m0ss);   %So now H_m0 = 4*sqrt(m_0)
            
    end
end

display(H_m0ss);
%Now we can compare the cross-shore evolution of H_m0inf and H_m0ss  
save("StatisticsEgmond_2","H_m0","H_m0inf","H_m0ss");


