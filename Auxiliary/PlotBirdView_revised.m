function PlotBirdView_revised(val,mark_alive,nview)
        
        [n1,n2]  = size(val);
        val_plus = zeros(n1+1,n2+1);

        if(n1 ~= n2)
            disp('WARNING: n1 not equal n2');
        else
            n = n1;
        end

        [X,Y] = meshgrid(1:n);
        X_ = X(:);
        Y_ = Y(:);
        
        
        val_plus(1:n1,1:n2)= val;

        h = pcolor(val_plus);    
        
        idx_dead = find(~mark_alive);
        if(length(idx_dead)>0)
            for idx_ = idx_dead'

                xs_ = X_(idx_) + [0 1 1 0];
                ys_ = Y_(idx_) + [0 0 1 1];             
                patch(xs_,ys_,'w');
                %scatter(X_(~markalive),Y_(~markalive),'x');
               % text(0.5+X_(idx_),0.5+Y_(idx_),'X','FontSize',5,...
                %            'color','k',...
                 %           'HorizontalAlignment','center', ...
                  %          'VerticalAlignment','middle');
            end
        end

         if(nargin >= 3)
             xlim([(n2+1)/2-nview,(n2+1)/2+nview]);
             ylim([(n2+1)/2-nview,(n2+1)/2+nview]);
         end
        
        set(h, 'EdgeColor', 'none');
        set(gca,'XTick',[]);
        set(gca,'yTick',[]);
        pbaspect([1 1 1]);


                 

    end