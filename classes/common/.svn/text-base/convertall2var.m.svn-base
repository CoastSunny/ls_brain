function [time channels] = convertall2var(obj,time,channels)

    if ( strcmp( channels, 'all' ) )
        channels = 1:numel(obj.data.label);
    elseif (~isnumeric(channels))
        channels=find(ismember(obj.data.label,channels));
    end
    if ( strcmp( time, 'all' ) )
        time = 1:numel(obj.data.time{1});
    end

end