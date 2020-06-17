%% using H1, L0 and L1 to generate a new H1
function GetH0FromH1=IPRH2(H1_outimg,L0_outimg,L1_outimg)
    global PaddingSize;
    [L1x,L1y,d1]=size(L1_outimg);
    [L0x,L0y,d2]=size(L0_outimg);
    GetH0FromH1=zeros(L0x,L0y);
    PaddingSize=10;
    coef=L0x/L1x;
    Large_L0=padarray(L0_outimg,[PaddingSize,PaddingSize],'symmetric','both');
    Large_L1=padarray(L1_outimg,[PaddingSize,PaddingSize],'symmetric','both');
    Large_averageh1=padarray(H1_outimg,[PaddingSize,PaddingSize],'symmetric','both');
    Large_GetH0FromH1=padarray(GetH0FromH1,[PaddingSize,PaddingSize],'symmetric','both');
    for centerx=1:L0x
       for centery=1:L0y
           p_L0=Large_L0(PaddingSize+centerx-1:PaddingSize+centerx+1,PaddingSize+centery-1:PaddingSize+centery+1);
           Threshold=10000;
           newx=floor(centerx/coef);
           newy=floor(centery/coef);
           retrievex=newx;
           retrievey=newy;
           % in-place regions
           for iterin1=0:1
               for iterin2=0:1
                  p_L1=Large_L1(PaddingSize+newx-1+iterin1:PaddingSize+newx+1+iterin1,PaddingSize+newy-1+iterin2:PaddingSize+newy+1+iterin2);
                  subtmp=abs(p_L1-p_L0);
                  subtmp=sum(subtmp(:));
                  if subtmp<Threshold    
                    Threshold=subtmp;
                    retrievex=newx+iterin1;
                    retrievey=newy+iterin2;
                  end
               end
           end
        H0_temp=Large_averageh1(PaddingSize+retrievex-1:PaddingSize+retrievex+1,...
                  PaddingSize+retrievey-1:PaddingSize+retrievey+1); 
        Large_GetH0FromH1(PaddingSize+centerx-1:PaddingSize+centerx+1,...
                  PaddingSize+centery-1:PaddingSize+centery+1)=H0_temp;       
    end
end
       GetH0FromH1=Large_GetH0FromH1(PaddingSize+1:end-PaddingSize,PaddingSize+1:end-PaddingSize);
end

