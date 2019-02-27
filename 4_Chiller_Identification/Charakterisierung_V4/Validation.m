%function [RMSE_P_abs,RMSE_P_rel,RMSE_Q_abs,RMSE_Q_rel]=Validation(Validation_Dataset, CAPFT_Coeff, EIRFT_Coeff, EIRFPLR_Coeff, Q_Spec, COP_Spec)
function [RMSE_abs,RMSE_rel,Validation_Dataset]=...
    Validation(Validation_Dataset, CAPFT_Coeff, EIRFT_Coeff, EIRFPLR_Coeff, Q_Spec, COP_Spec, eta_0,...
    m_Tcnds,m_Tchws,m_Q_e,m_Q_con,m_Pe,m_CAPFT,m_EIRFT,m_PLR,m_EIRFPLR,m_Qevaestimate,m_Pestimate,m_Qconestimate)
x = zeros(length(Validation_Dataset),1);
y = zeros(length(Validation_Dataset),1);

if(m_Tchws ~= 0) x=Validation_Dataset(:,m_Tchws); end
if(m_Tcnds ~= 0) y=Validation_Dataset(:,m_Tcnds); end
%Calculation of the available chiller power (CapFTemp) and respective Power
%demand(EIRFTempt) according to the provided coefficients.
for i=1:length(Validation_Dataset)
     Validation_Dataset(i,m_CAPFT)=CAPFT_Coeff(1)+CAPFT_Coeff(2)*x(i)+...
                          CAPFT_Coeff(3)*y(i)+CAPFT_Coeff(4)*x(i).^2+...
                          CAPFT_Coeff(5)*x(i)*y(i)+CAPFT_Coeff(6)*y(i).^2;
     Validation_Dataset(i,m_EIRFT)=EIRFT_Coeff(1)+EIRFT_Coeff(2)*x(i)+...
                          EIRFT_Coeff(3)*y(i)+EIRFT_Coeff(4)*x(i).^2+...
                          EIRFT_Coeff(5)*x(i)*y(i)+EIRFT_Coeff(6)*y(i).^2;  
end
%The part-load- ratio for each time-step is calculated.
for i=1:length(Validation_Dataset)
    Validation_Dataset(i,m_PLR)=Validation_Dataset(i,m_Q_e)/...
                                (Q_Spec*Validation_Dataset(i,m_CAPFT));
end

x=Validation_Dataset(:,m_PLR);
%For each timestep, the EIRFPLR- Value according to the provided
%coefficients is calculated.
for i=1:length(Validation_Dataset)
    Validation_Dataset(i,m_EIRFPLR)=EIRFPLR_Coeff(1)+EIRFPLR_Coeff(2)*x(i)+...
        EIRFPLR_Coeff(3)*x(i).^2;
end

for i=1:length(Validation_Dataset)
    Validation_Dataset(i,m_Qevaestimate)=Q_Spec*Validation_Dataset(i,m_CAPFT)*Validation_Dataset(i,m_PLR);
    Validation_Dataset(i,m_Pestimate)=Validation_Dataset(i,m_CAPFT)*Q_Spec/COP_Spec*...
        Validation_Dataset(i,m_EIRFT)*Validation_Dataset(i,m_EIRFPLR);
    %Validation_Dataset(i,m_Pestimate)=Validation_Dataset(i,m_Qevaestimate)/COP_Spec*...
    %Validation_Dataset(i,m_EIRFT)*Validation_Dataset(i,m_EIRFPLR);
    
    Validation_Dataset(i,m_Qconestimate)=-eta_0*(-Validation_Dataset(i,m_Qevaestimate)-Validation_Dataset(i,m_Pestimate));
end

RMSE_abs.P=mean(sqrt((Validation_Dataset(:,m_Pe)-Validation_Dataset(:,m_Pestimate)).^2));
RMSE_abs.Qeva=mean(sqrt((Validation_Dataset(:,m_Q_e)-Validation_Dataset(:,m_Qevaestimate)).^2));
if(m_Q_con ~= 0)
    RMSE_abs.Qcon=mean(sqrt((Validation_Dataset(:,m_Q_con)-Validation_Dataset(:,m_Qconestimate)).^2));
else
    RMSE_abs.Qcon = 0;    
end
RMSE_rel.P=(RMSE_abs.P/mean(Validation_Dataset(:,m_Pe)))*100;
RMSE_rel.Q_eva=(RMSE_abs.Qeva/mean(Validation_Dataset(:,m_Q_e)))*100;
if(m_Q_con ~= 0)
    RMSE_rel.Q_con=(RMSE_abs.Qcon/mean(Validation_Dataset(:,m_Q_con)))*100;
else
    RMSE_rel.Q_con = 0; 
end
% R2=1-sum((Validation_Dataset(:,m_P)-Validation_Dataset(:,m_Pestimate)).^2)/sum(Validation_Dataset(:,m_P)-mean(Validation_Dataset(:,m_P)).^2);
% print(R2);

%RMSE_Q_abs=sqrt(mean((Validation_Dataset(:,m_Q)-Validation_Dataset(:,m_Qevaestimate)).^2));
%RMSE_Q_rel=(RMSE_Q_abs/mean(Validation_Dataset(:,m_Q)))*100;
