clear; clc; close all;

%% Chapter 3 - Spectral Analysis

%% 3.1 Computation of the density spectrum 

%% Load the data 

%Loading the files LowTide.txt and highTide.txt
lowTide = load('lowTide.txt');
highTide = load('highTide.txt');
lowP1 = lowTide(:,1);
lowP3 = lowTide(:,2);
lowP6 = lowTide(:,5);

highP1 = highTide(:,1);
highP3 = highTide(:,2);
highP6 = highTide(:,5);

%Loading the statistics from Chapter 1 
x = load('StatisticsEgmond','Hm_tot','Hrms_tot','H13_tot');

%% Compute the variance density spectrum 

% Compute the variance density spectrum for the most offshore location at 
% low tide using only one block. Plot the spectrum and lines representing 
% the confidence interval.

[S f edf conf95Interval] = VarianceDensitySpectrum(lowP1,length(lowP1),2);