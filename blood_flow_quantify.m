

FileIn    = './';
FileName  = 'F1_Cropped.tif';
FullName =  strcat(FileIn, FileName);

frame_num=259;
Velo_PCV=zeros(frame_num-2,1);

% LT_corner=[141,2];
% RB_corner=[158,274];

LT_corner=[132,38];
RB_corner=[151,158];

Width=RB_corner(1)-LT_corner(1)+1;
Height=RB_corner(2)-LT_corner(2)+1;
Midline=LT_corner(1)+Width/2;

ProbeNum=30;



for idx1=1:1:(frame_num-2)
%for idx=43

idx2=idx1+1;
idx3=idx1+2;


image1        =   imread(FullName,idx1);
image2        =   imread(FullName,idx2);
image3        =   imread(FullName,idx3);
img1          =   image1;
img2          =   image2;
img3          =   image3;

img_dif2=double(img3)-double(img2);
img_dif1=double(img2)-double(img1);


imwrite(uint8(img_dif2),['./output/',num2str(idx1),'.tif']);

img1(LT_corner(2):RB_corner(2),(LT_corner(1)-Width): (LT_corner(1)-1))=img1(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));
img1(LT_corner(2):RB_corner(2),(RB_corner(1)+1): (RB_corner(1)+Width))=img1(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));


img2(LT_corner(2):RB_corner(2),(LT_corner(1)-Width): (LT_corner(1)-1))=img2(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));
img2(LT_corner(2):RB_corner(2),(RB_corner(1)+1): (RB_corner(1)+Width))=img2(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));


img3(LT_corner(2):RB_corner(2),(LT_corner(1)-Width): (LT_corner(1)-1))=img3(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));
img3(LT_corner(2):RB_corner(2),(RB_corner(1)+1): (RB_corner(1)+Width))=img3(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));


img_dif2=double(img3)-double(img2);
img_dif1=double(img2)-double(img1);


%imwrite(uint8(img_dif2),['./output2/',num2str(idx1),'.tif']);

meanVal(idx1)=mean(mean(abs(img_dif1(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1)))));

 %% select pixels  and track

    [row,col]       =   size(img1);
    probeInterval   =   20;
    probeX          =   linspace(1,col,round(col/probeInterval));
    probeY          =   linspace(1,row,round(row/probeInterval));
    [X,Y]           =   meshgrid(probeX,probeY);
    
    
    X=linspace(Midline,Midline,ProbeNum);
    Y=linspace(LT_corner(2),RB_corner(2),ProbeNum);
    
    X1=[];
    Y1=[];

    
    ProbePos        =   [reshape(X,[],1),reshape(Y,[],1)];

    
    
    
    %%
    [PredictPos,PredictVel,Credibility]=pivTrack(img_dif1,img_dif2,ProbePos,10); % PredictPos is in the form of [x1,y1;x2,y2];PredictVel is in the form of [vx1,vy1;vx2,vy2];In Credibility1 means reliable, 0 is not
    X   =   ProbePos(:,1);  
    Y   =   ProbePos(:,2);
    VX  =   PredictVel(:,1);
    VY  =   PredictVel(:,2);
%     figure,imshow(image2,[]);
%     hold on;
%     quiver(X,Y,VX,VY,0);
%     pause(0.2)
%     hold off;
   VY=VY(find(VY<0));
    Velo_PCV(idx1)=median(VY);
end
%%
X=1:1:(frame_num-2);
plot(X,-smooth(Velo_PCV,1),'Linewidth',2);