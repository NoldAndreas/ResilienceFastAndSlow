
close all;

figure('Units', 'centimeters','Position', [0, 0, 18,9.5],...
       'PaperUnits', 'centimeters', 'PaperSize', [18,9.5],...
       'PaperPositionMode','Auto');

left_alignment = 1;
top_alignment = 6.5;
axs = [];
axs_colorbar = [];
axs_ans = [];
w = 2;
w_spacing = 2.2;
w_spacing_vertical = 2.8;
for i1 = 1:3   
    top  = top_alignment - w_spacing_vertical*(i1-1);

    left = 1;
    axs_colorbar(i1) = axes('Units', 'centimeters','Position', [left top w*0.2 w]);    
    
    for i2 = 1:5
        left = left_alignment + w_spacing*(i2-1) + 1.;    
        axs(i1,i2) = axes('Units', 'centimeters','Position', [left top w w]);
    end        
    
    left = left_alignment + w_spacing*5+2.7;
    axs_ana(i1)  = axes('Units', 'centimeters','Position', [left top w*1.5 w]);
end


%************************************
% Compute 
%************************************
D = -1;
params = struct('z0_mean',0.05,'z0_std',0.02,...
                'c',0.2,'D',D,'G',3,...
                't_plot',[0,10,20,30,40],'n',16);
Fig_shortTermDynamics_x(axs(1,:),axs_colorbar(1),axs_ana(1),params,['c=',num2str(params.c)]);

params = struct('z0_mean',0.05,'z0_std',0.02,...
                'c',0.42,'D',D,'G',3,...
                't_plot',[0,10,20,30,40],'n',16,...
                'text_seed_removal',false);
snapshot_data = Fig_shortTermDynamics_x(axs(2,:),axs_colorbar(2),axs_ana(2),params,['c=',num2str(params.c)]);
text(snapshot_data.t_of_death(snapshot_data.idx_seed),1/2,sprintf('Delayed\n seed removal'),'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'middle',...
                        'Rotation',90); %'FontSize',14        

params = struct('z0_mean',0.05,'z0_std',0.02,...
                'c',0.5,'D',D,'G',3,...
                't_plot',[0,10,20,30,40],'n',16);
snapshot_data = Fig_shortTermDynamics_x(axs(3,:),axs_colorbar(3),axs_ana(3),params,['c=',num2str(params.c)]);

axes(axs_ana(3));
h_ = text(25,0.69,'No seed removal','FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom'); %'FontSize',14        

for i = 1:5
    axes(axs(1,i));
    t_ = params.t_plot(i);
    if(t_ < 0)      
        title(['Initial'],'FontWeight','Normal');        
    else
        title([num2str(t_),' hours'],'FontWeight','Normal');        
    end
    
end

axes(axs_ana(3));
xlabel('Time (hours)');

for ax = axs
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal'); 
end
for ax = axs_colorbar
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

for ax = axs_ana
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

annotation('textbox', [0.0, 0.98, 0, 0], 'string', 'a, Healthy state',...
            'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');

annotation('textbox', [0.0, 0.67, 0, 0], 'string', 'b, Challenged state',...
    'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');

annotation('textbox', [0.0, 0.37, 0, 0], 'string', 'c, Chronic state',...
    'FontSize',7,'FontName','Arial','FontWeight', 'bold','FitBoxToText','on','LineStyle','none');


print(gcf,'Fig5_Transition','-dpdf','-r0');
