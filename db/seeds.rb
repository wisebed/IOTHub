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
default_password = 'default_admin_password'
AdminUser.create({name: 'Seniore Administratore', email: 'admin@iothub', password: default_password})
experimenteur = User.create({name: 'Erwin Experimenteur', email: 'experimenteur@itm.uni-luebeck.de', password: nil})

# ExperimentRuns
ExperimentRun.delete_all

# Experiments
Experiment.delete_all
Experiment.create([{:name => 'Packet Tracking',
                    :user_id => experimenteur.id,
                    :visibility => 'public',
                    :default_download_config_url => "https://raw.github.com/itm/wisebed-experiments/master/packet-tracking/config.json",
                    :description => "A WISEBED experiment that simply collect all received and send packages on all nodes."
                   }],
                  :without_protection => true)

# Testbeds
Testbed.delete_all
Testbed.create([{shortname: "uzl",
                 name: "University of Lübeck, Germany (UZL)",
                 urn_prefix_list: "urn:wisebed:uzl1:",
                 sessionManagementEndpointUrl: "http://wisebed.itm.uni-luebeck.de:8888/sessions",
                 wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/uzl/experiments/network'},

                {shortname: "tubs",
                 name: "University of Braunschweig, Germany (TUBS)",
                 urn_prefix_list: "urn:wisebed:tubs:",
                 sessionManagementEndpointUrl: "http://wbportal.ibr.cs.tu-bs.de:8080/sessions",
                 wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/tubs/experiments/network'},

                {shortname: "cti",
                 name: "Computer Technology Institute & Press (CTI)",
                 urn_prefix_list: "urn:wisebed:ctitestbed:",
                 sessionManagementEndpointUrl: "http://hercules.cti.gr:8888/sessions",
                 wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/cti/experiments/network'},

                {shortname: "upc",
                 name: "Universitat Politecnica de Catalunya (UPC)",
                 urn_prefix_list: "urn:wisebed:upc1:",
                 sessionManagementEndpointUrl: "http://wisebed2.lsi.upc.edu:8888/sessions",
                 wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/upc/experiments/network'},

                {shortname: "fhl",
                 name: "Lübeck University of Applied Sciences, Germany (FHL)",
                 urn_prefix_list: "urn:wisebed-cosa-testbed-fhl1:",
                 sessionManagementEndpointUrl: "http://cosa-testbed-fhl1.fh-luebeck.de:49021/sessions",
                 wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/uzl/experiments/network'},

                {shortname: "sms",
                 name: "Smart Santander, Santander, Spain",
                 urn_prefix_list: "urn:smartsantander:testbed:",
                 sessionManagementEndpointUrl: "http://lira.tlmat.unican.es:9003/sessions",
                 wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/uzl/experiments/network'}],

               :without_protection => true)

# UserTestbedCredentials
UserTestbedCredential.delete_all