% === Start: Turn MarsBaR ON if needed ===
marsbar('on');

% === Define your file paths ===
contrast_file = 'C:\Debashis\Research\ICDM_2025\fMRI_DDSA_Denmark_Dataset\fMRI_DDSA_Denmark_Dataset\Prediction_Analysis\Training\First_level_Analysis_SLD\sub-06\con_0001.nii';
atlas_file = 'C:\Debashis\Research\ICDM_2025\Yeo2011_7Networks_FSL_MNI152_2\Yeo2011_7Networks_FSL_MNI152_2mm.nii';  % Path to Yeo 7-networks volume (.nii)

% === Load the volumes ===
V_con = spm_vol(contrast_file);
V_atlas = spm_vol(atlas_file);

% === Check and Reslice if dimensions mismatch ===
if ~isequal(V_con.dim, V_atlas.dim)
    disp('Atlas and Contrast size mismatch. Reslicing Atlas...');
    
    % Set reslice flags
    flags = struct('interp',1,'wrap',[0 0 0],'mask',0,'which',1,'mean',0);
    
    % Reslice atlas to match contrast
    spm_reslice({contrast_file, atlas_file}, flags);
    
    % Reload resliced atlas
    [~, atlas_name, atlas_ext] = fileparts(atlas_file);
    resliced_atlas_file = fullfile(fileparts(atlas_file), ['r' atlas_name atlas_ext]);
    V_atlas = spm_vol(resliced_atlas_file);
end

% === Read in volumes ===
Y_con = spm_read_vols(V_con);     % Contrast image (subject activation)
Y_atlas = spm_read_vols(V_atlas); % Yeo7 atlas

% === Define the Yeo 7 Network Names ===
network_names = {
    'Visual', ...
    'Somatomotor', ...
    'Dorsal Attention', ...
    'Ventral Attention/Salience', ...
    'Limbic', ...
    'Control (Frontoparietal)', ...
    'Default Mode'
};

% === Extract mean activation for each Yeo network ===
roi_labels = unique(Y_atlas);
roi_labels(roi_labels == 0) = []; % Remove background

activation_per_network = [];  % Store mean activations

for i = 1:length(roi_labels)
    roi_mask = (Y_atlas == roi_labels(i)); % Create binary mask for current network
    roi_values = Y_con(roi_mask);          % Get activation values inside mask
    mean_activation = mean(roi_values, 'omitnan'); % Mean activation ignoring NaNs
    activation_per_network = [activation_per_network; mean_activation];
end

% === Apply Threshold ===
threshold = 0.1; % Activation threshold
filtered_activations = activation_per_network;
filtered_activations(filtered_activations < threshold) = 0; % Set low activations to zero

% === Build Table: Network Name + Activation ===
T = table(network_names', filtered_activations, ...
          'VariableNames', {'Network', 'MeanActivation'});

% === Save Results ===
output_folder = 'C:\Debashis\Research\ICDM_2025\ROI_Features_Yeo17\';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

save(fullfile(output_folder, 'sub-06_Yeo7_activation_thresholded.mat'), 'T');
writetable(T, fullfile(output_folder, 'sub-06_Yeo7_activation_thresholded.csv'));

% === Display Results ===
disp('Filtered (Thresholded) Mean Activation per Yeo 7 Network:');
disp(T);

disp('Extraction Complete. Thresholded features saved.');
