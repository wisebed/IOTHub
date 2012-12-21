module ExperimentrunHelper

  def experimentrun_staic_path(run,filename)
    run = ExperimentRun.find(run) unless run.is_a? ExperimentRun
    experiment_run_path(run.experiment,run)+"/static/"+filename
  end
end
