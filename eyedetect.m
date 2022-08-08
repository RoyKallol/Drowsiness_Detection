function [C,R]=eyedetect(J,preC,preR,BB)
sz=size(J);
senm=0.96;
vdif=25;
mndark=150;
[A,B]=meshgrid(1:sz(2),1:sz(1));
Rmin=floor(sz(1)/5);
Rmax=floor(sz(1)/2);
% if ~isempty(preR)
%     Rmin=floor(preR-2)
%     Rmax=floor(preR+2)
% end
sen=0.9;
CL=[];RL=[];
while isempty(RL)
    if sen>senm
        break;
    end
    [CL,RL] = imfindcircles(J(:,1:floor(sz(2)/2)),[Rmin Rmax],'ObjectPolarity','dark','Sensitivity',sen);
    value=inf;
    for j=1:length(RL)
        D=((A-CL(j,1)).^2+(B-CL(j,2)).^2).^.5;
        value1=mean(J(find(D<RL(j))));
        value2=mean(J(find(D>RL(j) & D<2*RL(j))));
        if value1<value2-vdif
            value(j)=value1;
        else
            value(j)=inf;
        end
    end
    if min(value)<mndark
        [mn,I]=min(value);
        CL=CL(I,:);RL=RL(I);
    else
        CL=[]; RL=[];
    end
    sen=sen+0.01;
end
sen=0.9;
CR=[];RR=[];
while isempty(RR)
    if sen>senm
        break;
    end
    [CR,RR] = imfindcircles(J(:,floor(sz(2)/2):sz(2)),[Rmin Rmax],'ObjectPolarity','dark','Sensitivity',sen);
    value=inf;
    for j=1:length(RR)
        CR(j,1)=CR(j,1)+floor(sz(2)/2);
        D=((A-CR(j,1)).^2+(B-CR(j,2)).^2).^.5;
        value1=mean(J(find(D<RR(j))));
        value2=mean(J(find(D>RR(j) & D<2*RR(j))));
        if value1<value2-vdif
            value(j)=value1;
        else
            value(j)=inf;
        end
    end
    if min(value)<mndark
        [mn,I]=min(value);
        CR=CR(I,:);RR=RR(I);
    else
        CR=[];
        RR=[];
    end
    sen=sen+0.01;
end
C=[];R=[];
if ~isempty(RL) && ~isempty(RR) && abs(RR-RL)<1.5 && abs(CL(2)-CR(2))<10
   %if (~isempty(preR) && abs(RR-preR)<2 && abs(RL-preR)<2) || isempty(preR)
    if (~isempty(preR) && RR<(preR+2) && RL<(preR+2)) || isempty(preR)
        C=[CL;CR];R=[RL;RR];
        C(:,1)=C(:,1)+BB(1); % Adjusting Center position
        C(:,2)=C(:,2)+BB(2);
    end
% elseif ~isempty(RL)
%     C=CL;R=RL;
% elseif ~isempty(RR)
%     C=CR;R=RR;
end
end

