function snapshot_data = Data_shortTermDynamics(params)

    %**************************************************
    %Parameters    
    %**************************************************    
    n = params.n;
    z0_mean   = params.z0_mean; 
    z0_std    = params.z0_std; 
    
    c = params.c;
    G = params.G;
    D = params.D;
    
    t_plot = params.t_plot;
        
    %**************************************************
    %Parameters    
    %**************************************************    
    %z0_mean   = 0.05; 
    %z0_std    = 0.02;    
       
    %n    = 16;         
    Tmax = max(t_plot);  
    T_start = min(t_plot);% -10;
    %t_plot = [-10,0,10,20,30];
    dt   = 0.005;%0.005; 
    seed = 1;
    %c   = 0.4;
    %G   = 3;
    %D   = -1;
    tau = 4;
    tau_death = 24;    
    seed_start = -0.01;
        
    %**************************************************
    %Initialization    
    %**************************************************    
    rng(seed);
    N         = n^2;
    [B,x1,x2] = InitializeConnectivityMatrices_B(n,c);
    
    [~,idx_seed] = min((x1(:)-n/2).^2+(x2(:)-n/2).^2);    
    %[~,idx_seed] = min((x1(:)-n/4).^2+(x2(:)-n/4).^2);
    
    
    mark_alive = true(N,1);
    ts  = T_start:dt:Tmax;
    t_of_death = -ones(N,1);  
    z = LogNormal(z0_mean,z0_std,N);
    if(isfield(params,'case_global') && ~params.case_global)
        center = (n+1)/2*[1,1];
        stress_width = n/5;
        d1           = sqrt((x1(:) - center(1)).^2 + (x2(:) - center(2)).^2);
        %z   = z0_mean*exp(-d2/(2*stress_width^2));   
        %z = zeros(size(d2));
        if(isfield(params,'z0_mean_base_ratio'))
            z((d1)>stress_width) = params.z0_mean_base_ratio*z((d1)>stress_width);
        else
            z((d1)>stress_width) = 0;
        end
        
        %z = LogNormal(z0_mean,z0_std,N);
    end
    y = z;    
    %z_center = zeros(size(ts));
    %z_center(ts > seed_start) = 0.5;
    
    z_center = zeros(size(ts));
    %z_center(ts > seed_start) = 0.6;
    [~,idx_seed_time] = find(ts-seed_start>0,1,'first');
    z_center(idx_seed_time) = 0.51;
    mark_seed  = false(N,1);
    mark_seed(idx_seed) = 1;
    equilibrium_change = 0;
    
    %******************************************
    %Simulation
    %******************************************
    z_snapshot = [];
    g_snapshot = [];    
    y_snapshot = [];
    t_snapshot = []; 
    markalive_snapshot = []; 
    integrated_load = 0;
    y_equilibrium = [];
    
    for i_ = 1:length(ts)
        t = ts(i_);
        if(z_center(i_) > 0)
            %z(idx_seed) = z(idx_seed) + z_center(i_);
            z(idx_seed) = z_center(i_);
        end
        [dy,g_] = f(z,y,t,mark_alive);
        y(mark_alive) = y(mark_alive) + dy(mark_alive);
                
        mark_dead_new = ((y >= 1) & mark_alive);        
        t_of_death(mark_dead_new) = t;
        mark_alive(mark_dead_new) = false;                 
        
        if(t < seed_start)
            y_equilibrium      = y;            
            equilibrium_change = dy/dt;    
        end
        
        if(~isempty(y_equilibrium) && (t > seed_start) && (t_of_death(idx_seed) == -1))            
            integrated_load = integrated_load + dt*sum(y(~mark_seed)-y_equilibrium(~mark_seed));
        end
        
        if(mod(i_,10)==1)
            t_snapshot(end+1) = ts(i_);
            y_snapshot(:,end+1) = y;
            z_snapshot(:,end+1) = z;
            g_snapshot(:,end+1) = g_;
            markalive_snapshot(:,end+1) = mark_alive;
        end
    end 

    %equilibrium_max_eig = GetMaxEigenvalue(y_equilibrium);
    if(~isempty((y_equilibrium)))
        equilibrium_eig = GetEigenvalue((y_equilibrium));
    else
        equilibrium_eig = Inf;
    end
    snapshot_data = v2struct(t_snapshot,y_snapshot,...
                             z_snapshot,g_snapshot,...
                             markalive_snapshot,...
                             idx_seed,t_of_death,...
                             integrated_load,...
                             y_equilibrium,equilibrium_change,...
                             equilibrium_eig);
                             %equilibrium_max_eig);
    

    
    function [dy,g] = f(z,y,t,mark_alive)
        g_               = zeros(N,1);
        g_(mark_alive)   = G*y(mark_alive).^2;
        g_(~mark_alive)  = D*exp(-(t-t_of_death(~mark_alive))/tau_death);
        g                = B*g_;
        DR = -(y-z) + g;
        dy               = DR/tau*dt;
    end    


    function max_eig = GetMaxEigenvalue(y)                 
       max_eig = max(eig((-eye(N) + 2*G*B*diag(y))/tau));
       disp(['max eig = ',num2str(max_eig)]);
    end

    function eig_ = GetEigenvalue(y)                 
       eig_ = (eig((-eye(N) + 2*G*B*diag(y))/tau));
       %disp(['max eig = ',num2str(max_eig)]);
    end


end