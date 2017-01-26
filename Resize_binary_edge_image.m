function [mat]=Resize_binary_edge_image(I,Sy,Sx)
%{
Resize binary (logical) edge image I to new size Sy,Sx or to by size ratio
Sy (if Sx is not inserted), The resize image will also also be a binary edge image.
The connectivity/topology of all edges/curves in the original image I will be
maintained and the line thickness of the curves in the output image mat will
remain 1 pixel.

 
Input
I: Binary  edge image (logical type) consist of lines and curves with thickness of one pixels (such as curves, contour line, template, or edge images)

Sy,Sx: The size of the resized image
OR
Sy (no Sx) the scale ratio of the resized image to the original image

Output
mat: Resized version of the input image I, also binary edge image, the connectivity/topology of the edges/curves in I is maintain and also the line thickness remain one pixel

Note:
In addition to enlarging/shrinking of images can also be used to stretch edge images by using different  proportions (Sx,Sy) of output image dimension  to input image dimension .
%}
%close all;
[Hight,Width]=size(I);
if nargin==2 % if there is no Sx assume that Sy is the scale ratio between  the resized image and input image I else assume that Sy,Sx are the dimension of the new image
    Sx=round(Sy*Width);
    Sy=round(Sy*Hight);
end;
mat = logical(zeros(Sy,Sx));
dx=Sx/Width;
dy=Sy/Hight;
 [y,x]=find(I);
 [n,tt]=size(x);
for f=1:n
    if x(f)>1 && I(y(f),x(f)-1)==1 % Connect horizontal neighbour 
        mat=ConnectPoints(mat,round(x(f)*dx),round(y(f)*dy),round((x(f)-1)*dx),round(y(f)*dy));
    end;
    if y(f)>1 && I(y(f)-1,x(f))==1 %connect vertical neighbour
          mat=ConnectPoints(mat,round(x(f)*dx),round(y(f)*dy),round((x(f))*dx),round((y(f)-1)*dy));
    end;
    if y(f)>1  && x(f)>1 &&  I(y(f)-1,x(f))==0 && I(y(f),x(f)-1)==0 && I(y(f)-1,x(f)-1)==1 % connect diagonal neighbor
        mat=ConnectPoints(mat,round(x(f)*dx),round(y(f)*dy),round((x(f)-1)*dx),round((y(f)-1)*dy));
    end;
     if y(f)>1  && x(f)<Width &&  I(y(f)-1,x(f))==0 && I(y(f),x(f)+1)==0 && I(y(f)-1,x(f)+1)==1 % connect second diagonal neighbor
         mat=ConnectPoints(mat,round(x(f)*dx),round(y(f)*dy),round((x(f)+1)*dx),round((y(f)-1)*dy));
    end; 
end;
%imshow(mat);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mat]=ConnectPoints(mat,x1,y1,x2,y2)
% draw line between x1,y1 to x2,y2 on binary image mat
%make sure cordinates are inside image mat
SizeMat=size(mat);
x1=max(x1,1);x2=max(x2,1);y1=max(y1,1);y2=max(y2,1);
y1=min(y1,SizeMat(1));y2=min(y2,SizeMat(1));x1=min(x1,SizeMat(2));x2=min(x2,SizeMat(2));

if x1==x2 % for horizontal line
 
    y=linspace(y1,y2,abs(y1-y2)*5);
      x = ones(size(y))*x1;
else % for none horizontal line
   x = linspace(x1,x2,abs(x1-x2)*5+abs(y1-y2)*5);   
   y = y1+(x-x1)*(y2-y1)/(x2-x1);                     
end;
round(y);
   index = sub2ind(size(mat),round(y),round(x));  
    mat(index) = 1;   
   %imshow(mat)
   %pause(0.1);
end