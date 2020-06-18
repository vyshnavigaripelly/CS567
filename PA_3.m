

%% Problem 2
imgf=fft2(img);
figure(2)
subplot(1,2,1), imshow(img);
subplot(1,2,2), imagesc(fftshift(log(abs(imgf))));

%% Problem 3
imgf=fft2(img);
kxf=fft2(kx,295,339);
kyf=fft2(ky,295,339);
ktf=fft2(kt,295,339);
Kx=imgf.*kxf;
Ky=imgf.*kyf;
Kt=imgf.*ktf;
figure(3)
subplot(1,3,1), imshow(Kx), title("Convolution of kxf");
subplot(1,3,2), imshow(Ky), title("Convolution of kyf");
subplot(1,3,3), imshow(Kt), title("Convolution of ktf");

%% Problem 4
kxi=ifft2(Kx);
kyi=ifft2(Ky);
kti=ifft2(Kt);
figure(4)
subplot(1,3,1), imshow(kxi), title("Inverse Fourier of kxf");
subplot(1,3,2), imshow(kyi), title(" Inverse Fourier of kyf");
subplot(1,3,3), imshow(kti), title("Inverse Fourier of ktf");

%% Problem 5
s=trans(img,10,10);
figure(5)
subplot(1,2,1), imagesc(s), colormap('gray'), title("Using Trans Function");
p=imtranslate(img, [10 10]);
subplot(1,2,2), imagesc(p), colormap('gray'),title("Using in-built function");

%% Problem 6
x=rot(img,45);
figure(6)
subplot(1,2,1), imshow(x,[]); title('Using rot function');
c=imrotate(img,45);
subplot(1,2,2), imshow(c); title('Using In-built function');


%% Problem - 7
b=scale(img,1.5);
figure(7)
imagesc(b), colormap('gray') , title('Using scale function');
h=imresize(img,1.5);
figure(8), imagesc(h), colormap('gray'), title('Using in-built function');

%% Problem 8
figure(9)
subplot(2,2,1),imagesc(img), colormap('gray'),title('Original Image')
q=rot(img,40);
subplot(2,2,2),imagesc(q),colormap('gray'),title('1. Rotation')
d=trans(q,30,20);
subplot(2,2,3),imagesc(d),colormap('gray'),title('2. Translation')
f=scale(d,1.5);
subplot(2,2,4),imagesc(f),colormap('gray'),title('3. Scaling')

figure(10)
subplot(2,2,1),imagesc(img), colormap('gray'),title('Original Image')
q=rot(img,40);
subplot(2,2,2),imagesc(q),colormap('gray'),title('1. Rotation')
d=scale(q,1.5);
subplot(2,2,3),imagesc(d),colormap('gray'),title('2. Scaling')
f=trans(d,30,20);
subplot(2,2,4),imagesc(f),colormap('gray'),title('3. Translation')

figure(11)
subplot(2,2,1),imagesc(img), colormap('gray'),title('Original Image')
f=trans(img,30,20);
subplot(2,2,2),imagesc(f),colormap('gray'),title('1. Translation')
q=rot(f,40);
subplot(2,2,3),imagesc(q),colormap('gray'),title('2. Rotation')
d=scale(q,1.5);
subplot(2,2,4),imagesc(d),colormap('gray'),title('3. Scaling')


figure(12)
subplot(2,2,1),imagesc(img), colormap('gray'),title('Original Image')
f=trans(img,30,20);
subplot(2,2,2),imagesc(f),colormap('gray'),title('1. Translation')
d=scale(f,1.5);
subplot(2,2,3),imagesc(d),colormap('gray'),title('2. Scaling')
q=rot(d,40);
subplot(2,2,4),imagesc(q),colormap('gray'),title('3. Rotation')

figure(13)
subplot(2,2,1),imagesc(img), colormap('gray'),title('Original Image')
d=scale(img,1.5);
subplot(2,2,2),imagesc(d),colormap('gray'),title('1. Scaling')
f=trans(d,30,20);
subplot(2,2,3),imagesc(f),colormap('gray'),title('2. Translation')
q=rot(f,40);
subplot(2,2,4),imagesc(q),colormap('gray'),title('3. Rotation')

figure(14)
subplot(2,2,1),imagesc(img), colormap('gray'),title('Original Image')
d=scale(img,1.5);
subplot(2,2,2),imagesc(d),colormap('gray'),title('1. Scaling')
q=rot(d,40);
subplot(2,2,3),imagesc(q),colormap('gray'),title('2. Rotation')
f=trans(q,30,20);
subplot(2,2,4),imagesc(f),colormap('gray'),title('3. Translation')




%% All Functions

function w=trans(img,x,y)
n=size(img);
w=zeros(n(1),n(2));
w((x:end),(y:end))=img(1:(n(1)-x+1),1:(n(2)-y+1));
end

function imagerot = rot(img,degree)

[Rows, Cols] = size(img); 
Diagonal = sqrt(Rows^2 + Cols^2); 
RowPad = ceil(Diagonal - Rows);
ColPad = ceil(Diagonal - Cols);
imagepad = zeros(Rows+RowPad, Cols+ColPad);
imagepad(ceil(RowPad/2):(ceil(RowPad/2)+Rows-1),ceil(ColPad/2):(ceil(ColPad/2)+Cols-1)) = img;

rads = (degree * pi)/180;
%midpoints
midx=ceil((size(imagepad,2)+1)/2);
midy=ceil((size(imagepad,1)+1)/2);
e=zeros(1,length(midx));
t=e;
imagerot=zeros(size(imagepad)); % midx and midy same for both

for i=1:size(imagerot,1)
    for j=1:size(imagerot,2)

         x= (i-midx)*cos(rads)+(j-midy)*sin(rads);
         y=-(i-midx)*sin(rads)+(j-midy)*cos(rads);
         x=round(x)+midx;
         y=round(y)+midy;

         if (x>=1 && y>=1 && x<=size(imagepad,2) && y<=size(imagepad,1))
              imagerot(i,j)=imagepad(x,y); % k degrees rotated image         
         end

    end
end
end

function b=scale(img,a)
u=ceil(a*size(img,1));
v=ceil(a*size(img,2));
b=zeros(u,v);
b((1:(u-1)),(1:(v-1))) = img(ceil((1:(u-1))/a),ceil((1:(v-1))/a));
b(u,v)=img(ceil((u-1)/a),ceil((v-1)/a));
end


