clear;
filename = 'A01T.gdf';
[s, HDR] = sload(filename);

s = s(:, 1:22);

type=HDR.EVENT.TYP;
pos=HDR.EVENT.POS;
dur=HDR.EVENT.DUR;
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

signals = [A01T_C1; A01T_C2; A01T_C3; A01T_C4];
class1 = ones(size(A01T_C1, 1), 1);
class2 = 2*ones(size(A01T_C2, 1), 1);
class3 = 3*ones(size(A01T_C3, 1), 1);
class4 = 4*ones(size(A01T_C4, 1), 1);

labels = [class1;class2;class3;class4];

indices = randperm(size(signals, 1));

% Shuffle the data and labels using the same indices
shuffledData = signals(indices, :, :);
shuffledLabels = labels(indices, :);

data3 = struct('x', shuffledData, 'y', shuffledLabels);



json_data = jsonencode(data3);
fid = fopen('data4.json', 'w');
fprintf(fid, '%s', json_data);
fclose(fid);
