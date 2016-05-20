function event = caploader(event)

    switch event.hdr.usedcap
        case 'biosemi_cap256'
            capfile = 'cap256.txt';        
        case {'biosemi_cap64','virtual_cap64'}
            capfile = 'cap64.txt';
        otherwise
            capfile = 'cap64.txt';
            event = bs_warn(event,'Unknown cap specified in hdr.usedcap, default biosemi_cap64 is used!');    
    end
    
    % Get name of cap (without extension)
    [p, name_of_cap] = fileparts(capfile);

    % ---------- Load cap ----------
    
    % Read electrode locations in XYZ coordinates (Fieldtrip style)
    [label, lat, azi] = textread(capfile,'%s %f %f');

    %convert to radians
    cap.phi   = lat/180*pi;
    cap.theta = azi/180*pi;

    %go to carthesian
    x = sin(cap.phi).*sin(cap.theta);
    y = - sin(cap.phi).*cos(cap.theta);
    z = cos(cap.phi);

    cap.xyz = cat(2,x,y,z);
    
    cap.nchans = numel(x);
    cap.capfile = capfile;
        
    event.hdr.cap = cap;
        
    % Try to log the capfile
    if isfield(event,'Experiment')
        if ~isfield(event.Experiment,'CapInfoFiles')
            event.Experiment.CapInfoFiles = [];
        end        
        if isempty(strmatch(capfile, event.Experiment.CapInfoFiles,'exact'))    % If the cap file is not already logged
            event.Experiment.CapInfoFiles = vertcat(event.Experiment.CapInfoFiles, {capfile});  % Add the file to the cellstring of capfiles to log
        end
        
    else
        event = bs_warn(event,'If you want BrainStream to log the cap-file that you loaded, you must get and put the Experiment variable for this function.');
    end
end
