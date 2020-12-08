function RasterYL( Result_cell, save_figure )
%   -1 for no figure, 0 for displaying figure, 1 for saving figure without
%   displaying
%
%   If the firing history is too long, data will be segmented into several
%   history fractions and plotted separately.
disp('RasterYL...');
tic;


if nargin == 0
    Result_cell = CollectRYG();
end
if nargin <= 1
    save_figure = 1; % default
end
if save_figure == 1
    figure_visibility = 'off'; % 'on', 'off'
else
    figure_visibility = 'on';
end

Result_num = length(Result_cell);

for r_num = 1:Result_num
    R = Result_cell{r_num};
    step_tot = R.reduced.step_tot;
    comments = R.comments;
    Num_pop = 1;
    
    seg_size = 4*10^4; % 2*10^4 for 2-pop, segmentation size for each plot
    seg_num = ceil(step_tot/seg_size);
    for seg = 1:seg_num
        
        %-------------------------------------------------------------------------%
        % Plot
        h_raster = figure('NumberTitle','Off','Name',strcat('Raster plot:', R.stamp),'units','normalized','position',[0 0 1 1], ...
            'visible', figure_visibility, 'Color','w', 'PaperPositionMode', 'default');
        axes_matrix = zeros(3,Num_pop);
        for pop_ind = 1:Num_pop
            % Plot raster plot
            axes_matrix(1,pop_ind) = subplot(6,Num_pop,(0:3)*Num_pop+pop_ind);hold on;
            raster_plot(R, pop_ind, seg, [] );
            % Plot number of spikes
            axes_matrix(2,pop_ind) = subplot(6,Num_pop,4*Num_pop+pop_ind);hold on;
            num_spikes_plot_YL(R, pop_ind, seg, seg_size);
        end
        
        % Link axes to synchronise them when zooming
        for pop_ind = 1:Num_pop
            linkaxes(axes_matrix(1:2,pop_ind),'x');
        end     
        
        % Write comments
        subplot(6,Num_pop,5*Num_pop+(1:Num_pop), 'visible','off')
        text(0.5, 0.5, comments, ...
            'VerticalAlignment', 'top', ...
            'HorizontalAlignment', 'center',...
            'FontSize',10,'FontWeight','normal', 'interpreter', 'none'); % ...'interpreter', 'none'... to show underscore
        
        % save figure
        if save_figure == 1
            fprintf('\t Saving figure...');
            print(h_raster, '-bestfit','-dpdf', strcat( R.stamp, '_raster_',sprintf('%02g', seg)));
            close gcf; clear gcf;
            fprintf('done.\n');
        else
            next = input('\t Next figure?');
            delete(h_raster);
        end
        
    end
end
toc;
end