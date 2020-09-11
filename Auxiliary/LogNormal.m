function h = LogNormal(mu,sigma,n)         
    mu_L    = log(mu/sqrt(1 + sigma^2/mu^2)); 
    sigma_L = sqrt(log(1+sigma^2/mu^2));    
    h       = exp(normrnd(mu_L,sigma_L,[n,1])); 
end