clear;

% load dataset
filename = 'A01T.gdf';
[s, HDR] = sload(filename);

% Extract EEG channels, discard EOG. First 22 channels are EEG
s = s(:, 1:22);

type=HDR.EVENT.TYP;
pos=HDR.EVENT.POS;
dur=HDR.EVENT.DUR;

% Extract left, right, foot, tongue time segments
iv_c1=1; iv_c2=1; iv_c3=1; iv_c4=1;
for i=1:size(type,1)
    if type(i,1)==769
        subdata=s(pos(i,1):pos(i,1)+dur(i,1),:);
        A01T_C1(iv_c1,:,:)=subdata;
        iv_c1=iv_c1+1;
    elseif type(i,1)==770
        subdata=s(pos(i,1):pos(i,1)+dur(i,1),:);
        A01T_C2(iv_c2,:,:)=subdata;
        iv_c2=iv_c2+1;
    elseif type(i,1)==771
        subdata=s(pos(i,1):pos(i,1)+dur(i,1),:);
        A01T_C3(iv_c3,:,:)=subdata;
        iv_c3=iv_c3+1;
     elseif type(i,1)==772
        subdata=s(pos(i,1):pos(i,1)+dur(i,1),:);
        A01T_C4(iv_c4,:,:)=subdata;
        iv_c4=iv_c4+1;
    end
end

% Create labels for dataset
signals = [A01T_C1; A01T_C2; A01T_C3; A01T_C4];
class1 = ones(size(A01T_C1, 1), 1);
class2 = 2*ones(size(A01T_C2, 1), 1);
class3 = 3*ones(size(A01T_C3, 1), 1);
class4 = 4*ones(size(A01T_C4, 1), 1);
labels = [class1;class2;class3;class4];

% Shuffle the data and labels using the same indices to be used for training
indices = randperm(size(signals, 1));
shuffledData = signals(indices, :, :);
shuffledLabels = labels(indices, :);

% Construct matlab struct
data_struct = struct('x', shuffledData, 'y', shuffledLabels);

% Save as json
json_data = jsonencode(data_struct);
fid = fopen('data_A01T.json', 'w');
fprintf(fid, '%s', json_data);
fclose(fid);
