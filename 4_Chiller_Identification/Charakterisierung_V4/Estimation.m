function [Q_ref,P_ref,COP_Spec,CAPfT_Coeff,EIRfT_Coeff,EIRFPLR_Coeff,eta_0,gof,Training,Full_Load,model_CAPfT,model_EIRfT]=...
    Charakterisierung(Training, Plot_Flag, machinename,m_Tcnds,m_Tchws,m_Q_e,m_Q_con,m_Pe,m_CAPFT,...
    m_CAPFT_estimate,m_EIRFT,m_EIRFT_estimate,m_PLR,m_chillerEIRFPLR,m_EIRFPLR_estimate,m_eta0)
%%
%Initialisierung

%Leistungsdaten laut Spezifikationen
%Step 1: maximum evaporator load is identified.
% [Q_ref, idx]=max(Training(:,m_Q_e));
% P_ref=Training(idx,m_Pe);
% while P_ref<mean(Training(:,m_Pe))
%     Training(idx,:)=[];
%     [Q_ref, idx]=max(Training(:,m_Q_e));
%     P_ref=Training(idx,m_Pe);
% end

[sorted,indx]=sort(Training(:,m_Q_e),'descend');
Q_ref=mean(sorted(1:10));
sorted_mat=Training(indx,:);
P_max=sorted_mat(:,m_Pe);
P_ref=mean(P_max(1:10));

COP_Spec=Q_ref/P_ref;

%%
%Berechnung der Charakterisierunggroessen
%Step 2: For each timestep, CAPFT is calculated.
Training(:,m_CAPFT)=Training(:,m_Q_e)*1/Q_ref;
%Step 3: The training- set is split into Full- Load and Part- Load sets,
%according to the CAPFT values.
filter_matrix = Training(:,m_CAPFT)>=0.85;
Full_Load=Training(filter_matrix,:);
%Step 4: For the full-load data set, the EIRFT is calculated at 
%each time-step
for i=1:length(Full_Load)
    Full_Load(i,m_EIRFT)=Full_Load(i,m_Pe)/(P_ref*Full_Load(i,m_CAPFT));
end
for i=1:length(Training)
    Training(i,m_EIRFT)=Training(i,m_Pe)/(P_ref*Training(i,m_CAPFT));
end

%Step 5: The full-load conditions data set is used to identify the
%coefficients of CapFTemp (aj) and EIRFTemp (bj)
if(m_Tchws ~=0 && m_Tcnds ~= 0) %multiple regression
    x=Full_Load(:,m_Tchws);
    y=Full_Load(:,m_Tcnds);
    [CAPfT_Coeff,model_CAPfT] = fit_data(x, y, Full_Load(:,m_CAPFT), Plot_Flag, strcat(machinename,' CAPfT'));
    [EIRfT_Coeff,model_EIRfT] = fit_data(x, y, Full_Load(:,m_EIRFT), Plot_Flag, strcat(machinename,' EIRfT'));
    
elseif(m_Tchws ~=0) %regression with one parameter
    [CAPfT_Coeff_temp,model_CAPfT] = fit(Full_Load(:,m_Tchws), Full_Load(:,m_CAPFT),'poly2');
    [EIRfT_Coeff_temp,model_EIRfT] = fit(Full_Load(:,m_Tchws), Full_Load(:,m_EIRFT),'poly2');
    
   if Plot_Flag==1
        % Plot fit with data.
        figure();
        h = plot( CAPfT_Coeff_temp, Full_Load(:,m_Tchws), Full_Load(:,m_CAPFT) );
        figure();
        h = plot( EIRfT_Coeff_temp, Full_Load(:,m_Tchws), Full_Load(:,m_EIRFT) );
    end
    
    CAPfT_Coeff_temp = coeffvalues(CAPfT_Coeff_temp);
    EIRfT_Coeff_temp = coeffvalues(EIRfT_Coeff_temp);
    
    CAPfT_Coeff = [CAPfT_Coeff_temp(3); CAPfT_Coeff_temp(2); 0; CAPfT_Coeff_temp(1); 0; 0];
    EIRfT_Coeff = [EIRfT_Coeff_temp(3); EIRfT_Coeff_temp(2); 0; EIRfT_Coeff_temp(1); 0; 0];

elseif(m_Tcnds ~= 0) %regression with one parameter
    [CAPfT_Coeff_temp,model_CAPfT] = fit(Full_Load(:,m_Tcnds), Full_Load(:,m_CAPFT),'poly2');
    [EIRfT_Coeff_temp,model_EIRfT] = fit(Full_Load(:,m_Tcnds), Full_Load(:,m_EIRFT),'poly2');
    
    if Plot_Flag==1
        % Plot fit with data.
        figure();
        h = plot( CAPfT_Coeff_temp, Full_Load(:,m_Tcnds), Full_Load(:,m_CAPFT) );
        figure();
        h = plot( EIRfT_Coeff_temp, Full_Load(:,m_Tcnds), Full_Load(:,m_EIRFT) );
    end
    
    CAPfT_Coeff_temp = coeffvalues(CAPfT_Coeff_temp);
    EIRfT_Coeff_temp = coeffvalues(EIRfT_Coeff_temp);
    
    CAPfT_Coeff = [CAPfT_Coeff_temp(3); 0; CAPfT_Coeff_temp(2); 0; 0; CAPfT_Coeff_temp(1)];
    EIRfT_Coeff = [EIRfT_Coeff_temp(3); 0; EIRfT_Coeff_temp(2); 0; 0; EIRfT_Coeff_temp(1)];    

else
    CAPfT_Coeff = [1; 0; 0; 0; 0; 0];
    EIRfT_Coeff = [1; 0; 0; 0; 0; 0];
    model_CAPfT = 0;
    model_EIRfT = 0;
end
    
% EIRfT_Coeff=EIRfT_Coeff/EIR_Spec;
%Step 6: Using the coefficients estimated in the previous step, the
%estimates of CapFTemp and EIRTemp are calculated for all the data
%in the training data set.
if(m_Tchws ~=0 && m_Tcnds ~= 0) %multiple regression
    x=Training(:,m_Tchws);
    y=Training(:,m_Tcnds);
    %Update of Training set. Using the hole set, values for the CAP according
    %to the found fit coefficients are used.
    for i=1:length(Training)
        Training(i,m_CAPFT_estimate)=CAPfT_Coeff(1)+CAPfT_Coeff(2)*x(i)+CAPfT_Coeff(3)...
                          *y(i)+CAPfT_Coeff(4)*x(i).^2+CAPfT_Coeff(5)*x(i)...
                          *y(i)+CAPfT_Coeff(6)*y(i).^2;
        Training(i,m_EIRFT_estimate)=EIRfT_Coeff(1)+EIRfT_Coeff(2)*x(i)+EIRfT_Coeff(3)...
                          *y(i)+EIRfT_Coeff(4)*x(i).^2+EIRfT_Coeff(5)*x(i)...
                          *y(i)+EIRfT_Coeff(6)*y(i).^2;                  
    end   
elseif(m_Tchws ~=0) %regression with one parameter
   x=Training(:,m_Tchws);
   for i=1:length(Training)
        Training(i,m_CAPFT_estimate)=CAPfT_Coeff(1)+CAPfT_Coeff(2)*x(i)+CAPfT_Coeff(4)*x(i).^2;
        Training(i,m_EIRFT_estimate)=EIRfT_Coeff(1)+EIRfT_Coeff(2)*x(i)+EIRfT_Coeff(4)*x(i).^2;                  
   end  
elseif(m_Tcnds ~= 0) %regression with one parameter
    y=Training(:,m_Tcnds);
    for i=1:length(Training)
        Training(i,m_CAPFT_estimate)=CAPfT_Coeff(1)+CAPfT_Coeff(3)*y(i)+CAPfT_Coeff(6)*y(i).^2;
        Training(i,m_EIRFT_estimate)=EIRfT_Coeff(1)+EIRfT_Coeff(3)*y(i)+EIRfT_Coeff(6)*y(i).^2;                  
    end    
else
    for i=1:length(Training)
        Training(i,m_CAPFT_estimate)=1;
        Training(i,m_EIRFT_estimate)=1;                  
    end 
end


%Step 7: The PLR and chiller EIRFPLR are calculated for all the data in the
%training data set. 
for i=1:length(Training)
    Training(i,m_PLR)=Training(i,m_Q_e)/(Q_ref*Training(i,m_CAPFT_estimate));
    Training(i,m_chillerEIRFPLR)=Training(i,m_Pe)/...
                                    (P_ref*Training(i,m_CAPFT_estimate)...
                                    *Training(i,m_EIRFT_estimate));
end


%Step 8: All the data in the training data set are used to identify the
%coefficients cj of EIRFPLR
x=Training(:,m_PLR);
[EIRFPLR_Coeff,gof]=fit_data2(x,Training(:,m_chillerEIRFPLR), Plot_Flag, strcat(machinename,' EIRfPLR'));
for i=1:length(Training)
    Training(i,m_EIRFPLR_estimate)=EIRFPLR_Coeff(1)+Training(i,m_PLR)*EIRFPLR_Coeff(2)+Training(i,m_PLR)*EIRFPLR_Coeff(3);
end
%%
%Step 9: COP for cooling energy is calculated here
if(m_Q_con ~=0)
    for i=1:length(Training)
        Training(i,m_eta0)=-Training(i,m_Q_con)/(-Training(i,m_Q_e)-Training(i,m_Pe));
    end
eta_0=mean(Training(:,m_eta0));
else
    eta_0 = 0;
end
