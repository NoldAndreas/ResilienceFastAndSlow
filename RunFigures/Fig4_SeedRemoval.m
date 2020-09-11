close all;

figure('Units', 'centimeters','Position', [0, 0, 18,8.5],...
       'PaperUnits', 'centimeters', 'PaperSize', [18,8.5],...
       'PaperPositionMode','Auto');

left_alignment = 0.5;
top_alignment = 6;
axs = [];
axs_colorbar = [];
axs_ans = [];
w = 2;
w_spacing = 2.2;
w_spacing_vertical = 2.5;
for i1 = 1:3   
    top  = top_alignment - w_spacing_vertical*(i1-1);

    left = left_alignment;
    axs_colorbar(i1) = axes('Units', 'centimeters','Position', [left top w*0.2 w]);    
    
    for i2 = 1:5
        left = left_alignment + w_spacing*(i2-1) + 1.;    
        axs(i1,i2) = axes('Units', 'centimeters','Position', [left top w w]);
    end        
    
    left = left_alignment + w_spacing*5+2.7;%2.2;
    axs_ana(i1)  = axes('Units', 'centimeters','Position', [left top w*1.5 w]);
end


%************************************
% Compute 
%************************************
params = struct('z0_mean',0.05,'z0_std',0.02,...
                'c',0.4,'D',-1,'G',3,...
                't_plot',[-10,0,10,20,35],'n',16);

Fig_shortTermDynamics(axs,axs_colorbar(1:end),axs_ana(1:end),params);


%************************************
n = params.n;
axes(axs(1,1));
%text((n+1)/2,(n+1)/2,'\leftarrow seed site','FontSize',7,'FontName','Arial',...
%                'FontWeight', 'Normal') %'FontSize',14                       
      %      ylabel('Baseline damage z');            
axes(axs(1,2));      
text((n+1)/2,(n+1)/2-2,'Seed induction','FontSize',7,'FontName','Arial',...
                'FontWeight', 'Normal','HorizontalAlignment', 'center') %'FontSize',14                        

axes(axs(1,5));
text((n+1)/2,(n+1)/2-2,'Seed removal','FontSize',7,'FontName','Arial',...
                'FontWeight', 'Normal','HorizontalAlignment', 'center') %'FontSize',14                                


for ax = axs
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal'); 
end
for ax = axs_colorbar
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

for ax = axs_ana
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

print(gcf,'Fig4_SeedRemoval','-dpdf','-r0');
%print2eps('test',gcf);
%SaveFigure_pdfFig('test')