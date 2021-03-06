%homo is 3x3 matrix
%just calculating from first coords for ease
function [trans, ang, scale]=  analyseaffine(affine)
    %calcimgcoords=zeros(size(imgcoords,1),3);
    homo=affine;
    %extract translational properties
    res=homo*[0;0;1];
    h=homo/res(3);
    zerocoords=h*[0;0;1];
    zerocoords(:)=zerocoords(:)/zerocoords(3);
    trans=zerocoords(1:2);
    
    %x is set to 0
    %res=homo*[0;1;1];
    %h=homo/res(3);
    ycoords=homo*[0;1;1];
    
    %ycoords=homo*[0;1;1];
    ycoords(:)=ycoords(:)/ycoords(3);%
    tany=(ycoords(1)-trans(1))/(ycoords(2)-trans(2));
    ang= atan(tany);
    scale=(ycoords(1)-trans(1))/sin(ang);
    ang=rad2deg(ang);
    
    %{
    %y is set to 0
    xcoords=homo*[0;1;1];
    xcoords(:)=xcoords(:)/xcoords(3); 
    
    for pt= 1: size(imgcoords,1)
        calcimgcoords(pt,:)=homo*[squeeze(imgcoords(pt,:)).';1];
        calcimgcoords(pt,:)=calcimgcoords(pt,:)/calcimgcoords(3);

        translate= homo/z;
        trans
    end
    %}
end