%% HOPFIELD NEURAL NETWORKS

clc
clear all;
citynum = [0.4000 0.4439;0.2439 0.1463;0.1707 0.2293;0.2293 0.761;0.5171 0.9414;0.8732 0.6536;0.6878 0.5219;0.8488 0.3609;0.6683 0.2536;0.6195 0.2634;0.9125 0.9568];
n=11;
A=500;B=500;C=200;D=400;
U0=0.2;
T=0.00001;

for W=1:10
    Vx=0.5+rand(11,11)*0.1;
    Ux=atanh(2*Vx-1)*U0;
time=clock;
display(['W IS ',num2str(W),',CURRENT TIME IS  ',num2str(time(1,4:6))])

for N=1:500
    for i=1:11
        for j=1:11
            sum=0;
            for k=1:11
                if k~=j
                   sum=sum+Vx(i,k);
                end
            end
            d2(i,j)=sum;
        end
    end
    d2=-A*d2;
    
    for j=1:11
        for i=1:11
            sum=0;
            for k=1:11
                if k~=i
                   sum=sum+Vx(k,j);
            end
         end
         d3(i,j)=sum;
        end
    end
    
    d3=-B*d3;
    sum=0;
    
    for i=1:11
        for j=1:11
            sum=sum+Vx(i,j);
        end
    end
    d4=-C*(sum-n);
    d4=d4*ones(11,11);
    d9=zeros(11,1);
    
    for j=1:11
        if j==1
            for i=1:11
                 sum1=0;
                for k=1:11
                    if k~=i
                      
                       sum1=sum1+distance(citynum(i,1),citynum(k,1),citynum(i,2),citynum(k,2))*(Vx(k,2)+Vx(k,11));
                    end    
                end
                d6(i,j)=sum1;
                
            end 
        elseif j==11
            for i=1:11
                sum2=0;
                for k=1:11
                    if k~=i
                       sum2=sum2+distance(citynum(i,1),citynum(k,1),citynum(i,2),citynum(k,2))*(Vx(k,1)+Vx(k,10));
                    end    
                end
                d7(i,1)=sum2;
            end
        else
            
            for i=1:11
                sum3=0;
                for k=1:11
                    if k~=i
                       
                       sum3=sum3+distance(citynum(i,1),citynum(k,1),citynum(i,2),citynum(k,2))*(Vx(k,j-1)+Vx(k,j+1));
                    end    
                end
                d8(i,1)=sum3;
            end
            d9=[d9 d8];
        end
    end
    d10=d9(:,2:10);
    d5=[d6 d10 d7];
    d5=-D*d5;
    d=-Ux+d2+d3+d4+d5;
    Ux=Ux+T*d;
    X=Ux/0.02;
    Vx=[1+tanh(X)]/2;
end    
  for x=1:11
        for i=1:11
            if (Vx(x,i)<0.001)
                Vx(x,i)=0;
            end
            if (Vx(x,i)>0.05)
                Vx(x,i)=1;
            end    
        end
    end  
Vx

%fid = fopen('tsp.txt','a+');
%fprintf(fid,'\n\nnext one\n');
%fprintf(fid,'%5.5f\n',W);
%fprintf(fid,'%3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f %3.3f\n',Vx);
%fclose(fid);
end
%time=clock;
display(['end time is  ',num2str(time(1,4:6))])




