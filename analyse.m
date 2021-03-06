%homo is 3x3 matrix
%just calculating from first coords for ease
function [trans, ang, scale]=  analyse(homo)
    %calcimgcoords=zeros(size(imgcoords,1),3);
    homograph=homo
    inverse_homo=inv(homo)
    affine=zeros(3,3);
    affine(3,:)=[0,0,1];
    affine(1,3)=homo(1,3);
    affine(2,3)=homo(2,3);
    affine(1,2)=((homo(1,2)+homo(1,3))/(1+homo(3,2)))-affine(1,3);
    affine(2,1)=((homo(2,1)+homo(2,3))/(homo(3,1)+1))-affine(2,3);
    affine(2,2)=((homo(2,2)+homo(2,3))/(homo(3,2)+1))-affine(2,3);
    affine(1,1)=((homo(1,1)+homo(1,3))/(homo(3,1)+1))-affine(1,3);
    affine
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
    ycoords=h*[0;1;1];
    
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