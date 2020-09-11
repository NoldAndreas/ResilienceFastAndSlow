function Fig7_Transitions
    params = struct('z0_mean',0.1,'z0_std',0.02,...
                        'c',0.2,'D',-1,'G',1.5,...
                        't_plot',[-100,0,10,20,30,60],'n',20,...
                        'case_global',true);
    no_zeros = true;
    
    if(isfile('Fig7_adaptation_constant.mat'))        
        load('Fig7_adaptation_constant.mat','data_global','data_local','snapshot_global','snapshot_local');        
        disp('loaded Fig7_adaptation_constant.mat');
    else
        %****************************************
        % Elevated global z, adapt G
        %****************************************
        disp('Part 1/2 ..');
        params = struct('z0_mean',0.1,'z0_std',0.02,...
                        'c',0.2,'D',-1,'G',1.5,...
                        't_plot',[-100,0,10,20,30,60],'n',20,...
                        'case_global',true);                

        var_          = linspace(.0,3,50);
        variable_var_ = 'G';
        data_global     = Fig_adaptation_general(params,var_,variable_var_);
        snapshot_global = Data_shortTermDynamics(params);

        %****************************************
        % Elevated local z, adapt c
        %****************************************
        disp('Part 2/2 ..');
        params = struct('z0_mean',0.15,'z0_std',0.02,...
                        'c',0.45,'D',0,'G',2.,...
                        't_plot',[-200,0,50,100],...
                        'n',20,...
                        'case_global',false,...
                        'z0_mean_base_ratio',0.5);                   

        var_          = linspace(0.4,0.6,50);
        variable_var_ = 'c';
        data_local   = Fig_adaptation_general(params,var_,variable_var_);
        snapshot_local = Data_shortTermDynamics(params);

        save('Fig7_adaptation_constant.mat','data_global','data_local','snapshot_global','snapshot_local');
    end

    data_global    = PostProcess(data_global);
    data_local     = PostProcess(data_local);
    snapshot_datas = [snapshot_global,snapshot_local];
    datas          = [data_global,data_local];

    %****************************************
    % Plotting stupid analysis
    %****************************************
    figure
    for i = 1:length(snapshot_datas)

        data          = datas(i);
        snapshot_data = snapshot_datas(i);
        subplot(1,2,i);
        plot(data.var_,data.max_equilibrium_change,'k');
    end

    %****************************************
    % Plotting Fig 3
    %****************************************
    fig1 = figure('Units', 'centimeters','Position', [0, 0, 15,9],...
           'PaperUnits', 'centimeters', 'PaperSize', [15,9],...
           'PaperPositionMode','Auto');

    caxis_1 = [0,0.5];
    left_alignment = 1;
    top_alignment = 5;
    axs = [];
    axs_colorbar = [];
    axs_ans = [];
    w = 3;
    w_vertical = 3;
    w_spacing = 4.5;
    w_spacing_vertical = 4;
    for i1 = 1:2
        top  = top_alignment - w_spacing_vertical*(i1-1);

        left = left_alignment;
        axs(i1,1) = axes('Units', 'centimeters','Position', [left top w*0.2 w_vertical]);    

        left = left + 1.;    
        axs(i1,2) = axes('Units', 'centimeters','Position', [left top w w_vertical]);

        for i2 = 3:4
            left = left + w_spacing;    
            axs(i1,i2) = axes('Units', 'centimeters','Position', [left top w w_vertical]);
        end

    end



    for i = 1:length(snapshot_datas)

        data          = datas(i);
        snapshot_data = snapshot_datas(i);

        if(data.variable_var_ == 'G')
            str_xlabel = 'Responsiveness G';
        elseif(data.variable_var_ == 'c')
            str_xlabel = 'Focal range c';
        else
            print('ERROR');
        end

        idx = 505;
        ax = axs(i,2);
        axes(ax);
        PlotBirdView_revised(reshape(snapshot_data.z_snapshot(:,idx),params.n,params.n),...
                                     snapshot_data.markalive_snapshot(:,idx));                    
        cmap_1 = colormap(ax,brewermap(9,'Reds'));
        caxis(caxis_1);


        colormap(axs(i,1),cmap_1);    
        h = colorbar(axs(i,1)); %,'XTick',[0,0.5,1]
        caxis(axs(i,1),caxis_1);
        h.Box = 'off';
        h.Label.String = 'Baseline damage z';
        set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
        set(h, 'YAxisLocation','left');
        set(axs(i,1),'Visible','off');


        ax = axs(i,3);
        axes(ax);
        typical_time = data.time_of_seed_death;
        if(no_zeros)
            val_ = typical_time;
            val_(typical_time <= 0) = NaN;
        else
            val_ = typical_time;
        end
        plot(data.var_,val_,'k'); hold on;
        plot(data.var_,val_,'k'); hold on;    
        xlabel(str_xlabel);        
        xlim([min(data.var_),max(data.var_)]);
        ylim([0,120]);
        YL = ylim();
        plot(data.var_instability_transition*[1,1],YL,'k--');
        plot(data.var_seed_removal_transition*[1,1],YL,'k-.');           
        h_SR = text(data.var_seed_removal_transition,YL(2)/2,...
                            'No seed removal',...
                            'FontSize',7,'FontName',...
                            'Arial','FontWeight', 'Normal',...
                            'HorizontalAlignment', 'center',...
                            'VerticalAlignment', 'bottom',...
                            'Rotation',90); %'FontSize',14                            
    

        if(data.var_seed_removal_transition > data.var_instability_transition)
            set(h_SR,'VerticalAlignment','top');        
        else
            set(h_SR,'VerticalAlignment','bottom');        
        end
        ylim(YL);
        ylabel({'Time to seed removal','[hours]'});

        ax = axs(i,4);
        axes(ax);
        typical_time                                = abs(1./data.equilibrium_max_eig);
        typical_time(data.equilibrium_max_eig == 0) = 0;
        if(no_zeros)
            val_ = typical_time;
            val_(typical_time == 0) = NaN;
        else
            val_ = typical_time;
        end
        plot(data.var_,val_,'k'); hold on;
        xlabel(str_xlabel);    
        ylabel({'Typical repair time','[hours]'});    
        xlim([min(data.var_),max(data.var_)]);
        ylim([0,150]);%ylim([0,max(val_)]);
        YL = ylim();
        plot(data.var_instability_transition*[1,1],YL,'k--');
        plot(data.var_seed_removal_transition*[1,1],YL,'k-.');    
        %if(i==0)
            h_IS = text(data.var_instability_transition,YL(2)/2,...
                            'Instability',...
                            'FontSize',7,'FontName',...
                            'Arial','FontWeight', 'Normal',...
                            'HorizontalAlignment', 'center',...
                            'VerticalAlignment', 'bottom',...
                            'Rotation',90); %'FontSize',14                        
        if(i==1)
            set(h_IS,'VerticalAlignment','top');
        end
    end

    annotation('textbox', [0.01, 0.95, 0, 0], 'string', 'a, Global stress',...
                'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');

    annotation('textbox', [0.01, 0.53, 0, 0], 'string', 'b, Local stress',...
        'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');

    %****************************************
    % Set axis style and save
    %****************************************
    for ax = axs
        set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal'); 
    end

    fig1.Renderer='Painters';
    print(gcf,'Fig7_Transitions','-dpdf','-r0');

    
    function data = PostProcess(data)
        
        equilibrium_max_eig = data.equilibrium_max_eig;
        time_of_seed_death  = data.time_of_seed_death;
        var_ = data.var_;
        
        %(A) Get transition to instability
        var_instability_transition = 0;
        for i_ = 2:length(var_)
            if( ((equilibrium_max_eig(i_-1)>=0) && (equilibrium_max_eig(i_) < 0)) || ...
                ((equilibrium_max_eig(i_-1)<0) && (equilibrium_max_eig(i_) >=  0))) 
                var_instability_transition = 0.5*(var_(i_-1)+var_(i_));
            end
        end
        data.var_instability_transition = var_instability_transition;

        %(B) Get transition to failure to remove seed
        var_seed_removal_transition = 0;
        for i_ = 2:length(var_)
            if( ((time_of_seed_death(i_-1)<0) && (time_of_seed_death(i_) > 0) && (equilibrium_max_eig(i_) < 0)) || ...
                ((time_of_seed_death(i_-1)>0) && (time_of_seed_death(i_) < 0)  && (equilibrium_max_eig(i_) < 0))) 
                var_seed_removal_transition = 0.5*(var_(i_-1)+var_(i_));
            end            
        end
        
        data.var_seed_removal_transition = var_seed_removal_transition;        
        
        mark = (data.equilibrium_max_eig >= 0);
        data.equilibrium_max_eig(mark) = NaN;
        data.time_of_seed_death(mark)  = NaN;
        
    end
    
end
