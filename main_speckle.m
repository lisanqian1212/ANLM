%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Demo script 用于斑点噪声去噪，speckle
%casia2代评估噪声水平256为0.012，512为0.025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clf;
clear;
tic
colormap(gray);
imgPath = '\';        % 图像库路径,两个测试集
imgDir  = dir(fullfile(imgPath, '*png')); % 遍历所有jpg格式文件
outDir  =':\GMATLAB\denoise method\NLmeans\NLMretinalS004\';
fileNames={imgDir.name};
for i = 1:length(imgDir) % 遍历结构体就可以一一处理图片了
    
    ima = imread([imgPath imgDir(i).name]);%读取每张照片
    if(size(ima,3)>1)
         ima = rgb2ycbcr(ima);
         ima=ima(:, :, 1);
    end
    ima=im2double(ima);
    ima=imresize(ima,[512,512],"bicubic");
%     noiseSigma=0.025;%超参数512为0.05，256为0.012；
    noiseSigma=0.1;
    level=noiseSigma;%noisy level
    
    
    w=5;    % radius of search area
    f=2;    % radius of similarity area
    

    tic;fima2=UNLmeansfilter2(ima,5,2,1.4,level);toc
%     [PSNRCur, SSIMCur] = Cal_PSNRSSIM(im2uint8(ima),im2uint8(fima1),0,0)
    [PSNRCur1, SSIMCur1] = Cal_PSNRSSIM(im2uint8(ima),im2uint8(fima2),0,0)
    % noise=level;
    % error1=sqrt(mean((fima1(:)-ima(:)).^2))
    % error2=sqrt(mean((fima2(:)-ima(:)).^2))     
    % clf
    % plot(noise,error1,'s-');
    % hold on
    % plot(noise,error2,'or-');
    % xlabel('Noise standard deviation')
    % ylabel('RMSE')
    % legend('NLM','UNLM2');
    % figure(11)
    % %  colormap(gray)
    % %  clf
    % %subplot(2,2,1),imagesc(rima),xlabel('noisy');
    % % subplot(2,2,2)
    %  imshow(fima2,[]);
    %  xlabel('filtered UNLM2');
    figure(222)
    subplot(1,2,1);
    imshow(ima,[]);
    subplot(1,2,2);
%     imshow(fima1,[]);
%     subplot(1,3,3)
    imshow(fima2,[])
    filename=fileNames{i};
%     filename=[int2str(i),'.png'];
%     path1=fullfile(outDir,filename);
    path2=fullfile(outDir1,filename);
%     imwrite(fima1,path1);
    imwrite(fima2,path2);
end
toc
disp(['代码计算时间：',num2str(toc)])

