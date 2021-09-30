function [recIm, rmse] = simJpeg_2(im, scalFact)
%% Loading image

% im = imread('lennaY.png');
im = rgb2gray(im);
I = double(im);
I = I - 128; % level shifting(-128)

%% DCT on image divided into 8x8 blocks

N = 8; % block size

[r,c] = size(im);
DF = zeros(r, c);
DFF = DF;
Z_Q = DF;
Z_DQ = DF;

scalFact = double(scalFact);

%% Quantization matrix for DCT coefficients

Q =[16 11 10 16  24  40  51  61
    12 12 14 19  26  58  60  55
    14 13 16 24  40  57  69  56
    14 17 22 29  51  87  80  62
    18 22 37 56  68 109 103  77
    24 35 55 64  81 104 113  92
    49 64 78 87 103 121 120 101
    72 92 95 98 112 100 103 99];

Q = scalFact*Q;

%% DCT on image divided into 64 blocks

for i = 1 : N : r
    for j = 1 : N : c
        
        f = I(i:i+N-1, j:j+N-1); % select the blocks
        
        
        
        df = dct2(f); % get the discrete cosine transform coefficients of blocks
        DF(i:i+N-1, j:j+N-1) = df; % DCT of the blocks
        
        
        DF_Q = round(round(df./ Q)); % quantization of the blocks
        Z_Q(i:i+N-1, j:j+N-1) = DF_Q; % store quantization of the blocks
        
        DF_DQ = round(round(DF_Q.*Q)); % de-quantization of the blocks
        Z_DQ(i:i+N-1, j:j+N-1) = DF_DQ; % store de-quantization of the blocks
        

        dff = idct2(DF_DQ); % get the inversed discrete cosine transform coefficients of blocks
        dff = dff+128; % level shifting(+128) 
        DFF(i:i+N-1, j:j+N-1) = dff; % store the reconstructed image data

               
    end
end

%%
figure(1), imshow(DF / 255), title({'Visualization of DCT coefficients;'; ...
    'image divided into 8x8 blocks'})

figure(2), imshow(DFF / 255), title({'Reconstructed image','scaling factor :',num2str(scalFact)})

DCTcoeff = DF; % DCT coefficients
DCTcoeff_Q = Z_Q; % DCT coefficients & quantization
DCTcoeff_UQ = Z_DQ; % DCT coefficients & quantization $ de-quantization

recIm = DFF; % reconstructed image


% imwrite(DCTcoeff/255, 'DCTcoeff60.png'); % saving 'perfectly' reconstructed image
% imwrite(reclm/255, 'r60.png'); % saving 'perfectly' reconstructed image

%% visualize results after DCT and quantization

DCT_block = DCTcoeff/255;
DCT_Q_block = DCTcoeff_Q/255;
DCT_UQ_block = DCTcoeff_UQ/255;

figure(3)
subplot(2,2,1)
imshow(DCT_block(1:8,1:8))
title('Block1 in DCT coefficients')
subplot(2,2,2)
imshow(DCT_block(265:272,265:272))
title('Block34 in DCT coefficients')

subplot(2,2,3)
imshow(DCT_Q_block(1:8,1:8))
title({'Block1 in DCT coefficients','after quantization'})
subplot(2,2,4)
imshow(DCT_Q_block(265:272,265:272))
title({'Block34 in DCT coefficients','after quantization'})

% subplot(2,2,3)
% imshow(DCT_UQ_block(1:8,1:8))
% title({'Block1 in DCT coefficients','after quantization and de-quantization'})
% subplot(2,2,4)
% imshow(DCT_UQ_block(265:272,265:272))
% title({'Block34 in DCT coefficients','after quantization and de-quantization'})

%% show results after DCT and quantization

original = double(im);

fprintf('Original image of block1.\n');
display(original(1:8,1:8))
fprintf('Original image of block34.\n');
display(original(265:272,265:272))

fprintf('DCT coefficients of block1.\n');
display(DCTcoeff(1:8,1:8))
fprintf('DCT coefficients of block34.\n');
display(DCTcoeff(265:272,265:272))

fprintf('DCT & Quantization of block1.\n');
display(DCTcoeff_Q(1:8,1:8))
fprintf('DCT & Quantization of block34.\n');
display(DCTcoeff_Q(265:272,265:272))

fprintf('Reconstructed image of block1.\n');
display(recIm(1:8,1:8))
fprintf('Reconstructed image of block34.\n');
display(recIm(265:272,265:272))


%% Calculate RMSE

e = double(DFF) - double(im);
[m, n] = size(e);
rmse = sqrt(sum(e(:) .^ 2) / (m * n));

%% plot relationship between scale factor and RMSE

fprintf('plot relationship between scale factor and RMSE.\n');
fprintf('scale factor: 1 20 40 60 80 100');

scalfactor = [1 20 40 60 80 100];
RMSE = [3.7401 16.2978 25.7607 37.4549 41.4978 41.5124];
figure(4)
plot(scalfactor,RMSE,'-o','MarkerIndices',1:1:length(scalfactor)) 
title('Relationship between scaling factor and RMSE')
xlabel('Scaling factor') 
ylabel('RMSE')
  
  
return;