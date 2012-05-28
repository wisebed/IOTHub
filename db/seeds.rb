# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users
User.delete_all
marv = User.create({name: 'Marvin Administratore', email: 'frick@informatik.uni-luebeck.de', password: 'foobar'})
marten = User.create({name: 'Marten Experimenteur', email: 'biomarten@forschungseinrichtung.edu', password: 'foobaz'})
daniel = User.create({name: 'Daniel Überprüfer', email: 'bimschas@itm.uni-luebeck.de', password: 'bazbar'})

# Experiments
Experiment.delete_all
Experiment.create({name: 'Martens erstes Experiment', user_id: marten.id})
Experiment.create({name: 'Martens öffentliches Experiment', user_id: marten.id, :visibility => 'public'})