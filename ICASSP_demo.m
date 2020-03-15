%% ICASSP 2018 code: In-place residual homogeneity 
%% Learning in-place residual homogeneity for single image detail enhancement
%  Conference paper: ICASSP 2018
%  Journal paper: Journal of electronic imaging (under review)
%  First author: He Jiang
%  All authors: He Jiang  Mujtaba Asad  Xiaolin Huang  Jie Yang
%  Date: 2019-12-21
%  Version: This is the slower version of our method, and you can run
%  demo_faster.m to run the project
%  github address: https://github.com/hehesjtu/ICASSP2018-enhance-IPRH
%  All images files are saved in folder data, using format "*png" 

clc;clear all;warning off;
Files = dir(strcat('.\data\','*.png')); 
LengthFiles = length(Files); 
factor = 2; 
for ii = 1:LengthFiles 
    image=double(imread(strcat('.\data\',Files(ii).name)));
    outimg1=image(:,:,1);
    outimg2=image(:,:,2);
    outimg3=image(:,:,3);
    %% get H1
    H1_outimg1=IPRH(outimg1);             
    H1_outimg2=IPRH(outimg2); 
    H1_outimg3=IPRH(outimg3);
    %% get details
    Details=zeros(size(image,1),size(image,2),3);
    Details(:,:,1)=imresize(H1_outimg1,[size(image,1),size(image,2)],'bilinear');
    Details(:,:,2)=imresize(H1_outimg2,[size(image,1),size(image,2)],'bilinear');
    Details(:,:,3)=imresize(H1_outimg3,[size(image,1),size(image,2)],'bilinear');
    %% add details to the original images
    outimg1=outimg1+Details(:,:,1)*factor;
    outimg2=outimg2+Details(:,:,2)*factor;
    outimg3=outimg3+Details(:,:,3)*factor;
    outimg(:,:,1)=outimg1;
    outimg(:,:,2)=outimg2;
    outimg(:,:,3)=outimg3;
    imwrite(uint8(outimg),strcat('.\results\',Files(ii).name(1:end-4),'_IP.png'));
    clear outimg;
end