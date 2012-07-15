%% SOLVING TRAVELING SALESMAN PROBLEM USING HOPFIELD NN

function tsp
% NUMBER OF CITIES (CHANGE THE VALUE OF N TO 5 AND 11 FOR TESTING 5 CITY AND 11 CITY TSP)
N=11;%5%11
% OF THE CITY COORDINATES AND THE DISTANCE BETWEEN CITIES
cityx=[0.4,0.2439,0.1707,0.2293,0.5171,0.8732,0.6878,0.8488,0.6683,0.6195,0.9125];
cityy=[0.4439,0.1463,0.2293,0.761,0.9414,0.6536,0.5219,0.3609,0.2536,0.2634, 0.9568];

for i=1:1:N
    for j=1:1:N
        d(i,j)=sqrt((cityx(i)-cityx(j))^2+(cityy(i)-cityy(j))^2);
    end
end

% NETWORK PARAMETERS..
A=500;
B=500;
C=1000;
D=500;
u0=0.02;
tao=1;
lamda=0.0001;
total=0;

% OBTAIN A VALID SOLUTION..
% STATISTICS OBTAINED FOR EACH SOLUTION TO A LEGAL SOLUTION..
% HOW MANY TIMES THE ILLEGAL..

% END OF THE FLAG..
toend=0;
time=clock;
display(['CURRENT TIME IS  ',num2str(time(1,4:6))])

while toend==0
    total=total+1
    % INITIALIZE THE ARRAY AND TRANSPOSE
    V=rand(N,N);
    U=atanh(2*V-1)*u0;
    % OF THE STATE UPDATE
    for renew=1:1:1000
        % SYNC
        for ux=1:1:N
            for ui=1:1:N
                m1=0;
                m2=0;
                m3=0;
                m4=0;
                % FIRST DERIVATIVE FORMULA
                for j=1:1:N
                    if j~=ui
                        m1=m1+V(ux,j);
                    end                   
                end
                m1=-A*m1;
                % SECOND DERIVATIVE FORMULA
                for y=1:1:N
                    if y~=ux
                        m2=m2+V(y,ui);
                    end
                end
                m2=-B*m2;
                % THIRD DERIVATIVE FORMULA
                for x=1:1:N
                    for j=1:1:N
                        m3=m3+V(x,j);
                    end
                end
                m3=-C*(m3-N);
                
                % DERIVATION FORMULA FOR THE FOURTH
                for y=1:1:N
                    if y~=ux
                        if ui==1
                            m4=m4+d(ux,y)*(V(y,ui+1)+V(y,N));
                        elseif ui==N
                            m4=m4+d(ux,y)*(V(y,ui-1)+V(y,1));
                        else
                            m4=m4+d(ux,y)*(V(y,ui+1)+V(y,ui-1));
                        end
                    end  
                end
                m4=-D*m4;
                Udao(ux,ui)=-U(ux,ui)+m1+m2+m3+m4;
            end
        end
        % DERIVATIVE AND STATUS UPDATES          
        U=U+lamda*Udao;
        V=(1+tanh(U/u0))/2;
        for ux=1:1:N
            for ui=1:1:N
                if V(ux,ui)<0.3
                    V(ux,ui)=0;
                end
                if V(ux,ui)>0.7
                    V(ux,ui)=1;
                end 
            end
        end
    end
    V;
    % TO DETERMINE WHETHER A LEGAL SOLUTION
    % GLOBAL CONSTRAINT MATRIX TRANSPOSITION, REQUIRING A TOTAL OF N 1

    test1=0;
    for ux=1:1:N
        for ui=1:1:N
            test1=test1+V(ux,ui);
        end
    end  
    % OF THE CITY LINE CONSTRAINTS, MORE THAN A 1 PER LINE
    test2=0;
    for x=1:1:N
        for i=1:1:N-1
            for j=i+1:1:N
                test2=test2+V(x,i)*V(x,j);
            end
        end
    end    
    % OF THE CITY COLUMN CONSTRAINTS, MORE THAN A 1 IN EACH COLUMN
    test3=0;
    for i=1:1:N
        for x=1:1:N-1
            for y=x+1:1:N
                test3=test3+V(x,i)*V(y,i);
            end
        end
    end
    % WHEN THE SOLUTION IS VALID WHEN, OUT OF THE LOOP
    if test1==N && test2==0 && test3==0
        toend = 1;
    else
        toend=0;
    end
end

time=clock;
display(['END TIME IS ',num2str(time(1,4:6))])
V
total
% REARRANGE THE CITY BY THE RESULTS OF THE COORDINATES
for j=1:1:N
    for i=1:1:N
        if V(i,j)==1
            cityx_final(j)=cityx(i);
            cityy_final(j)=cityy(i);
        end
    end
end
% OF THE TOTAL PATH LENGTH
cityx_final(N+1)=cityx_final(1);
cityy_final(N+1)=cityy_final(1);
cityx_final
cityy_final
td=0;

for i=1:1:N-1
    td=td+sqrt((cityx_final(i)-cityx_final(i+1))^2+(cityy_final(i)-cityy_final(i+1))^2);
end

td=td+sqrt((cityx_final(N)-cityx_final(1))^2+(cityy_final(N)-cityy_final(1))^2);
td
plot(cityx_final,cityy_final,'o-');

%%END


