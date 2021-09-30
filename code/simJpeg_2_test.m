
%Partial JPEG encoding/decoding
%Objective: simulate partial JPEG encoding and decoding procedures on a grayscale image, and assess the reconstructed image quality using RMSE metric
%Test image: lennaY.png

%% Loading image and give values to the scalFact

im = imread('lennaY.png');
scalFact = 1; % change scaling factor values here.

%% call funtion: [recIm, rmse] = simJpeg(im, scalFact)

[recIm, rmse] = simJpeg_2(im, scalFact);