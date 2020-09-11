function snapshot_data = Fig_shortTermDynamics_x(axs,axs_colorbar,axs_ana,params,title_str)

    %******************************************
    % Initialization
    %******************************************    
    t_plot = params.t_plot;
    n      = params.n;
    Tmax = max(t_plot);  
    T_start = min(t_plot);% -10;

    %******************************************
    %Simulations
    %******************************************
    snapshot_data = Data_shortTermDynamics(params);
    
    t_snapshot = snapshot_data.t_snapshot;
    z_snapshot = snapshot_data.z_snapshot;
    y_snapshot = snapshot_data.y_snapshot;
    g_snapshot = snapshot_data.g_snapshot;
    markalive_snapshot = snapshot_data.markalive_snapshot;
    idx_seed = snapshot_data.idx_seed;
    t_of_death = snapshot_data.t_of_death;
    
    %******************************************
    
    caxis_1 = [0,1];
    caxis_2 = [-0.15,0.6];
    caxis_3 = [0,1];       
    
    
    n_cols = length(t_plot);    
    for i_ = 1:n_cols
        [~,idx] = min(abs(t_snapshot-t_plot(i_)));       
        
        ax = axs(i_);
        axes(ax);                
        PlotBirdView_revised(reshape(y_snapshot(:,idx),n,n),markalive_snapshot(:,idx));
        cmap_3 = colormap(ax,brewermap(9,'Purples'));%Greys BuPu Blues
        caxis(caxis_3); 
    end
    
    %************************
    %Colorbar    
    colormap(axs_colorbar,cmap_3);    
    h = colorbar(axs_colorbar);  
    h.Box = 'off';
    h.Label.String = {title_str,'Acute damage x'};
    set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    set(h, 'YAxisLocation','left');    
    caxis(axs_colorbar,caxis_3);
    set(axs_colorbar,'Visible','off');
    
    
    %************************
    %Plot analysis
    axes(axs_ana);
    plot(t_snapshot,y_snapshot(idx_seed,:),'k'); hold on;
    ylim([0,1]);
    YL = ylim();
    plot([0,0],YL,'k--','linewidth',1);     
    h_ = text(0,YL(2)/2,'Seed induction','FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom'); %'FontSize',14                    
    set(h_,'Rotation',90);
    %xlabel('Time (hours)');
    
    if((t_of_death(idx_seed) > 0) ) 
        plot(t_of_death(idx_seed)*[1,1],YL,'k:','linewidth',1);     
        
        if(~isfield(params,'text_seed_removal') || params.text_seed_removal)
            text(t_of_death(idx_seed),YL(2)/2,'Seed removal','FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'top',...
                        'Rotation',90); %'FontSize',14        
        end
    end
    if(T_start == 0)
        xlim([-5 Tmax]);
    else
        xlim([T_start Tmax]);
    end
    ylim(caxis_3);
    %ylabel('x_{center}');    
    ylabel({'Acute damage x';'at seed'}); % d_{center}
    
    
end