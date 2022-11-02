function [data,npts,nav] = get_tap_test_data()

waitfor(msgbox('Download TDMS Worker Functions and select folder'))
tdms_loc = uigetdir;

addpath(genpath(tdms_loc));

waitfor(msgbox('Select your .tdms data file'))
[fn,folder] = uigetfile('*.tdms');

ts = TDMS_getStruct([folder,fn]);

npts = inputdlg('Enter number of test points.');
nav = inputdlg('Enter number of averages.');

npts = str2double(npts{1});
nav = str2double(nav{1});

test_points = cell(npts,1);
for p = 1:npts
    test_points{p} = sprintf('point_%i',p);
end

test_force = cell(nav,1);
test_acc = cell(nav,1);
for p = 1:nav
    test_force{p} = sprintf('force_%i',p);
    test_acc{p} = sprintf('accel_%i',p);
end

data = struct;

for p = 1:npts
    if isfield(ts,test_points{p})
        data(p).time = repmat((0:1/2^14:4-1/2^16)',1,nav);
        data(p).input = zeros(2^16,nav);
        data(p).output = zeros(2^16,nav);
        for av = 1:nav
            if isfield(ts.(test_points{p}),test_force{av}) && isfield(ts.(test_points{p}),test_acc{av})
                nsamp = length(ts.(test_points{p}).(test_force{av}).data);
                data(p).input(1:nsamp,av) = ts.(test_points{p}).(test_force{av}).data;
                data(p).output(1:nsamp,av) = ts.(test_points{p}).(test_acc{av}).data;
            else
                warning('Point %i, average %i missing, check .tdms file',p,av)
            end            
        end
    else
        warning('Point %i missing, check .tdms file.',p)
    end
end




end
