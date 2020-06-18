%% Illustration of basic Fourier filtering
% Code by Daniel Pimentel
clear all; close all; clc;

%% load in epithelial image
load(sprintf('epith.mat'));

%% Fourier transform
EPITH = fft2(epith);
figure(1);
colormap(gray);
subplot(1,2,1);
imagesc(epith);
subplot(1,2,2);
imagesc(fftshift(log(abs(EPITH))));

%% Inverse Fourier (sanity check)
epith_reconstructed = ifft2(EPITH);
figure(2);
colormap(gray);
subplot(1,2,1);
imagesc(epith);
subplot(1,2,2);
imagesc(epith_reconstructed);

%% Create low-pass filter in Fourier domain
TH = 30; % Number of frequencies that we will keep
FILTER = zeros(size(epith));
for i=1:ceil(size(FILTER,1)/2)
    for j=1:ceil(size(FILTER,2)/2)
        if norm([i;j]) <= TH
            FILTER(i,j) = 1;
            FILTER(end-i+1,end-j+1) = 1;
            FILTER(i,end-j+1) = 1;
            FILTER(end-i+1,j) = 1;
        end
    end
end

figure(3);
colormap(gray);
imagesc(fftshift(log(abs(FILTER))));

%% Apply filter in Fourier domain and see results in Space domain
EPITH_FILTERED = EPITH .* FILTER;
epith_filtered = ifft2(EPITH_FILTERED);
figure(4);
colormap(gray);
subplot(1,2,1);
imagesc(fftshift(log(abs(EPITH_FILTERED))));
subplot(1,2,2);
imagesc(abs(epith_filtered));










