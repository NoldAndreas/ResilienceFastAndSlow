function Fig1_Spread(axs,axs_colorbar,axs_graphs)

    %**************************************************
    %Parameters    
    %**************************************************    
    z0_mean   = 0.05; 
    z0_std    = 0.02;
    tau_inf   = 10; 
       
    n = 20; 
    M = 10;
    Tstart = -3;
    Tmax = 9;     
    dt   = 0.01; 
    seed = 1;
        
    plot_times =[-5,0,3,6,9];
    
    %**************************************************
    %Initialization;    
    %**************************************************    
    rng(seed);
    N  = n^2;
    ts = Tstart:dt:Tmax;
    A = InitializeConnectivityMatrices_A(n,M);
    x_1D  = 1:n;
    [x1,x2] = meshgrid(x_1D,x_1D); 
    z = LogNormal(z0_mean,z0_std,N);
    [~,idx_seed] = min((x1(:)-n/2).^2+(x2(:)-n/2).^2);    
    mark_alive = true(N,1);
    z_snapshot = [];
    t_snapshot = []; 
    n_dead = [];
    n_seeds = [];
    markalive_snapshot = []; 
    
    [~,i__seed] = min(abs(ts-0));
    
    %**************************************************
    %Simulation
    %**************************************************   
    for i__ = 1:length(ts)
        if(i__ == i__seed)
            z(idx_seed) = z(idx_seed) + 0.5;
        end
        dz             = f(z);         
        z(mark_alive)  = z(mark_alive) + dz(mark_alive);        
        mark_dead_new             = ((z >= 1) & mark_alive);                
        mark_alive(mark_dead_new) = false;        
        
        if(mod(i__,10)==1)
            t_snapshot(end+1) = ts(i__);
            z_snapshot(:,end+1) = z;
            n_dead(end+1) = sum(~mark_alive);
            n_seeds(end+1) = sum(mark_alive & (z >= 0.5));
            markalive_snapshot(:,end+1) = mark_alive;
        end
    end
    
    %**************************************************
    %Plotting
    %**************************************************        
    for i_ = 1:length(plot_times)
        
        axes(axs(i_));
        [~,idx] = min(abs(t_snapshot-plot_times(i_)));       
        %subplot(1,4,i_);
                
        %idx = plot_indices(i_);
        PlotBirdView_revised(reshape(z_snapshot(:,idx),n,n),markalive_snapshot(:,idx));        
        
        if(t_snapshot(idx) < 0)
            title(['Initial'],'FontWeight','Normal');                                
        else
            title([num2str(t_snapshot(idx)),' years'],'FontWeight','Normal');        
        end        
        %title([num2str(t_snapshot(idx)),' years'],'FontWeight','Normal');
        colormap(axs(i_),brewermap(9,'Reds'));
        caxis(axs(i_),[0 0.5]);
    end
    
    colormap(axs_colorbar,brewermap(9,'Reds'));    
    h = colorbar(axs_colorbar,'XTick',[0,0.5,1]);
    h.Label.String = 'Baseline damage z';
    h.Box = 'off';
    set(h,'FontSize',7,'FontName','Arial','FontWeight', 'Normal');
    set(axs_colorbar,'XColor','none');
    set(h, 'YAxisLocation','left');
    caxis(axs_colorbar,[0 1]);
    set(axs_colorbar,'Visible','off');
    
    axes(axs_graphs);
    %yyaxis left
    plot(t_snapshot,n_seeds,'k-');  hold on;
    %plot(t_snapshot,n_dead,'k--'); hold on;
    xlim([Tstart,Tmax]);
     
    xlabel('Time [years]');
    ylabel('# seeds');
    YL = ylim();    
    plot([0,0],YL,'k--','linewidth',1);
    h_ = text(0,YL(2)/2,'Seed induction','FontSize',7,'FontName',...
                        'Arial','FontWeight', 'Normal',...
                        'HorizontalAlignment', 'center',...
                        'VerticalAlignment', 'bottom'); %'FontSize',14
    set(h_,'Rotation',90);
    %legend({'# seeds','# dead'})
    %legend boxoff 
    
    %yyaxis right
    
   % ylabel('# seeds');
    xticks(plot_times);
    
     function dz = f(z)
        seeds                              = zeros(N,1);
        seeds((z >= 0.5) & mark_alive)     = 1;
                
        dz                     = A*seeds*dt/tau_inf;
        
        %spontaneousSeeding     = (rand(N,1) < seeding_rate*dt);        
        %spontaneousSeeding(z >= 0.5) = false; %seeds cannot be re-seeded
        %dz(spontaneousSeeding) = dz(spontaneousSeeding) + 0.5; 
        
     %   dz = min(dz,0.5); %max one seeding-input at a time
     %  no_induced_seeds       = sum(spontaneousSeeding(mark_alive));
                                  
     end 
 
%     function PlotBirdView(val,mark_alive)
%         [X,Y] = meshgrid(1:(n));
%         X_ = X(:);
%         Y_ = Y(:);
%         
%         [n1,n2]  = size(val);
%         val_plus = zeros(n1+1,n2+1);
% 
%         val_plus(1:n1,1:n2)= val;
% 
%         h = pcolor(val_plus);    
%         
%         idx_dead = find(~mark_alive);
%         if(length(idx_dead)>0)
%             for idx_ = idx_dead'
% 
%                 xs_ = X_(idx_) + [0 1 1 0];
%                 ys_ = Y_(idx_) + [0 0 1 1];             
%                 patch(xs_,ys_,'w');
%                 %scatter(X_(~markalive),Y_(~markalive),'x');
%                % text(0.5+X_(idx_),0.5+Y_(idx_),'X','FontSize',5,...
%                 %            'color','k',...
%                  %           'HorizontalAlignment','center', ...
%                   %          'VerticalAlignment','middle');
%             end
%         end
%         
%         set(h, 'EdgeColor', 'none');
%         set(gca,'XTick',[]);
%         set(gca,'yTick',[]);
%         pbaspect([1 1 1]);
% 
%                  
% 
%     end
end