close all;

figure('Units', 'centimeters','Position', [0, 0, 18,3.5],...
       'PaperUnits', 'centimeters', 'PaperSize', [18,3.5],...
       'PaperPositionMode','Auto');
   
left_alignment = 1;
top_alignment = 1;
axs = [];
axs_colorbar = [];
axs_ana = [];
w = 2;
w_spacing = 2.2;
w_spacing_vertical = 2.5;
for i1 = 1:1   
    top  = top_alignment - w_spacing_vertical*(i1-1);

    left = 1;
    axs_colorbar(i1) = axes('Units', 'centimeters','Position', [left top w*0.2 w]);    
    
    for i2 = 1:5
        left = left_alignment + w_spacing*(i2-1) + 1.;    
        axs(i1,i2) = axes('Units', 'centimeters','Position', [left top w w]);
    end        
    
    left = left_alignment + w_spacing*5+2.2;
    axs_ana(i1)  = axes('Units', 'centimeters','Position', [left top w*1.5 w]);
end


%************************************
% Compute 
%************************************
Fig1_Spread(axs(1,:),axs_colorbar(1),axs_ana(1));
%************************************

for ax = axs
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal'); 
end
for ax = axs_colorbar
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

for ax = axs_ana
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
end

print(gcf,'Fig1_SlowSpread','-dpdf','-r0');
