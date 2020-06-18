img=imread('C:\Users\garip\Desktop\hw04\metastatic.jpg');
b=im2bw(img,0.7);
label=bwlabel(b);
stats=regionprops(label,'Solidity','Area'); % inorder to measure the area and density
den=[stats.Solidity];
ar=[stats.Area];
hi_den_ar=den>0.5;
max_area=max(ar(hi_den_ar));
tumor=find(ar==max_area);
m=ismember(label,tumor);
n = ones(5,5);
R=padarray(m,[1 1]);
%Intialize a matrix of matrix size m with zeros for dilation.
W=false(size(m));
for i=1:size(R,1)-4
    for j=1:size(R,2)-4
        %Perform logical AND operation
        W(i,j)=sum(sum(n&R(i:i+4,j:j+4)));
    end
end
% The figure W is not the desired output. Hence we are further segmenting
% it using the region growing technique.
k = regiongrowing(W,150,150,0.2); 
figure, imshow(k),title('Tumor using dilation');

%The dilation is giving the desired tumor image.
%but instead we can do the erosion if we want.But dilation is giving
%desired results.
I = m; 
% create structuring element               
se=ones(5, 5); 
  
% store number of rows in P and number of columns in Q.             
[P, Q]=size(se);  
  
% create a zero matrix of size I.         
In=zeros(size(I, 1), size(I, 2));  
  
for i=ceil(P/2):size(I, 1)-floor(P/2) 
    for j=ceil(Q/2):size(I, 2)-floor(Q/2) 
  
        % take all the neighbourhoods. 
        on=I(i-floor(P/2):i+floor(P/2), j-floor(Q/2):j+floor(Q/2));  
  
        % take logical se 
        nh=on(logical(se));  
        
        % compare and take minimum value of the neighbor  
        % and set the pixel value to that minimum value.  
        In(i, j)=min(nh(:));       
    end
end
In = regiongrowing(In,150,150,0.2);
figure,
imshow(In); title('tumor image using erosion');
%%
g = imread('C:\Users\garip\Desktop\hw04\ground_truth.png');
g = rgb2gray(g);
t = size(img);
g = imresize(g,[t(1),t(2)]);
dice = 2*nnz(k&g)/(nnz(k) + nnz(g)); %nnz is used here to calculate the non-zero area
fprintf("the value of dice coefficient is %f\n",dice);

%%
g = double(g);
n=hausdorff(g,k);
fprintf("the value of hausdorff distace is %d\n",n);
%%
function z = hausdorff( M, N) 
M=M(M>=0);
N=N(N>=0);
z = max(compdist(M, N), compdist(N, M));
end
% Compute distance
function dist = compdist(M, N) 
m = size(M);
n = size(N);
dve = [];
D = [];
% dim= size(A, 2); 
for j = 1:m(2)
    
    for k= 1: n(2)
        
    D(k) = abs((M(j)-N(k)));
    
   end
    
    dve(j) = min(D); 
      
end
 dist = max(dve);
end

function J=regiongrowing(I,x,y,reg_maxdist)
% This function performs "region growing" in an image from a specified
% seedpoint (x,y)
%
% J = regiongrowing(I,x,y,t) 
% 
% I : input image 
% J : logical output image of region
% x,y : the position of the seedpoint (if not given uses function getpts)
% t : maximum intensity distance (defaults to 0.2)
%
% The region is iteratively grown by comparing all unallocated neighbouring pixels to the region. 
% The difference between a pixel's intensity value and the region's mean, 
% is used as a measure of similarity. The pixel with the smallest difference 
% measured this way is allocated to the respective region. 
% This process stops when the intensity difference between region mean and
% new pixel become larger than a certain treshold (t)

if(exist('reg_maxdist','var')==0), reg_maxdist=0.2; end
if(exist('y','var')==0), figure, imshow(I,[]); [y,x]=getpts; y=round(y(1)); x=round(x(1)); end

J = zeros(size(I)); % Output 
Isizes = size(I); % Dimensions of input image

reg_mean = I(x,y); % The mean of the segmented region
reg_size = 1; % Number of pixels in region

% Free memory to store neighbours of the (segmented) region
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 

pixdist=0; % Distance of the region newest pixel to the regio mean

% Neighbor locations (footprint)
neigb=[-1 0; 1 0; 0 -1;0 1];

% Start regiogrowing until distance between regio and posible new pixels become
% higher than a certain treshold
while(pixdist<reg_maxdist&&reg_size<numel(I))

    % Add new neighbors pixels
    for j=1:4,
        % Calculate the neighbour coordinate
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        
        % Check if neighbour is inside or outside the image
        ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        
        % Add neighbor if inside and not already part of the segmented area
        if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
        end
    end

    % Add a new block of free memory
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    
    % Add pixel with intensity nearest to the mean of the region, to the region
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    J(x,y)=2; reg_size=reg_size+1;
    
    % Calculate the new mean of the region
    reg_mean= (reg_mean*reg_size + neg_list(index,3))/(reg_size+1);
    
    % Save the x and y coordinates of the pixel (for the neighbour add proccess)
    x = neg_list(index,1); y = neg_list(index,2);
    
    % Remove the pixel from the neighbour (check) list
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
end

% Return the segmented area as logical matrix
J=J>1;
end



   



