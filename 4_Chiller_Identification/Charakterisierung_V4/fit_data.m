function [Fit_Coeff,fitgof] =fit_data(d1, d2, target, Plot_Flag, plot_title)
%  Create a fit.

[xData, yData, zData] = prepareSurfaceData(d1, d2, target);

% Set up fittype and options.
ft = fittype( 'poly22' );

% Fit model to data.
[fitresult,fitgof] = fit( [xData, yData], zData, ft );
if Plot_Flag==1
    % Plot fit with data.
    figure();
    h = plot( fitresult, [xData, yData], zData );

    % Label axes
    xlabel( 'T_eva' );
    ylabel( 'T_con' );
    title(plot_title);
    grid on
    view( -46.5, 30.0 );
end
Fit_Coeff=coeffvalues(fitresult)';
end