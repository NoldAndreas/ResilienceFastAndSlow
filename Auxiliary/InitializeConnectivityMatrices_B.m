function [B,x1,x2] = InitializeConnectivityMatrices_B(n,c)
    
    x_1D  = 1:n;
    [x1,x2] = meshgrid(x_1D,x_1D); 
    B = sparse(eye(n^2));

    r = sqrt( (x1(:)'-x1(:)).^2 + (x2(:)'-x2(:)).^2); %distance between two points 
    H = c.^r;

    r = sqrt( (x1(:)'-x1(:) -n).^2 + (x2(:)'-x2(:)).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:) + n).^2 + (x2(:)'-x2(:)).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:)).^2 + (x2(:)'-x2(:)-n).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:)).^2 + (x2(:)'-x2(:)+n).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:) -n).^2 + (x2(:)'-x2(:)-n).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:) - n).^2 + (x2(:)'-x2(:) + n).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:) + n).^2 + (x2(:)'-x2(:)-n).^2); %distance between two points 
    H = H + c.^r;

    r = sqrt( (x1(:)'-x1(:) + n).^2 + (x2(:)'-x2(:)+n).^2); %distance between two points 
    H = H + c.^r;

    %consider periodicity!!

    mark = (H > 0.05);
    B(mark) = H(mark);
    B = B/max(sum(B,2));
end