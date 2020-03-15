%% Learning in-place residual homogeneity for single image detail enhancement
%  Conference paper: ICASSP 2018
%  Journal paper: Journal of electronic imaging (under review)
%  First author: He Jiang
%  All authors: He Jiang  Mujtaba Asad  Xiaolin Huang  Jie Yang
%  Date: 2019-12-21
%  Version: This is the faster version of our method, and you can run
%  demo_faster.m to run the project
%  github address: https://github.com/hehesjtu/ICASSP2018-enhance-IPRH
%  All images files are saved in folder data, using format "*png" 

clc;clear all;warning off;
Files = dir(strcat('.\data\','*.png'));
mkdir results
LengthFiles = length(Files); 
global adjust_factor; 
for ii = 1:LengthFiles 
    image=double(imread(strcat('.\data\',Files(ii).name)));
    Files(ii).name
    tic
    outimg = faster_enhance(image);
    toc
    imwrite(uint8(outimg),strcat('.\results\',Files(ii).name(1:end-4),'_FasterIP.png'));
    clear outimg;
end


