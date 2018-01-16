function varargout = MASNET_GUI(varargin)
% MASNET_GUI MATLAB code for MASNET_GUI.fig
%      MASNET_GUI, by itself, creates a new MASNET_GUI or raises the existing
%      singleton*.
%
%      H = MASNET_GUI returns the handle to a new MASNET_GUI or the handle to
%      the existing singleton*.
%
%      MASNET_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASNET_GUI.M with the given input arguments.
%
%      MASNET_GUI('Property','Value',...) creates a new MASNET_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MASNET_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MASNET_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MASNET_GUI

% Last Modified by GUIDE v2.5 19-Dec-2017 23:39:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MASNET_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MASNET_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MASNET_GUI is made visible.
function MASNET_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MASNET_GUI (see VARARGIN)

% Choose default command line output for MASNET_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MASNET_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MASNET_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%--- Executes on button press in em_terr.
function em_terr_Callback(hObject, eventdata, handles)
% hObject    handle to em_terr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% EM Terrano files were provided by Fahd, and the code is written by Heba
%%% the parameters used in EM Terrano are 20 sensors,transmit power 23 dBm,
%%% the coordinates used in EM Terrano are chosen according to Heriot Watt
%%% University Campus (Car parking beside Earl MountBatten Building)
%%% save the EM Terrano file in variable OutPutTable
%%% This variable choose the type of the scenario 1 for mixed and 0 for separated
%%%% Define the parameters in the GUI  that we will select
mix = get(handles.mixed,'value');
sep = get(handles.sep,'value');
if mix == 1 
    Type_Scenario = 1;
elseif sep == 1
    Type_Scenario = 0;
end
    
%%% chosse the transmit power of Pt = 23 dBm (-7dBW) or Pt = -23 dBW
Pt = 23;
if Type_Scenario == 1
    if Pt == -23 
        saveVarsMat = load('OutPutTable_Heba_20RX_Mix_NEW_23dBW.mat');
    else
        saveVarsMat = load('OutPutTable_Heba_20RX_Mix_NEW_Positions_Plus23dBm.mat');
    end
    OutPutTable = saveVarsMat.ans;
else
    if Pt == -23
        saveVarsMat = load('OutPutTable_Heba_20RX_Sep_NEW_23dBW.mat');
    else
        saveVarsMat = load('OutPutTable_Heba_20RX_Sep_NEW_Positions_Plus23dBm.mat');
    end
    OutPutTable = saveVarsMat.ans;
end


%%% define speed of propagation (c) and dimension (p)
c = 3e8;
p = 3;
pks = nchoosek(20,5);
allCombs = combntns(1:20,5);
%%% Define Number of sensors
Nsensors = 20;
% for nn = 5:Nsensors
[Sensors,est_target,Target,Best_est_target,...
    Best_sensors,best_est_ls,est_ls,Best_est_targetL,...
    best_est_lsL,est_targetL,est_lsL] = localise_EMTerrano(Nsensors,OutPutTable,c,p,pks,allCombs,Pt);
%%% compute the error for exact distances ,actual_target,
% err_actual = norm(Target(1,:)-actual_target.');
%%% localisation error is computed as the distance between the actual and the estimated target locations
err = norm(Target(1,:)-est_target.');
err_best = norm(Target(1,:)-Best_est_target.');
err_ls = norm(Target(1,:)-est_ls.');
err_best_ls = norm(Target(1,:)-best_est_ls.');
errL = norm(Target(1,:)-est_targetL.');
err_bestL = norm(Target(1,:)-Best_est_targetL.');
err_lsL = norm(Target(1,:)-est_lsL.');
err_best_lsL = norm(Target(1,:)-best_est_lsL.');

for i = 1:size(Sensors,1)
    labels(i) = cellstr(num2str(i));
end

% %%% plot sensors' locations, actual and target locations
axes(handles.fig1)
s = plot3(Sensors(:,1),Sensors(:,2),Sensors(:,3),'bo','MarkerSize',8); hold on
tx = text(Sensors(:,1),Sensors(:,2),Sensors(:,3),labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
bs = plot3(Best_sensors(:,1),Best_sensors(:,2),Best_sensors(:,3),'ko','MarkerSize',8,'MarkerFaceColor','k'); hold on
t = plot3(Target(1,1),Target(1,2),Target(1,3),'rx','MarkerSize',8);
e = plot3(est_target(1,1),est_target(2,1),est_target(3,1),'r+','MarkerSize',8);
bt = plot3(Best_est_target(1,1),Best_est_target(2,1),Best_est_target(3,1),'k+','MarkerSize',8);
ls = plot3(est_ls(1,1),est_ls(2,1),est_ls(3,1),'r*','MarkerSize',8);
bls = plot3(best_est_ls(1,1),best_est_ls(2,1),best_est_ls(3,1),'k*','MarkerSize',8);
eL = plot3(est_targetL(1,1),est_targetL(2,1),est_targetL(3,1),'g+','MarkerSize',8);
btL = plot3(Best_est_targetL(1,1),Best_est_targetL(2,1),Best_est_targetL(3,1),'m+','MarkerSize',8);
lsL = plot3(est_lsL(1,1),est_lsL(2,1),est_lsL(3,1),'g*','MarkerSize',8);
blsL = plot3(best_est_lsL(1,1),best_est_lsL(2,1),best_est_lsL(3,1),'m*','MarkerSize',8);

grid on
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')
rotate3d on
if Type_Scenario ==1
    title('Mixed')
else
    title('Separated')
end
legend([s,bs,t,e,bt,ls,bls,eL,btL,lsL,blsL], 'Sensors','Best Sensors','Actual Target','Estimated SRDLS','Best Estimated SRDLS','Estimated LLS','Best Estimated LLS','Estimated SRDLS LOS','Best Estimated SRDLS LOS','Estimated LLS LOS','Best Estimated LLS LOS')
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% load the scenario and environment, all parameters are defined using
%%% Config.txt file
mix = get(handles.mixed,'value');
sep = get(handles.sep,'value');
rur = get(handles.rural,'value');
urb = get(handles.urban,'value');

if sep ==1 && urb == 1
    load('local_sep_urban100_Pt-33.mat');
    mu = -7;
elseif mix ==1 && urb == 1
    load('local_mixed_urban100_Pt-33.mat');
    mu=-7;
elseif sep ==1 && rur == 1
    load('local_sep_rural100_Pt-33.mat');
    mu = -8;
elseif mix ==1 && rur == 1
     load('local_mixed_rural100_Pt-33.mat');
     mu = -8;
end

%%%% definitions
cc = 3e8;
%%% n_signals is the number of signals that the target transmits and it is
%%% used here to refer to number of time slots, we use multiple time slots
%%% to have more measurements and the result is the averaged localization error
n_signals= 1; % these are the values used in this simulation [1 5 10]
% number of target
n_targets = 1;
%%% number of sensors
n_sensors =100;
% sensors locations
A = Sensors;
% target location
T = Pos_target;
d = sqrt((T(1)-A(:,1)).^2+(T(2)-A(:,2)).^2+(T(3)-A(:,3)).^2);
% define a matrix with zeros initially, then when sensor detects the signal
% the value is switched to one
What = zeros(n_sensors,1000);
tic
%for ns =1:length(n_signals)
    % define a counter to know how many times no local
    counter = 0;
    %%% SNR and Pd are computed in the detection part (done by Loukianos), 
        %%% the values used in this code are for one winner channel realisation 
        %%%according to the fixed target and sensors locations 
        %%% for 10 different time slots 
        snr_avg = mean(snr_lin(:,1:n_signals),2);
        P_d = calculating_Prob_detection_update(AC_sample,Td,Tc,snr_avg,Pfa);
    for kk =1:1
        % define delay added to actual flight time, as stated in winner
        % handbook, an exponentially distributed, the mean of this
        % distribution is chosen according to the environment (rural or
        % urban), mu = -8 for rural and -7 for urb
        dnoise = (exprnd(10^mu,[n_sensors,n_signals]))*cc;
        dhat = d+dnoise;
        
        %%% according to the probability of detection for each sensor, we
        %%% compute the number of iterations in which the sensor detected
        %%% the signal through 1000 iterations. For example, if the sensor
        %%% has Pd = 0.7, this corresponds that the sensor was active in
        %%% 700 iterations and inactive in 300 iterations. 
        Pd_iter = round(P_d*1000);
        %%%% We define a masking matrix of 1s and 0s, if the entry is 1
        %%%% means sensor detected and 0 otherwise. The dimensions of this
        %%%% matrix is n_sensors x n_iterations.First we fill this matrix
        %%%% with 1s and 0s according to Pd, then for each iteration, we
        %%%% check in one column how many sensors were active to perform
        %%%% localisation.
        for jj=1:n_sensors % This loop for all sensors to calculate if the signal is heard by each sensor
            ind = randperm(1000,Pd_iter(jj));
            W = What(jj,:);
            W(ind) = 1;
            W_mask(jj,:) = W;
        end
        W_active = W_mask(:,kk);
        % this parameter gives the number of sensors that didn't detect
        % the signal
        %sensors_no_detect = n_sensors-sum(W_active);
        %%%% only if the active sensors is more than 5 then localisation can be
        %%%% performed. Using only the active sensors at each iteration and
        %%%% their corresponding receiving times, the estimated target
        %%%% location is computed
        if sum(W_active)>=5
            %%% only sensors that detected will be active
            b = (W_active.*A);
            %%% this step is to remove all zero rows
            active_sensors = b(any(b,2),:);
            %%% compute the reference sensor node from the active sensors
            A_sensors = active_sensors-active_sensors(1,:);
            %%% same approach for the corresponding distance and distance
            %%% differences measurements
            d_active = nonzeros(W_active.*dhat);
            d_hat = d_active-d_active(1);
            %%% the relative estimated target location wrt reference node is computed
            Y(:,kk) = localize_srdls(A_sensors,d_hat);
            %%% the absolute estimated target node is computed
            est_target(kk,:) = Y(1:3,kk).'+active_sensors(1,:);
            est_target = abs(est_target);
            
            %%% since we calculate the absolute positions and all
            %%% coordinates are positive, we consider the absolute value
            %%% for the estimated target location
            
            %%% the localisation error is computed
            %err(:,kk) = norm(T-est_target(kk,:));
            else
            counter = counter+1;
            warning('Not enough sensors for localisation');
        end
    end
        
%     No_localisation(ns) = counter;
%     %%% we need to count how many time SRD-LS couldn't reach a global
%     %%% optimum solution, the estimated target location will be equal to reference node 
%     %%% the relative estimated target location is the all zero vector
%     [~,id] = find(err(ns,:)~=norm(T-active_sensors(1,:)));
%     eff_err = err(ns,id); 
%    %%%% average error for the nonzero values only, so that we average over
%    %%%% only the iterations that more than 5 sensors detected the signal 
%     avg_err(ns) = mean(nonzeros(err(ns,id)));
%end
for i = 1:size(Sensors,1)
    labels(i) = cellstr(num2str(i));
end
%%% plot sensors' locations, actual and target locations
axes(handles.fig1)
s = plot3(Sensors(:,1),Sensors(:,2),Sensors(:,3),'bo','MarkerSize',8); hold on
tx = text(Sensors(:,1),Sensors(:,2),Sensors(:,3),labels,'VerticalAlignment','bottom','HorizontalAlignment','right');
%bs = plot3(Best_sensors(:,1),Best_sensors(:,2),Best_sensors(:,3),'ko','MarkerSize',8,'MarkerFaceColor','k'); hold on
t = plot3(T(1,1),T(1,2),T(1,3),'rx','MarkerSize',8);
e = plot3(est_target(1,1),est_target(1,2),est_target(1,3),'r+','MarkerSize',8);
%bt = plot3(Best_est_target(1,1),Best_est_target(2,1),Best_est_target(3,1),'k+','MarkerSize',8);
%ls = plot3(est_ls(1,1),est_ls(2,1),est_ls(3,1),'r*','MarkerSize',8);
%bls = plot3(best_est_ls(1,1),best_est_ls(2,1),best_est_ls(3,1),'k*','MarkerSize',8);
%eL = plot3(est_targetL(1,1),est_targetL(2,1),est_targetL(3,1),'g+','MarkerSize',8);
%btL = plot3(Best_est_targetL(1,1),Best_est_targetL(2,1),Best_est_targetL(3,1),'m+','MarkerSize',8);
%lsL = plot3(est_lsL(1,1),est_lsL(2,1),est_lsL(3,1),'g*','MarkerSize',8);
%blsL = plot3(best_est_lsL(1,1),best_est_lsL(2,1),best_est_lsL(3,1),'m*','MarkerSize',8);

grid on
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')
rotate3d on
if mix ==1
    title('Mixed')
else
    title('Separated')
end
rotate3d on


legend([s,t,e], 'Sensors','Actual Target','Estimated SRDLS')
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mixed,'value',0);
set(handles.sep,'value',0);
set(handles.rural,'value',0);
set(handles.urban,'value',0);
axes(handles.fig1)
cla reset


% --- Executes on button press in rural.
function rural_Callback(hObject, eventdata, handles)
% hObject    handle to rural (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rural


% --- Executes on button press in urban.
function urban_Callback(hObject, eventdata, handles)
% hObject    handle to urban (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of urban


% --- Executes on button press in mixed.
function mixed_Callback(hObject, eventdata, handles)
% hObject    handle to mixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mixed


% --- Executes on button press in sep.
function sep_Callback(hObject, eventdata, handles)
% hObject    handle to sep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sep
