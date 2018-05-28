%%% ***********************************************************************
%%% * Selfish vs Oblivious MABs to Enhance Spatial Reuse in Dense WLANs   *
%%% * Submission to                                                       *
%%% * Authors:                                                            *
%%% *   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *
%%% *   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *
%%% *   - Boris Bellalta (boris.bellalta@upf.edu)                         *
%%% *   - Cristina Cano (ccanobs@uoc.edu)                                 *
%%% * 	- Anders Jonsson (anders.jonsson@upf.edu)                         *
%%% *   - Gergely Neu (gergely.neu@upf.edu)                               *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *
%%% * Repository:                                                         *
%%% *  bitbucket.org/wireless_networks/selfish_vs_oblivious_spatial_reuse *
%%% ***********************************************************************

function [] = save_figure( fig, fig_name, path_figure )
% save_figure saves a figure to the indicated path under the indicated name
%   INPUT: 
%       * fig - figure to be saved
%       * fig_name - desired name for the figure
%       * path_figure - desired path to save the figure

    savefig([path_figure fig_name '.fig'])
    saveas(gcf, [path_figure fig_name], 'epsc')
    saveas(gcf, [path_figure fig_name], 'png')
    
end

