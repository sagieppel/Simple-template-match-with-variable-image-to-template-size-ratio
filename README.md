# Simple-template-match-with-variable-image-to-template-size-ratio
Find template Itm (binary image) in the canny edge image of image Is (Grayscale image).
Simple template match with variable size ratio. Find template Itm (binary image) in the canny edge image of image Is (Grayscale image). The template size don’t need to be identical to the target in the image, scan various of size ratios. The template Itm . 
INPUT: Is colour image where the template should be found. 
Itm: The template Binary image. 
OUTPUT: the location of the best match (x,y) the score of the match . Show (Is) the image with best match marked on it. Also return the resize image Is and resize template, in the size ratio that gave the best match. 
Method: Scan various of size ratios between the template Itm and the image Is, and found the size ratio and location in the image Is where template Itm best match. Use simple template match cross correlation between the canny edge of image Is and the template Itm. 
Main function: MAIN_find_template_in_image
