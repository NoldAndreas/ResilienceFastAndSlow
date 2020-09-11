function Fig_shortTermDynamics(axs,axs_colorbar,axs_ana,params)

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
        
        ax = axs(1,i_);
        axes(ax);
        PlotBirdView_revised(reshape(z_snapshot(:,idx),n,n),markalive_snapshot(:,idx));
        cmap_1 = colormap(ax,brewermap(9,'Reds'));
        if(t_snapshot(idx) < 0)
            title(['Initial'],'FontWeight','Normal');        
        else
            title([num2str(t_snapshot(idx)),' hours'],'FontWeight','Normal');        
        end
        caxis(caxis_1);
        
        ax = axs(2,i_);
        axes(ax);
        PlotBirdView_revised(reshape(g_snapshot(:,idx),n,n),markalive_snapshot(:,idx));
        %cmap_2 = flipud(brewermap(16,'RdBu'));        
        cmap_2 = flipud(brewermap(16,'BrBG'));        %BrBG
        cmap_2 = cmap_2([1,5,9:end],:)
        colormap(ax,cmap_2);
        caxis(caxis_2);                
        %if(i_==1)
        %    ylabel('Tissue acitvity');
        %end
        
        ax = axs(3,i_);
        axes(ax);                
        PlotBirdView_revised(reshape(y_snapshot(:,idx),n,n),markalive_snapshot(:,idx));
        cmap_3 = colormap(ax,brewermap(9,'Purples'));%Greys BuPu Blues
        caxis(caxis_3);
        %if(i_==1)
        %    ylabel('Acute damage');
        %end
        
    end
    
    %************************
    %Colorbar    
    colormap(axs_colorbar(1),cmap_1);    
    h = colorbar(axs_colorbar(1),'XTick',[0,0.5,1]);
    caxis(axs_colorbar(1),caxis_1);
    h.Box = 'off';
    h.Label.String = 'Baseline damage z';
    set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    set(h, 'YAxisLocation','left');
    set(axs_colorbar(1),'Visible','off');
    
    colormap(axs_colorbar(2),cmap_2);    
    h = colorbar(axs_colorbar(2));    
    caxis(axs_colorbar(2),caxis_2);
    h.Box = 'off';
    h.Label.String = 'Tissue activity d';
    set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    set(h, 'YAxisLocation','left');
    set(axs_colorbar(2),'Visible','off');
    
    colormap(axs_colorbar(3),cmap_3);    
    h = colorbar(axs_colorbar(3));  
    h.Box = 'off';
    h.Label.String = 'Acute damage x';
    set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    set(h, 'YAxisLocation','left');    
    caxis(axs_colorbar(3),caxis_3);
    set(axs_colorbar(3),'Visible','off');
    
    
    %************************
    %Plot analysis
    axes(axs_ana(1));
    plot(t_snapshot,z_snapshot(idx_seed,:),'k'); hold on;
    ylim(caxis_1);
    YL = ylim();
    plot([0,0],YL,'k--','linewidth',1); 
    plot(t_of_death(idx_seed)*[1,1],YL,'k:','linewidth',1);     
    xlim([T_start Tmax]);
    %xticks(t_plot);
    
    ylabel({'Baseline damage z';'at seed'});%('z_{center}');
    
    axes(axs_ana(2));
    plot(t_snapshot,g_snapshot(idx_seed,:),'k'); hold on;    
    %xticks(t_plot);
    xlim([T_start Tmax]);
    ylim(caxis_2);
    YL = ylim();
    plot([0,0],YL,'k--','linewidth',1); 
    plot(t_of_death(idx_seed)*[1,1],YL,'k:','linewidth',1); 
    ylabel({'Tissue activity d';'at seed'}); % d_{center}
    
    axes(axs_ana(3));
    plot(t_snapshot,y_snapshot(idx_seed,:),'k'); hold on;
    YL = ylim();
    plot([0,0],YL,'k--','linewidth',1);     
    h_ = text(0,YL(2)/2,'Seed induction','FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom'); %'FontSize',14                    
    set(h_,'Rotation',90);
    xlabel('Time (hours)');
    
    if(t_of_death(idx_seed) > 0)
        plot(t_of_death(idx_seed)*[1,1],YL,'k:','linewidth',1);     
        h_ = text(t_of_death(idx_seed),YL(2)/2,'Seed removal','FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom',...
                        'Rotation',90); %'FontSize',14        
    end
    xlim([T_start Tmax]);
    ylim(caxis_3);
    ylabel({'Acute damage x';'at seed'});%('z_{center}');
    %ylabel('x_{center}');    
    
    
end