

FileIn    = './';
FileName  = 'demo.tif';
FullName =  strcat(FileIn, FileName); %%define the location of the video(tif file)

N=140; %%defien the number of measurent, N<=T-2, in this case, T=151, N=140
Velo_DA=zeros(N,1);


LT_corner=[89,67]; %%define the top left corner of blood vessel (DA) to be measured, pixel value
RB_corner=[110,246]; %%define the bottom right corner of blood vessel (DA) to be measured, pixel value

Width=RB_corner(1)-LT_corner(1)+1;
Height=RB_corner(2)-LT_corner(2)+1;
Midline=LT_corner(1)+Width/2;

ProbeNum=20; %% define the number of probes to be made in the designed region


for idx1=1:1:N

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


%imwrite(uint8(img_dif2),['./output/',num2str(idx1),'.tif']);

img1(LT_corner(2):RB_corner(2),(LT_corner(1)-Width): (LT_corner(1)-1))=img1(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));
img1(LT_corner(2):RB_corner(2),(RB_corner(1)+1): (RB_corner(1)+Width))=img1(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));


img2(LT_corner(2):RB_corner(2),(LT_corner(1)-Width): (LT_corner(1)-1))=img2(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));
img2(LT_corner(2):RB_corner(2),(RB_corner(1)+1): (RB_corner(1)+Width))=img2(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));


img3(LT_corner(2):RB_corner(2),(LT_corner(1)-Width): (LT_corner(1)-1))=img3(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));
img3(LT_corner(2):RB_corner(2),(RB_corner(1)+1): (RB_corner(1)+Width))=img3(LT_corner(2):RB_corner(2),LT_corner(1):RB_corner(1));


img_dif2=double(img3)-double(img2);
img_dif1=double(img2)-double(img1);


 %% select pixels  and track

    [row,col]       =   size(img1); 
    X=linspace(Midline,Midline,ProbeNum);
    Y=linspace(LT_corner(2),RB_corner(2),ProbeNum);    
    ProbePos        =   [reshape(X,[],1),reshape(Y,[],1)];

    
    
    
    %%
    area=30; %%area is the size of area to be compared between frames
    [PredictPos,PredictVel,Credibility]=pivTrack(img_dif1,img_dif2,ProbePos,area); % PredictPos is in the form of [x1,y1;x2,y2];PredictVel is in the form of [vx1,vy1;vx2,vy2];In Credibility1 means reliable, 0 is not
    X   =   ProbePos(:,1);  
    Y   =   ProbePos(:,2);
    VX  =   PredictVel(:,1);
    VY  =   PredictVel(:,2);
    Velo_DA(idx1)=median(VY); %% calculate the median of total mearement between given frames;
end
%%
X=1:1:N;
smoothVal=3;%%defien how much you want to smooth the plot
plot(X,-smooth(Velo_DA,smoothVal),'Linewidth',2); %%plot the velocity 