% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'C:\Debashis\Research\AAAI_2025\fMRI_DDSA_Denmark_Dataset\fMRI_DDSA_Denmark_Dataset\Prediction_Analysis\Batches\New_Batch_FuncPreprocessing_ADHD_SLD_job_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
