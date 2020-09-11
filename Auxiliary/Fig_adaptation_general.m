function data = Fig_adaptation_general(params,var_,variable_var_)

    time_of_seed_death     = zeros(length(var_),1);
    integrated_load        = zeros(length(var_),1);
    mean_y_equilibrium     = zeros(length(var_),1);
    max_equilibrium_change = zeros(length(var_),1);
    equilibrium_max_eig    = zeros(length(var_),1);
    equilibrium_mean_eig   = zeros(length(var_),1);
    Gs                     = zeros(length(var_),1);
    cs                     = zeros(length(var_),1);
    number_of_dead         = zeros(length(var_),1);
        
    f_ = waitbar(0,'Please wait...');
    for i = 1:length(var_)        
        params.(variable_var_) = var_(i);            


        snapshot_data = Data_shortTermDynamics(params);
        
        max_equilibrium_change(i) = max(snapshot_data.equilibrium_change);
        Gs(i)                     = params.G;
        cs(i)                     = params.c;  
        
        number_of_dead(i)         = sum(snapshot_data.markalive_snapshot(:,end)==0);
        
        if(true)
            time_of_seed_death(i)     = snapshot_data.t_of_death(snapshot_data.idx_seed);    
            
            integrated_load(i)        = snapshot_data.integrated_load;
            mean_y_equilibrium(i)     = mean(snapshot_data.y_equilibrium);

            equilibrium_max_eig(i)    = max(snapshot_data.equilibrium_eig);
            equilibrium_mean_eig(i)   = mean(snapshot_data.equilibrium_eig);                    
        end
        waitbar(i/length(var_),f_,'Computing..');
    end
    close(f_);
    
    data = v2struct(time_of_seed_death,...
                    integrated_load,...
                    mean_y_equilibrium,...
                    max_equilibrium_change,...
                    equilibrium_max_eig,...
                    equilibrium_mean_eig,...
                    Gs,cs,var_,variable_var_,...
                    number_of_dead);                    
end

