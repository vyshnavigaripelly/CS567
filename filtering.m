%% Illustration of basic Filtering
% Code by Daniel Pimentel
clear all; close all; clc;

%% load in epithelial image
load(sprintf('epith.mat'));

%% Basic Filters
kernel = [1 0 -1; 1 0 -1; 1 0 -1];
kernel_sharp = [-1 -1 -1; -1 9 -1; -1 -1 -1];
epith_vertical = conv2(epith,kernel);
epith_horizontal = conv2(epith,kernel');
epith_sharp = conv2(epith,kernel_sharp);

figure(1);
colormap(gray);
subplot(1,4,1);
imagesc(epith);
subplot(1,4,2);
imagesc(epith_vertical);
subplot(1,4,3);
imagesc(epith_horizontal);
subplot(1,4,4);
imagesc(epith_sharp);

%% Median Filter
med_size = 10;
epith_med = medfilt2(epith,[med_size,med_size]);

figure(2);
colormap(gray);
subplot(1,2,1);
imagesc(epith);
subplot(1,2,2);
imagesc(epith_med);