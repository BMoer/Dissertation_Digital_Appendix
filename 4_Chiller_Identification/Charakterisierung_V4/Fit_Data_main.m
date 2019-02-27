clear all
Plot_Flag=1;

%Import Tables to be characterized
%Festlegung der relevanten Spalten (Kondensator, Verdampfer, Waerme, el.
%Leistung)
%tchws = the chilled water supply temperature
%tcws = the condenser water supply temperature 

m_CAPFT=7;
m_CAPFT_estimate=8;
m_EIRFT=9;
m_EIRFT_estimate=10;
m_PLR=11;
m_chillerEIRFPLR=12;
m_EIRFPLR_estimate=13;
m_eta0=14;
m_Qevaestimate=15;
m_Pestimate=16;
m_Qconestimate=17;

files = dir('*.csv');
for file = files'
    csv = load(file.name);
    machinename = sprintf(file.name);
    Machines.(machinename).Data = importDataasTable(csv);
end
% 
currentfolder=pwd;
myfolder=uigetdir('path_to_data');
cd(myfolder)

a=dir('*.csv');
names_cell = {a.name};

cd(currentfolder);

%%

for file = names_cell
    machinename = sprintf(strrep(char(file),'.csv',''));
    path=strcat(myfolder,'\',char(file));
    [Machines.(machinename).DataTable,Machines.(machinename).HeadNames]=importDataasTable(path);
    n=size(Machines.(machinename).DataTable,2);
    Machines.(machinename).Data=table2array(Machines.(machinename).DataTable(:,2:n));
    
    %initial inidzies
    Machines.(machinename).m_Tchws=0;
    Machines.(machinename).m_Tcnds=0;
    Machines.(machinename).m_Q_e=0;
    Machines.(machinename).m_Q_con=0;
    Machines.(machinename).m_Pe=0;
    
    %filter unused columns in Data
    %generate indizes for the used Data
     deleted = 0;

    for i = drange(1,length( Machines.(machinename).HeadNames))
        if(strcmp(Machines.(machinename).HeadNames(1,i),'T_Eva_Ein'))
             Machines.(machinename).m_Tchws = i-1-deleted;
        elseif(strcmp(Machines.(machinename).HeadNames(1,i),'T_Con_Ein'))
             Machines.(machinename).m_Tcnds = i-1-deleted;
        elseif(strcmp(Machines.(machinename).HeadNames(1,i),'Q_Eva'))
             Machines.(machinename).m_Q_e = i-1-deleted;
        elseif(strcmp(Machines.(machinename).HeadNames(1,i),'Q_Con'))
             Machines.(machinename).m_Q_con = i-1-deleted;
        elseif(strcmp(Machines.(machinename).HeadNames(1,i),'P_el'))
             Machines.(machinename).m_Pe = i-1-deleted;
        else
            %delete unused columns
            if(~strcmp(Machines.(machinename).HeadNames(1,i),'Timestamp'))
                Machines.(machinename).Data(:,i-1-deleted) = []; 
                deleted = deleted+1;
            end
        end
            
    end
end
%%
%Preprocessing
%generate struct for machine specific data

%removes zeros and outliers, filter unrealistic Temperatures

upper_cnds=30;
lower_cnds=15;
upper_chws=15;
lower_chws=4;

for file = names_cell
    machinename = sprintf(strrep(char(file),'.csv',''));
    Machines.(machinename).Data_filtered=outlier(Machines.(machinename).Data, 'zeros');
    Machines.(machinename).Data_filtered=outlier(Machines.(machinename).Data_filtered, 'outlier');
    
    if( Machines.(machinename).m_Tchws ~= 0)
        Machines.(machinename).Data_filtered=...
        Filter_for_temperatures(Machines.(machinename).Data_filtered,Machines.(machinename).m_Tchws,upper_chws,lower_chws);
    end
    
    if( Machines.(machinename).m_Tcnds ~= 0)
    Machines.(machinename).Data_filtered=...
        Filter_for_temperatures(Machines.(machinename).Data_filtered,Machines.(machinename).m_Tcnds,upper_cnds,lower_cnds);
    end
end

%%

%gernerate Data- Set for Training and Validation
splitratio=0.9;

for file = names_cell
    machinename = sprintf(strrep(char(file),'.csv',''));
    [Machines.(machinename).Training_Set,Machines.(machinename).Validation_Set]=...
        split_rng(Machines.(machinename).Data_filtered, splitratio);
end
%%
%Estimation

% gernerate FIT- Coefficients
% Q_Spec,P_Spec,EIR_Spec,CAPfT_Coeff,EIRfT_Coeff,EIRFPLR_Coeff,eta_0,gof,Estimates,Full_Load
for file = names_cell
    machinename = sprintf(strrep(char(file),'.csv',''));
    
    m_Tcnds = Machines.(machinename).m_Tcnds;
    m_Tchws = Machines.(machinename).m_Tchws;
    m_Q_e = Machines.(machinename).m_Q_e;
    m_Q_con = Machines.(machinename).m_Q_con;
    m_Pe = Machines.(machinename).m_Pe;
    
    if(~isempty(Machines.(machinename).Training_Set))
    [Machines.(machinename).Q_Spec,...
     Machines.(machinename).P_Spec,...
     Machines.(machinename).EIR_Spec,...
     Machines.(machinename).CAPfT_Coeff,...
     Machines.(machinename).EIRfT_Coeff,...
     Machines.(machinename).EIRFPLR_Coeff,...
     Machines.(machinename).eta_0,...
     Machines.(machinename).gof,...
     Machines.(machinename).Estimates,...
     Machines.(machinename).Full_Load,...
     Machines.(machinename).model_CAPfT,...
     Machines.(machinename).model_EIRfT]...
     =Estimation(Machines.(machinename).Training_Set,Plot_Flag, machinename,...
     m_Tcnds,m_Tchws,m_Q_e,m_Q_con,m_Pe,m_CAPFT,m_CAPFT_estimate,m_EIRFT,m_EIRFT_estimate,...
     m_PLR,m_chillerEIRFPLR,m_EIRFPLR_estimate,m_eta0);
    else
        ' Training Set is empty!'
    end
end


%%
%Validierung
 for file = names_cell
     
    machinename = sprintf(strrep(char(file),'.csv',''));
    
    m_Tcnds = Machines.(machinename).m_Tcnds;
    m_Tchws = Machines.(machinename).m_Tchws;
    m_Q_e = Machines.(machinename).m_Q_e;
    m_Q_con = Machines.(machinename).m_Q_con;
    m_Pe = Machines.(machinename).m_Pe;
    
     [Machines.(machinename).RMSE_abs, Machines.(machinename).RMSE_rel, Machines.(machinename).Validation_Dataset]=...
     Validation(Machines.(machinename).Validation_Set,...
     Machines.(machinename).CAPfT_Coeff,...
     Machines.(machinename).EIRfT_Coeff,...
     Machines.(machinename).EIRFPLR_Coeff,...
     Machines.(machinename).Q_Spec,...
     Machines.(machinename).EIR_Spec,...
     Machines.(machinename).eta_0,...
     m_Tcnds,m_Tchws,m_Q_e,m_Q_con,m_Pe,m_CAPFT,m_EIRFT,m_PLR,m_chillerEIRFPLR,...
     m_Qevaestimate,m_Pestimate,m_Qconestimate);

 disp(machinename);
 disp(strcat('P_el: ',num2str(Machines.(machinename).RMSE_rel.P)));
 disp(strcat('Q_con: ',num2str(Machines.(machinename).RMSE_rel.Q_con)));
 disp(strcat('Q_eva: ',num2str(Machines.(machinename).RMSE_rel.Q_eva)));
 end
 
