function A = InitializeConnectivityMatrices_A(n,M)
    
    A = sparse(eye(n^2));
    N = n^2; %number of neurons
    
    for i = 1:N
        R = zeros(1,N-1);
        R(randperm(N-1,M)) = 1;
        mark = (A(i,:) == 0);
        A(i,mark) = R;
    end
    
end