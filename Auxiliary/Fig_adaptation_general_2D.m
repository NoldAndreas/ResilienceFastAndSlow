function data = Fig_adaptation_general_2D(params,var_,variable_var_,var_z)

    time_of_seed_death      = zeros(length(var_z),length(var_));
    integrated_load         = zeros(length(var_z),length(var_));
    mean_y_equilibrium      = zeros(length(var_z),length(var_));
    max_equilibrium_change  = zeros(length(var_z),length(var_));
    equilibrium_max_eig     = zeros(length(var_z),length(var_));
    equilibrium_mean_eig    = zeros(length(var_z),length(var_));
    Gs                      = zeros(length(var_z),length(var_));
    cs                      = zeros(length(var_z),length(var_));
    z0s                     = zeros(length(var_z),length(var_));
    number_of_dead          = zeros(length(var_z),length(var_));


    %iterate through z (constant z)
    f_ = waitbar(0,'Please wait...');
    for i = 1:length(var_z)        
        for j = 1:length(var_)
                    
            params.z0_mean         = var_z(i);            
            params.(variable_var_) = var_(j);            

            snapshot_data = Data_shortTermDynamics(params);

            max_equilibrium_change(i,j) = max(snapshot_data.equilibrium_change);
            
            Gs(i,j)                     = params.G;
            cs(i,j)                     = params.c;
            z0s(i,j)                    = params.z0_mean;
            
            number_of_dead(i,j)         = sum(snapshot_data.markalive_snapshot(:,end)==0);

            if((max_equilibrium_change(i,j) < 1e-2) && (max(snapshot_data.equilibrium_eig)<0))

                time_of_seed_death(i,j)     = snapshot_data.t_of_death(snapshot_data.idx_seed);    

                integrated_load(i,j)        = snapshot_data.integrated_load;
                mean_y_equilibrium(i,j)     = mean(snapshot_data.y_equilibrium);

                equilibrium_max_eig(i,j)    = max(snapshot_data.equilibrium_eig);
                equilibrium_mean_eig(i,j)   = mean(snapshot_data.equilibrium_eig);                   
            end            
        end
        waitbar(i/length(var_z),f_,'Computing..');
    end
    close(f_);
    
    data = v2struct(time_of_seed_death,...
                    integrated_load,...
                    mean_y_equilibrium,...
                    max_equilibrium_change,...
                    equilibrium_max_eig,...
                    equilibrium_mean_eig,...
                    Gs,cs,z0s,...
                    var_z,var_,variable_var_,...
                    number_of_dead);                
                  
end

