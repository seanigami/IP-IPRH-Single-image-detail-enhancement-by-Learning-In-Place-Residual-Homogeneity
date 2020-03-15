%% ICASSP 2018 code: In-place residual homogeneity 
function Residual=IPRH(image)
    I0=image;
    hfs_y1=20;
    L1=round(imresize(I0,1.25,'bilinear')); 
    L0=round(10*imresize(imresize(I0,1.25,'bilinear'),size(I0),'bilinear'))/10; 
    % the high frequency (residual homogeneity) needed to be protected
    H0=round(10*(I0-L0))/10;  
    %% padding the original image
    largeL0=L0([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    largeL1=L1([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    largeH0=H0([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    sumh0=zeros(size(largeL1));
    counth0=zeros(size(largeL1));
    [newh1 neww1]=size(L1);
    [newh1x neww1x]=size(image);
    coef=newh1x/newh1;
    % search only between L0 and L1
    for centerx=1:1:newh1
         for centery=1:1:neww1
                 p_L1=largeL1(hfs_y1+centerx-1:hfs_y1+centerx+1,hfs_y1+centery-1:hfs_y1+centery+1);
                 newx=floor(centerx*coef);  
                 newy=floor(centery*coef);
                 maxsum=1000;
                 retrievex=newx;
                 retrievey=newy;
            % in-place regions
            for iterin1=0:1
                for iterin2=0:1
                    p_L0=largeL0(hfs_y1+newx-1+iterin1:hfs_y1+newx+1+iterin1,hfs_y1+newy-1+iterin2:hfs_y1+newy+1+iterin2);
                    subtmp=abs(p_L1-p_L0);
                    subtmp=sum(subtmp(:));
                    if subtmp<maxsum    
                        maxsum=subtmp;
                        retrievex=newx+iterin1;
                        retrievey=newy+iterin2;
                    end
                end
            end
            q_p_H0=largeH0(hfs_y1+retrievex-2:hfs_y1+retrievex+2,hfs_y1+retrievey-2:hfs_y1+retrievey+2);
            sumh0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)=sumh0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)+q_p_H0;
            counth0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)=counth0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)+1;
        end
    end
    counth0(counth0<1)=1;
    averageh0=round(10*sumh0./counth0)/10; 
    Residual = averageh0(hfs_y1+1:end-hfs_y1,hfs_y1+1:end-hfs_y1);
end