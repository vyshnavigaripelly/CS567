%% Illustration of basic histogram-based thresholding and filtering
% Code by JEANETTE A MUMFORD
% (with a few minor changes by Daniel Pimentel)

close all; clear all; clc;

% load in epithelial image
load(sprintf('epith.mat'));

% Let's have a look
figure(1)
subplot(2, 1, 1)
imagesc(epith)
colormap('gray')
subplot(2,1,2)
hist(epith(:))

% Histogram doesn't seem to be telling us much.  Why?
figure(2)
subplot(2,1,1);
hist(epith(:), 500)

subplot(2,1,2);
hist(epith(:), 110)


% That's a bit better, but how about we try filtering?
filt_size = [3,5, 11, 21];
figure(3)
for i=1:length(filt_size)
    filt_dat = medfilt2(epith, [filt_size(i), filt_size(i)]);
    subplot(4, 2, 2*i-1)
    hist(filt_dat(:), 50)
    subplot(4, 2, 2*i)
    imagesc(filt_dat); colormap('gray')
end


epith_medfilt = medfilt2(epith, [11,11]);
figure(4)
hist(epith_medfilt(:), 100)

% What are you guesses?
guesses = [5]'
guess = mean(guesses);

diff = 2;
while(diff>0.001)
  mean1 = mean(epith_medfilt(epith_medfilt>=guess));
  mean2 = mean(epith_medfilt(epith_medfilt<guess));
  guess_new = (mean1+mean2)/2;
  diff = abs(guess_new-guess);
  guess = guess_new
end

% Plot the result
figure(5)
imagesc(epith_medfilt>guess); colormap('gray')


%% Dealing with illumination gradient (cursory approach)

load(sprintf('epith_ig.mat'));

figure(6)
imagesc(epith_ig); colormap('gray')

% Let's divide into vertical sections
size(epith_ig)
% If I use 5 sections, then each one is 200/5 in length

% Plot split up data and histograms
figure(7)
nseg = 5;
len_seg = 200/nseg;
for i = 1:nseg
    dat_loop = epith_ig(:, (1+len_seg*(i-1)):(i*len_seg));
    subplot(5, 2,(2*i-1))
    imagesc(dat_loop); colormap('gray')
    subplot(5, 2, i*2)
    hist(dat_loop(:), 100)
end

epith_ig_medfilt = medfilt2(epith_ig, [15,15]);

figure(8)
nseg = 5;
len_seg = 200/nseg;
for i = 1:nseg
    dat_loop = epith_ig_medfilt(:, (1+len_seg*(i-1)):(i*len_seg));
    subplot(5, 2,(2*i-1))
    imagesc(dat_loop); colormap('gray')
    subplot(5, 2, i*2)
    hist(dat_loop(:), 100)
end



guess_vec = [25, 50, 70, 120, 140];
thresh_final = 0*guess_vec;
for i = 1:5
   i
  dat_loop = epith_ig_medfilt(:, (1+len_seg*(i-1)):(i*len_seg));
  guess = guess_vec(i); 
  diff = 2;
  while(diff>0.001)
    mean1 = mean(dat_loop(dat_loop>=guess));
    mean2 = mean(dat_loop(dat_loop<guess));
    guess_new = (mean1+mean2)/2;
    diff = abs(guess_new-guess);
    guess = guess_new;
  end
  thresh_final(i) = guess;
end

thresh_final

% Now to apply the threshold and view results (note, we have to apply it
% separately for each section)


epith_ig_medfilt_seg = 0*epith_ig_medfilt;
for i = 1:5
    dat_loop = epith_ig_medfilt(:, (1+len_seg*(i-1)):(i*len_seg));
    epith_ig_medfilt_seg(:, (1+len_seg*(i-1)):(i*len_seg)) = dat_loop > thresh_final(i);
end

figure(9)
imagesc(epith_ig_medfilt_seg); colormap('gray')


hold on
for i=1:5
  plot([40*i, 40*i],[0,200], 'c', 'linewidth', 3)
end
hold off
