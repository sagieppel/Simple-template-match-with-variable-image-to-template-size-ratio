function [Ismarked,Iborders,Ybest,Xbest, ItmSize, BestScore]= MAIN_find_object_in_image(Is,Itm, Itm_dilation)
%{
Find Template Itm in image Is.
The  template does not have to fit the size of the object in the image. 
The program scan various of size ratios of template to image to find the location and size ratios of the best match. 
The function can use template match to find the object in the image 

Input (Essential):
Is: Color image with the object to be found.
Itm: Template of the object to be found. The template is written as binary image with the boundary of the template marked 1(white) and all the rest of the pixels marked 0. 
Template of object Itm could be created by extracting the object boundary in image with uniform background, 
this could be done (for symmetric objects) using the code at: http://www.mathworks.com/matlabcentral/fileexchange/46887-find-boundary-of-symmetric-object-in-image

Optional input
Itm_dilation: The amount of dilation for of the template. How much the template line will be thickened  (in pixels) for each side before crosscorelated with the image. 
 The thicker the template the better its chance to overlap with edge of object in the image and more rigid the recognition process, however thick template can also reduce recognition accuracy. 
The default value for this parameter is 1/40 of the average dimension size of the template Itm.

Output
Ismarked: The image (Isresize) with the template marked upon it in the location of and size of the best match.
Iborders: Binary image of the borders of the template/object in its scale and located in the place of the best match on the image. 
Ybest Xbest: location on the image (in pixels) were the template were found to give the best score (location the top left pixel of the template Itm in the image).
ItmSize: The size of  the template that give the best match
BestScore: Score of the best match found in the scan (the score of the output).



%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%initialize optiona paramters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin<1)  Is=imread('Is.jpg');  end; %Read image
if (nargin<2)  Itm=imread('Itm.tif');end; %Read template image
if (nargin<3)    
    Sitm=size(Itm);
    Itm_dilation=floor(sqrt(Sitm(1)*Sitm(2))/80); % dilation level of the template. 
    %In order to avoid the edge from missing correct point by dilation the size of dilation is proportinal to the size of the item template dimension.
end;
Is=rgb2gray(Is);
Itm=logical(Itm);% make sure Itm is boolean image
BestScore=-100000;
close all;
imtool close all;
%%%%%%%%%%%%%%%%Some parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555555555
St=size(Itm);
Ss=size(Is);
SizeRatio=min(Ss(1)/St(1), Ss(2)/St(2)); % size ratio between the template Itm and image Is (minimum dimension)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Main Scan  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------Resize template Itm in each cycle and search for the template in the target image Is-----------------------------------------------------------------------------------------------------------------------
%Start by resizing the tempplate Itm to the max size that fit the image Is and then resize shrinked it in 
%Jumps of 0.5% and use hough/template match for every resized  version to the image
for Scale=100:-0.5:2   % Determine the size of the template Itm in each step of the loop in percetage (100 is original size)  
    disp([num2str(100-Scale) '% Scanned']); 
    Itr=Resize_binary_edge_image(Itm,SizeRatio*Scale/100); % resize the template line while maintianing it is binary close countour line image with thinkness of 1 pixel 
    St=size(Itr);% write the new size of resize template Itr
      if (St(1)*St(2)<400) break; end; %if the resize template contain less then 300 pixels it is to for practical matching and the loop is terminated
 %----------------------------------------------------------------------------------------------------------------------------------------- 
 % the actuall recogniton step of the resize template Itm in the orginal image Is and return location of best match and its score can occur in one of three modes given in search_mode
               [score,  y,x ]=Template_match(Is,Itr,Itm_dilation); %apply template matching here and return list of good points (x,y) and their scoring
  
     %--------------------------if the correct match score is better then previous best match write the paramter of the match as the new best match------------------------------------------------------
     if (score(1)>BestScore) % if item  result scored higher then the previous result
           BestScore=score(1);% remember best score
             Ybest=y(1);% mark best location y
           Xbest=x(1);% mark best location x
           ItmSize=size(Itr);
     end;
%-------------------------------mark best found location on image----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------        
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%output%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%show   best match optional part can be removed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if BestScore>-100000% Display best match
      Itr=Resize_binary_edge_image(Itm,ItmSize(1),ItmSize(2));
            [yy,xx] =find(Itr);
             Ismarked=set2(Is,[yy,xx],255,Ybest,Xbest);%Mark best match on image
            imshow(Ismarked);
            Iborders=logical(zeros(size(Is)));
       Iborders=set2(Iborders,[yy,xx],1,Ybest,Xbest);
else % if no match 
   disp('Error no match founded');
    Ismarked=0;% assign arbitary value to avoid 
       Iborders=0;
       Iborders=0;
    
end;
end