function B=eyepairdetect(I,BB)
a=40;
if ~isempty(BB)
    J=I(BB(2)-a:BB(2)+BB(4)+a,BB(1)-a:BB(1)+BB(3)+a);
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    B=step(EyeDetect,J);
    sz=size(B);
    if sz(1)
        if sz(1)>1
            [C,K]=max(B);
            B=B(K(3),:);
        end
        B(1)=BB(1)-a+B(1);
        B(2)=BB(2)-a+B(2);
    end
else
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    B=step(EyeDetect,I);
    sz=size(B);
    if sz(1)>1
        [C,K]=max(B);
        B=B(K(3),:);
    end
end
end


