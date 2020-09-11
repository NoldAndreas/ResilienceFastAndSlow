function Fig8_Adaptation
    close all;
    
    
    if(isfile('Fig8_adaptation.mat'))
        load('Fig8_adaptation.mat','data_global','data_local');
    else
        n_ = 20;
        %****************************************
        % Elevated global z, adapt G
        %****************************************
        disp('Part 1/2 ..');
        params = struct('z0_mean',0.1,'z0_std',0.02,...
                        'c',0.2,'D',0,'G',1.5,...
                        't_plot',[-100,0,50,100],'n',20,...
                        'case_global',true);

        var_G          = linspace(.7,1.7,n_);
        var_z          = linspace(0.1,0.3,n_);
        variable_var_  = 'G';

        data_global   = Fig_adaptation_general_2D(params,var_G,variable_var_,var_z);
        %snapshot_global = Data_shortTermDynamics(params);

        %****************************************
        % Elevated local z, adapt c
        %****************************************
        disp('Part 2/2 ..');
        params = struct('z0_mean',0.075,'z0_std',0.02,...
                        'c',0.5,'D',0,'G',2,...
                        't_plot',[-100,0,50,100],'n',20,...
                        'case_global',false,...
                        'z0_mean_base_ratio',0.5);                

        var_c          = linspace(0.3,0.6,n_);
        var_z          = linspace(0.1,0.18,n_);                    

        
        variable_var_  = 'c';

        data_local   = Fig_adaptation_general_2D(params,var_c,variable_var_,var_z);                                
       % snapshot_local = Data_shortTermDynamics(params);
        save('Fig8_adaptation.mat','data_global','data_local');     
    end

    %*************************************************
    % Analysis
    %*************************************************
    data_global = PostProcess(data_global,"Gs");
    data_local  = PostProcess(data_local,"cs");
    datas = [data_global,data_local];
       
    
    fig1 = figure('Units', 'centimeters','Position', [0, 0,18.5,10],...
       'PaperUnits', 'centimeters', 'PaperSize', [18.5,10],...
       'PaperPositionMode','Auto');
   
    caxis_1 = [0,40];    
    caxis_2 = [0,20];
    caxis_3 = [0,10];
    top = 6;
    axs = [];
    w = 3;
    w_vertical = 3;
    w_spacing =3;            
    
    for i_row = 1:2
        left = 1;
        axs(i_row,1) = axes('Units', 'centimeters','Position', [left top w w_vertical]);    
        left = left + w_spacing;
        axs(i_row,2) = axes('Units', 'centimeters','Position', [left top w*0.2 w_vertical]);                
        left = left + w_spacing;
        axs(i_row,3) = axes('Units', 'centimeters','Position', [left top w w_vertical]);
        left = left + w_spacing ;
        axs(i_row,4) = axes('Units', 'centimeters','Position', [left top w*0.2 w_vertical]);        
        left = left + w_spacing ;
        axs(i_row,5) = axes('Units', 'centimeters','Position', [left top w w_vertical]);        
        left = left + w_spacing;
        axs(i_row,6) = axes('Units', 'centimeters','Position', [left top w*0.2 w_vertical]);                
                
        top = top - w_spacing-2;
    end
    
    %******************************************************
    % Global stress 
    %******************************************************    
    for row = 1:2
        data = datas(row);
        axes(axs(row,1));   
        h = pcolor(data.z0s,data.var_2D,data.time_of_seed_death); hold on;
        set(h, 'EdgeColor', 'none');
        %plot(data.z0s,data.var_instability_transition,'k');
        %plot(data.z0s,data.var_seed_removal_transition,'k');
        BM     = brewermap(9,'Reds');
        %BM = [BM;0,0,0];
        cmap_1 = colormap(axs(row,1),BM);        
        xlabel('Baseline damage z');
        ylabel(data.var_name);
        if(row==2)
            xticks([0.1,0.14,0.18]);
        end
        
        plot(data.var_seed_removal_transition_zs,(data.var_seed_removal_transition),'k','linewidth',2);
        plot(data.var_instability_transition_zs,(data.var_instability_transition),'k','linewidth',2);
       % xlim([0.1,0.3]);    
        caxis(caxis_1);
        AddTransitionLabels(row);
                
        colormap(axs(row,2),cmap_1);    
        h = colorbar(axs(row,2)); %,'XTick',[0,0.5,1]
        caxis(axs(row,2),caxis_1);
        h.Box = 'off';
        h.Label.String = 'Seed removal time (hours)';    
        set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
        set(h, 'YAxisLocation','right');
        set(axs(row,2),'Visible','off');

        axes(axs(row,3));   
        h = pcolor(data.z0s,data.var_2D,data.repair_time); hold on;
        set(h, 'EdgeColor', 'none');
        %plot(data.z0s,data.var_instability_transition,'k');
        %plot(data.z0s,data.var_seed_removal_transition,'k');
        cmap_1 = colormap(axs(row,3),brewermap(9,'Blues'));
        xlabel('Baseline damage z');
        ylabel(data.var_name);
        if(row==2)
            xticks([0.1,0.14,0.18]);
        end
        
        plot(data.var_seed_removal_transition_zs,(data.var_seed_removal_transition),'k','linewidth',2);
        plot(data.var_instability_transition_zs,(data.var_instability_transition),'k','linewidth',2);
        caxis(caxis_2);
        AddTransitionLabels(row);

        colormap(axs(row,4),cmap_1);    
        h = colorbar(axs(row,4)); %,'XTick',[0,0.5,1]
        caxis(axs(row,4),caxis_2);
        h.Box = 'off';
        h.Label.String = 'Typical repair time (hours)';    
        set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
        set(h, 'YAxisLocation','right');
        set(axs(row,4),'Visible','off');
        
        
        
        %*********************************************
        % 
        %*********************************************
        axes(axs(row,5));        
        h = pcolor(data.z0s,data.var_2D,data.number_of_dead); hold on;
        %h = pcolor(data.z0s,data.var_2D,NaN*data.repair_time); hold on;
        plot(data.var_seed_removal_transition_zs,(data.var_seed_removal_transition),'k','linewidth',2); hold on;
        plot(data.var_instability_transition_zs,(data.var_instability_transition),'k','linewidth',2);
       % AddTransitionLabels(row);
        cmap_3 = colormap(axs(row,5),brewermap(caxis_3(2),'Purples'));
        set(h, 'EdgeColor', 'none');
        xlabel('Baseline damage z');
        ylabel(data.var_name);
        caxis(caxis_3);
        
        
        colormap(axs(row,6),cmap_3);    
        h = colorbar(axs(row,6)); %,'XTick',[0,0.5,1]
        caxis(axs(row,6),caxis_3);
        h.Box = 'off';
        h.Label.String = {'Number of dead cells','after seed removal'};    
        set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
        set(h, 'YAxisLocation','right');
        set(axs(row,6),'Visible','off');
        set(h,'XTick',[0,2,4,6,8,10]);
        set(h,'XTickLabel',{'0','2','4','6','8','>10'});
        if(row == 1)
            arrow([0.12,1.4],[0.25,0.73],'linewidth',3,'color',[1 1 1]*0.5,'tipangle',35,'Length',5);
            plot(0.2158,0.9053,'or','MarkerFaceColor','r','MarkerSize',10);
            text(0.16,0.76,'Disease onset',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom',...
                        'color','r'); %'FontSize',14   
        else
            arrow([0.12,0.35],[0.16,0.58],'linewidth',3,'color',[1 1 1]*0.5,'tipangle',35,'Length',5);            
            plot(0.1522,0.5355,'or','MarkerFaceColor','r','MarkerSize',10);
            text(0.125,0.55,'Disease onset',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom','color','r');
        end
        
        %title('Possible disease course');
                
    


    end
    
    annotation('textbox', [0.02, 0.97, 0, 0], 'string', 'a, Global stress, adaptation of responsiveness G',...
            'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');

    annotation('textbox', [0.02, 0.48, 0, 0], 'string', 'b, Local stress, adaptation of focal range c',...
        'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');


    for ax = axs
        set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal'); 
    end

    fig1.Renderer='Painters';
    print(gcf,'Fig8_Adaptation','-dpdf','-r0');

   
    %*************************************************
    % Ploting
    %*************************************************
%     data = data_global;
%     figure; 
%     subplot(1,3,1);
%     surf(data.z0s,data.Gs,data.time_of_seed_death);
%     xlabel('z0');
%     ylabel('G');
% 
%     subplot(1,3,2);
%     surf(data.z0s,data.Gs,data.integrated_load);
%     xlabel('z0');
%     ylabel('G');
% 
%     subplot(1,3,3);
%     surf(data.z0s,data.Gs,real(data.equilibrium_max_eig));
%     xlabel('z0');
%     ylabel('G');
% 
% 
%     data = data_local;
%     figure; 
%     subplot(1,3,1);
%     surf(data.z0s,data.cs,data.time_of_seed_death);
%     xlabel('z0');
%     ylabel('c');
% 
%     subplot(1,3,2);
%     surf(data.z0s,data.cs,data.integrated_load);
%     xlabel('z0');
%     ylabel('c');
% 
%     subplot(1,3,3);
%     surf(data.z0s,data.cs,1./abs(real(data.equilibrium_max_eig)));
%     zlim([0,10]);
%     caxis([0,10])
%     xlabel('z0');
%     ylabel('c');
    
    
    function data = PostProcess(data,var_name)
        
        
        %******************************************************
        % more variables
        %******************************************************
        data.repair_time    = -1./real(data.equilibrium_max_eig);
        
        %******************************************************
        % detect transitions
        %******************************************************
        
        z0s   = data.var_z;
        var_  = data.var_;

        var_instability_transition  = zeros(size(z0s));
        var_seed_removal_transition = zeros(size(z0s));

        for ii = 1:length(z0s)

            equilibrium_max_eig = data.equilibrium_max_eig(ii,:);
            time_of_seed_death  = data.time_of_seed_death(ii,:);
            

            for i = 2:length(var_)

                %(A) Get transition to instability for each z
                if( ((equilibrium_max_eig(i-1)==0) && (equilibrium_max_eig(i) < 0)) || ...
                    ((equilibrium_max_eig(i-1)<0) && (equilibrium_max_eig(i) ==  0))) 
                    var_instability_transition(ii) = 0.5*(var_(i-1)+var_(i));
                end

                %(B) Get transition to failure to remove seed
                if( ((time_of_seed_death(i-1)<0) && (time_of_seed_death(i) > 0) && (equilibrium_max_eig(i) < 0)) || ...
                    ((time_of_seed_death(i-1)>0) && (time_of_seed_death(i) < 0)  && (equilibrium_max_eig(i) < 0))) 
                    var_seed_removal_transition(ii) = 0.5*(var_(i-1)+var_(i));
                end

            end
        end
        
        mark = (var_instability_transition <= max(var_)).*(var_instability_transition>=min(var_));
        data.var_instability_transition     = smooth(var_instability_transition(mark==1)); 
        data.var_instability_transition_zs  = data.var_z(mark==1); 
        
        
        mark = (var_seed_removal_transition <= max(var_)).*(var_seed_removal_transition>=min(var_));
        data.var_seed_removal_transition     = smooth(var_seed_removal_transition(mark==1));
        data.var_seed_removal_transition_zs  = data.var_z(mark==1); 
        
        
        %******************************************************
        % identify area which where seeds are not removed or which is
        % unstable       
        %******************************************************        
        data.mark_not_valid = (data.equilibrium_max_eig == 0);% | (data.time_of_seed_death < 0);
        
        
%         if(option_display==1)
%             val_ = data.time_of_seed_death;
%         elseif(option_display==2)
%             val_ = data.repair_time;
%         elseif(option_display==3)
%             val_ = data.number_of_dead;
%         end
%         val_(data.mark_not_valid) = NaN;
%         data.val_ = val_;
        
        data.var_2D = data.(var_name);
        data.var_2D(data.mark_not_valid) = NaN;
        
        if(var_name == "Gs")
            data.var_name = "Responsiveness G";
        else
            data.var_name = "Focal range c";
        end
            %'Responsiveness G'
        
        %******************************************************
        % Set time to seed removal to inf if not removed
        %******************************************************        
        
        mark = (~data.mark_not_valid &  (data.time_of_seed_death < 0));
        data.time_of_seed_death(mark) = NaN;
        
    end
    

    function AddTransitionLabels(row)
        
        if(row==1)
            text(0.22,1.2,'Instability',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom',...
                        'Rotation',-50); %'FontSize',14  
                    
            text(0.19,0.75,'Failure seed removal',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom',...
                        'Rotation',-8); %'FontSize',14 
                                        
        else
            text(0.16,0.4,'Instability',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom',...
                        'Rotation',70); %'FontSize',14  
                    
            text(0.13,0.48,'Failure seed removal',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom',...
                        'Rotation',40); %'FontSize',14   
        end
    end
end
