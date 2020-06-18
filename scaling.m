
%% Lecture code for week 3 -- Scaling
% Code by JEANETTE A MUMFORD
% (with a few minor changes by Daniel Pimentel)

% Goal:  Explore display range of MATLAB

% On your own.  Plot the vector -10:70 using image() and grayscale.  
% What do you notice?

figure(1)
dat = rand(10,10)*1000;
image(dat)
colormap(gray)

figure(2)
imagesc(dat)
colormap(gray)

figure(3)
image([-10:70])
colormap(gray)

figure(4)
imagesc([-10:70])
colormap(gray)





%% Scaling (or more precisely, range conversion)

% Although we will eventually use imagesc for scaling, we must learn how to
% scale first

%  What range do we want our image values to be to display nicely in
%  MATLAB?

% What is the current range of values in img?

img = imread('spine.jpg');

% General instructions:
% Step 0: I always like to make things double to avoid issues
img_double = double(img);

figure(5);
subplot(1,2,1); image(img);
subplot(1,2,2); hist(double img


:));

% Step 1:  Ensure smallest value is 0 
imin=min(img_double(:));
% Subtracting the minimum will set the new min to 0
img_scale=img_double-imin;


% Step 2: to find the max.
imax= max(img_scale(:));  

% Step 3: Divide by old max and multiply by what we'd like the new max to be
img_scale = img_scale/imax*256;

figure(6)
subplot(1,2,2); hist(img_scale(:));

% Convert to integer again
img_scale = uint8(img_scale);
subplot(1,2,1); image(img_scale);

% What happens if we don't transform to double?
% Do I need to transform back to integer?
% Which one is better?


%% Sigmoid function

img = 0:63;

w = 10;
s = 2;
s_w_10_s_2 = 63./(1+exp(-1*(img - w)/s));

figure(7);
plot(img, s_w_10_s_2)


w = 10;
s = 5;
s_w_10_s_5 = 63./(1+exp(-1*(img - w)/s));

figure(8);
subplot(2, 1, 1)
plot(img, s_w_10_s_2)
subplot(2,1,2)
plot(img, s_w_10_s_5)





