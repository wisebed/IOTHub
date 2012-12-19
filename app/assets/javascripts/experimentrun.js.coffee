# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

new_experiment_run_path = () ->
  if window.location.toString().search("runs") >= 0
    window.location.toString().replace(/runs\/.*/,"runs/new")
  else
    window.location.toString()+"/runs/new"
jQuery ->
  $("#experiment_run_button").click ->
    $("#experiment_run").load(new_experiment_run_path())