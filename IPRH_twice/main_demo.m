%% Code for using the IPRH twice, and see the function IPRH.m and IPRH2.m for details
clc;clear all;warning off;close all
Files = dir(strcat('C:\Users\hehesjtu\Desktop\test2\','*.jpg')); 
LengthFiles = length(Files); 
for ii = 1:LengthFiles 
    Files(ii).name
    image=imread(strcat('C:\Users\hehesjtu\Desktop\test2\',Files(ii).name));
    [w0,h0,d]=size(image);
    image=double(image);
    outimg1=image(:,:,1);
    outimg2=image(:,:,2);
    outimg3=image(:,:,3);
    %% Using bilinear to get L1 and L0
    L1_outimg1=imresize(outimg1,1.25,'bilinear');
    L1_outimg2=imresize(outimg2,1.25,'bilinear');
    L1_outimg3=imresize(outimg3,1.25,'bilinear');
    L0_outimg1=imresize(L1_outimg1,[size(image,1),size(image,2)],'bilinear');
    L0_outimg2=imresize(L1_outimg2,[size(image,1),size(image,2)],'bilinear');
    L0_outimg3=imresize(L1_outimg3,[size(image,1),size(image,2)],'bilinear');
    %% Get the first H1, initail estimation of the details
    tic
    H1_outimg1=IPRH(outimg1);             
    H1_outimg2=IPRH(outimg2); 
    H1_outimg3=IPRH(outimg3);
    toc
    %% Get the fine details using IPRH
    H0_reset=zeros(size(image,1),size(image,2),3);
    H0_reset(:,:,1)=IPRH2(H1_outimg1,L0_outimg1,L1_outimg1);
    H0_reset(:,:,2)=IPRH2(H1_outimg2,L0_outimg2,L1_outimg2);
    H0_reset(:,:,1)=IPRH2(H1_outimg3,L0_outimg3,L1_outimg3);
    %% Get the image detail enhancement results
    outimg1=outimg1+2*H0_reset(:,:,1);
    outimg2=outimg2+2*H0_reset(:,:,2);
    outimg3=outimg3+2*H0_reset(:,:,3);
    outimg(:,:,1)=outimg1;
    outimg(:,:,2)=outimg2;
    outimg(:,:,3)=outimg3;
    imwrite(uint8(outimg),strcat(Files(ii).name(1:end-4),'_IP.jpg'));
    clear outimg;
end