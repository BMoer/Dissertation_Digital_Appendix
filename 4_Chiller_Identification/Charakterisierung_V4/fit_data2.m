function [Fit_Coeff,gof]=fit_data2(x, z, Plot_Flag, plot_title)


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, z );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Set up fittype and options.
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Fit model to data.
if Plot_Flag==1
    % Plot fit with data.
    figure( 'Name', 'untitled fit 1' );
    h = plot( fitresult, xData, yData );
    legend( h, 'z vs. x', 'untitled fit 1', 'Location', 'NorthEast' );
    % Label axes
    xlabel( 'x' );
    ylabel( 'z' );
    grid on

end
Fit_Coeff=coeffvalues(fitresult)';