% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'C:\Debashis\Research\AAAI_2025\fMRI_DDSA_Denmark_Dataset\fMRI_DDSA_Denmark_Dataset\Prediction_Analysis\Batches\Batch_NonADHD_FirstLevelAnalysis_VLD_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
