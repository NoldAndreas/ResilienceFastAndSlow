close all;

figure('Units', 'centimeters','Position', [0, 0, 8,8],...
       'PaperUnits', 'centimeters', 'PaperSize', [8,8],...
       'PaperPositionMode','Auto');
w    = 2.5;
left = 1;
top  = 1.5+w+1;
axs(1)     = axes('Units', 'centimeters','Position', [left top w w]);
axs(2)     = axes('Units', 'centimeters','Position', [(left+w+1.5) top w w]);
top = top - w- 1;
axs(3)     = axes('Units', 'centimeters','Position', [left top w w]);
axs(4)     = axes('Units', 'centimeters','Position', [(left+w+1.5) top w w]);


ax_legend = axes('Units', 'centimeters','Position', [left 0.2 (2*w+1.8) 0.5]);

Gs = [0.25,2.5];
for ii = 1:length(Gs)
    
    G = Gs(ii);
    ax = axs(ii);
    axes(ax);
    col = {'b','r'};
    cols = [0.2,0.4,0.6];    
    
    title(['G = ',num2str(G)],'Interpreter','Latex'); hold on;

    p = 0:0.01:1;
    l_damage = plot(p,G*p.^2,'r'); hold on; %'linewidth',2

    p0Crit = 1/(4*G);
    %p0s = [0.5,1,1.5]*p0Crit;%[0.05,0.1,0.15];
    p0s = [0.05,0.5];%[0.05,0.1,0.15];p0Crit
    lin = {'-',':'};
    
    l_homeostatic = plot(p,p-p0s(1),['b',lin{1}]);     %,'linewidth',2
    plot(p,p-p0s(2),['b',lin{2}]);     %,'linewidth',2

    for i = 1:length(p0s)    
        if(4*G*p0s(i) == 1)
            sol_stable = 1/(2*G) - 1/(2*G)*sqrt(1-4*G*p0s(i));
            plot(sol_stable,G*sol_stable^2,'ks','MarkerFaceColor','k','MarkerSize',3);        %
        elseif(4*G*p0s(i) < 1)
            sol_stable = 1/(2*G) - 1/(2*G)*sqrt(1-4*G*p0s(i));
            sol_unstable = 1/(2*G) + 1/(2*G)*sqrt(1-4*G*p0s(i));

            plot(sol_stable,G*sol_stable^2,'ko','MarkerFaceColor','k','MarkerSize',3); %,'MarkerSize',10
            plot(sol_unstable,G*sol_unstable^2,'ko','MarkerSize',3); %,'MarkerSize',12
        end
    end
    ylim([0 0.2]);
    xlim([0 0.7]);

    %set(gca, 'XTick',[0,0.2,0.4]);
    %set(gca, 'YTick',[0,0.2,0.4]);
    set(gca, 'XTick',[0,0.5]);    
    xlabel('Acute damage x'); %'Interpreter','Latex'
    
    ylabel('Tissue activity'); %'Interpreter','Latex'$(x- z,{Gx^2})$
    set(gca, 'YTick',[0,0.1,0.2]);
    
    %set(gca,'TickLabelInterpreter','Latex');
    pbaspect([1 1 1]);
    %ylabel('Glial activity (p- p_0,\textcolor{red}{$Gp^2$})','Interpreter','Latex');
    %set(gca,'fontsize',20);
    box;

    %if(ii==3)
    %    legend({'Damage-inducing','Damage-repairing'},'Location','Northwest');
    %    legend('boxoff');
    %end
    if(ii == 1)
        annotation('textbox', [0.01, 0.99, 0, 0], 'string', 'a',...
            'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
        
        annotation('textbox', [0.01, 0.55, 0, 0], 'string', 'c',...
            'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    elseif(ii==2)
        annotation('textbox', [0.5, 0.99, 0, 0], 'string', 'b',...
            'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
        
        annotation('textbox', [0.5, 0.55, 0, 0], 'string', 'd',...
            'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    end
        
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
    
    
    text(0.07,0.1,'z=0.05',...
                    'FontSize',7,'FontName',...
                    'Arial','FontWeight', 'Normal',...
                    'HorizontalAlignment', 'center',...
                    'VerticalAlignment', 'top',...
                    'Rotation',72); %'FontSize',14     

    text(0.55,0.14,'z=0.5',...
                    'FontSize',7,'FontName',...
                    'Arial','FontWeight', 'Normal',...
                    'HorizontalAlignment', 'center',...
                    'VerticalAlignment', 'top',...
                    'Rotation',72); %'FontSize',14     

    
    %*******************************************************
    % steady states
    %*******************************************************
    ax = axs(ii+2);
    axes(ax);
    p_  = 0:0.01:1;    
    p_1 = 0:0.01:(1/(2*G));
    p_2 = (1/(2*G)):0.01:1;
    p0_ = p_ - G*p_.^2;
    p0_1 = p_1 - G*p_1.^2;
    p0_2 = p_2 - G*p_2.^2;
    l_equilibrium = plot(p0_1,p_1,'k'); hold on;
    plot(p0_2,p_2,['k--']); hold on;
    ylim([0,0.7]);
    xlim([0,0.7]);
    
    plot([0.5 0.5],[0 1],'k:');    
    
    for i = 1:length(p0s)    
        if(4*G*p0s(i) == 1)
            sol_stable = 1/(2*G) - 1/(2*G)*sqrt(1-4*G*p0s(i));
            plot(p0s(i),sol_stable,'ks','MarkerSize',3,'MarkerFaceColor','k');        
                        
        elseif(4*G*p0s(i) < 1)
            sol_stable = 1/(2*G) - 1/(2*G)*sqrt(1-4*G*p0s(i));
            sol_unstable = 1/(2*G) + 1/(2*G)*sqrt(1-4*G*p0s(i));

            plot(p0s(i),sol_stable,'ko','MarkerSize',3,'MarkerFaceColor','k');
            plot(p0s(i),sol_unstable,'ko','MarkerSize',3);
            
            if(p0s(i) >= 0.5)
                plot(p0s(i),sol_stable,'ro','MarkerSize',10); %,'MarkerFaceColor','k'
            end
            
        end
    end
    
    if(ii==2)
        text(0.5,0.3,'Seed removal',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'top',...
                        'Rotation',90); %'FontSize',14     
        quiver(0.5,0.1,0,0.55,'k','MaxHeadSize',0.5);            
        %annotation('textarrow',[0.5,0.5],[0.1,0.3],'String',' Growth ','Linewidth',2)
                    
    else
        text(0.5,0.28,'Failure seed rem.',...
                        'FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'top',...
                        'Rotation',90); %'FontSize',14     
    end

    
    xlabel('Baseline damage z');
    ylabel('Acute damage x');
    set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');   
end


axes(ax_legend);
leg = legend(ax_legend, [l_homeostatic,l_damage,l_equilibrium],...
            {'Repair r','Dispose d','Equilibrium'},'NumColumns',3,'Box','off');
leg.Location = 'north'
axis off;
set(ax_legend,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  

% for ii = 1:3
%     ax = subplot(1,3,ii);
%     set(ax,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');  
% end


print(gcf,'Fig3_Balance','-dpdf','-r0');
%SaveFigure_pdfFig(['Fig2_b_Balance_Stability']);