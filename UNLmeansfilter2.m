function [output]=UNLmeansfilter2(input,t,f,k,sigma)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  input: image to be filtered
%  t: radio of search window
%  f: radio of similarity window
%  k: degree of filtering
%  sigma: noise standard deviation
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Size of the image
[m n]=size(input);

% Memory for the output
output=zeros(m,n);
sweight=zeros(m,n);%%

% Replicate the boundaries of the input image
input2 = padarray(input,[f f],'symmetric');

% Used kernel
kernel = make_kernel(f);
kernel = kernel / sum(sum(kernel));

h=(k*sigma)^2;
s2=2*sigma*sigma;%%

fs=fspecial('average');%%
aux=imfilter(input2,fs,'symmetric');%%

for i=1:m
    for j=1:n
        
        i1 = i+ f;
        j1 = j+ f;
        
        W1= input2(i1-f:i1+f , j1-f:j1+f);
        
        rmin = max(i1-t,f+1);
        rmax = min(i1+t,m+f);
        smin = max(j1-t,f+1);
        smax = min(j1+t,n+f);
        
        for r=i1:1:rmax
            for s=smin:1:smax
                
                if(s<=j1 && r==i1)
                    continue;end;
                
                if(abs(aux(i1,j1)-aux(r,s))>sigma)
                    continue;end;
                
                W2= input2(r-f:r+f , s-f:s+f);
                
                d = sum(sum(kernel.*(W1-W2).*(W1-W2)));
                d=d/h;
                w=1/(1+d*d);
                
                sweight(i,j) = sweight(i,j) + w;
                output(i,j)=output(i,j) + w*input2(r,s)*input2(r,s);
                
                sweight(r-f,s-f) = sweight(r-f,s-f) + w;
                output(r-f,s-f)=output(r-f,s-f) + w*input2(i1,j1)*input2(i1,j1);
                
            end
            
        end
        
        sweight(i,j) = sweight(i,j) + 0.5;
        output(i,j)=output(i,j) + 0.5*input(i,j)*input(i,j);
        
        % Rician correction
        
        output(i,j) = sqrt(max(0,output(i,j)/sweight(i,j)-s2));
        
    end
end


function [kernel] = make_kernel(f)

if(f==0)
    kernel=1;
    return;
end;

kernel=zeros(2*f+1,2*f+1);

for d=1:f
    
    value= 1 / (2*d+1)^2 ;
    
    for i=-d:d
        for j=-d:d
            kernel(f+1-i,f+1-j)= kernel(f+1-i,f+1-j) + value ;
        end
    end
end

kernel = kernel ./ f;

