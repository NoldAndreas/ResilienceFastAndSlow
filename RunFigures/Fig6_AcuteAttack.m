close all;

fig1 = figure('Units', 'centimeters','Position', [0, 0, 18,8.5],...
       'PaperUnits', 'centimeters', 'PaperSize', [18,8.5],...
       'PaperPositionMode','Auto');
   
   
left_alignment = 1;
top_alignment = 6;
axs = [];
axs_colorbar = [];
axs_ans = [];
w = 2;
w_spacing = 2.2;
w_spacing_vertical = 2.5;
for i1 = 1:3   
    top  = top_alignment - w_spacing_vertical*(i1-1);

    left = 1;
    axs_colorbar(i1) = axes('Units', 'centimeters','Position', [left top w*0.2 w]);
    %left = left_alignment + 2.2;
    
    for i2 = 1:5
        left = left_alignment + w_spacing*(i2-1) + 1.;    
        axs(i1,i2) = axes('Units', 'centimeters','Position', [left top w w]);
    end
    
    %axs_colorbar(i1) = axes('Units', 'centimeters','Position', [left top w*0.2 w]);
    
    left = left_alignment + w_spacing*5+2.2;
    axs_ana(i1)  = axes('Units', 'centimeters','Position', [left top w*1.5 w]);
end   
% 
% left_alignment = 1;
% top_alignment = 6.5;
% axs = [];
% axs_colorbar = [];
% axs_ans = [];
% w = 2;
% w_spacing = 2.2;
% w_spacing_vertical = 2.5;
% for i1 = 1:3
%     top  = top_alignment - w_spacing_vertical*(i1-1);
%     %if(i1>1)
%     %    top = top - 1;
%     %end
%     for i2 = 1:5
%         left = left_alignment + w_spacing*(i2-1);    
%         axs(i1,i2) = axes('Units', 'centimeters','Position', [left top w w]);
%     end
%     left = left_alignment + w_spacing*4.8;    
%     axs_colorbar(i1) = axes('Units', 'centimeters','Position', [left top w*0.2 w]);
%     
%     left = left_alignment + w_spacing*5+2;
%     axs_ana(i1)  = axes('Units', 'centimeters','Position', [left top w*1.5 w]);
% end


%************************************
% Compute 
%************************************
%Fig1_a(axs(1,:),axs_colorbar(1),axs_ana(1));
% 
params = struct('z0_mean',0.075,'z0_std',0.035,...
                 'c',0.55,'D',0,'G',3,...
                 't_plot',[-20,60,70,80,85],...
                 'n',30,'seed',1);
            
%params = struct('z0_mean',0.1,'z0_std',0.02,...
%                'c',0.4,'D',0,'G',2.5,...
%                't_plot',[-20,0,20,40,50],...
%                'n',30);            
            
            %t_plot = [-10,50,100,110,120];

Fig_shortTermDynamics(axs,axs_colorbar,axs_ana,params);


%************************************
%
%************************************
%annotation('textbox', [0.01, 0.99, 0, 0], 'string', 'a',...
%    'FontSize',10,'FontName','Arial','FontWeight', 'bold');

%annotation('textbox', [0.01, 0.74, 0, 0], 'string', 'b',...
%    'FontSize',10,'FontName','Arial','FontWeight', 'bold');


for ax = axs
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal'); 
end
for ax = axs_colorbar
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

for ax = axs_ana
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

fig1.Renderer='Painters';
print(gcf,'Fig6_AcuteAttack','-dpdf','-r0');
%print2eps('test_acuteAttack',gcf);
%SaveFigure_pdfFig('test_acuteAttack')