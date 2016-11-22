function res = evaluate_performance(truth, est)
% Stefan Haufe, 2014, 2015
% stefan.haufe@tu-berlin.de
%
% Arne Ewald, 2015, mail@aewald.net
%
% If you use this code for a publication, please ask Stefan Haufe for the
% correct reference to cite.

% License
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see http://www.gnu.org/licenses/.

res=[];
senderflag=0;

% init
res.loc=0;
res.conn=0;
res.dir=0;

%% evaluate localization

if isfield(est,'rois') && ~isempty(est.rois)
    % if any ROI is provided
    
    if length(est.rois)<2
        % only one ROI is given
        if (strcmp(est.rois{1},truth.rois{1}))||...
                (strcmp(est.rois{1},truth.rois{2}))
            % correct
            res.loc=0.5;
        end
        if ~(strcmp(est.rois{1},truth.rois{1}))&&...
                ~(strcmp(est.rois{1},truth.rois{2}))
            % not correct
            res.loc=-0.5;
        end
    else
        % two ROIs given
        
        % if only one ROI is correct res.loc=0 (-0.5 + 0.5) as initialized
        
        % both are wrong
        if ~strcmp(est.rois{1},truth.rois{1})&& ...
                ~strcmp(est.rois{1},truth.rois{2})&& ...
                ~strcmp(est.rois{2},truth.rois{1})&& ...
                ~strcmp(est.rois{2},truth.rois{2})
            res.loc=-1;
        end
        
        % both are correct
        if (strcmp(est.rois{1},truth.rois{1})&& ...
                strcmp(est.rois{2},truth.rois{2}))
            res.loc=1;
        end
        if (strcmp(est.rois{2},truth.rois{1})&& ...
                strcmp(est.rois{1},truth.rois{2}))
            res.loc=1;
            % different order
            senderflag=1;
        end
    end
end

%% evaluate 'interaction'

if isfield(est,'interaction') && ~isempty(est.interaction)
    if est.interaction==truth.interaction
        res.conn=1;
    else
        res.conn=-2;
    end
end

%% evaluate 'direction'

if isfield(est,'sender') && ~isempty(est.sender)
    if truth.interaction==0
        res.dir=-2;
        %         return
    else
        % if there is interaction        
        if est.interaction == 1 
            % correct
            if (res.loc==1)&&(est.sender==1)&&(senderflag==0)
                res.dir=1;
            end
            if (res.loc==1)&&(est.sender==2)&&(senderflag==1)
                res.dir=1;
            end
            % wrong
            if (res.loc==1)&&(est.sender==1)&&(senderflag==1)
                res.dir=-2;
            end
            if (res.loc==1)&&(est.sender==2)&&(senderflag==0)
                res.dir=-2;
            end
            if ~(res.loc==1)
                if isfield(est,'rois') 
                    if length(est.rois)==2
                        res.dir=-2;
                    end
                end
            end
        end
    end
end

end % of function

