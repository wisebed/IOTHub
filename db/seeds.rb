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
marv_password = 'foobarfoobar123'
marv = AdminUser.create({name: 'Marvin Administratore', email: 'frick@informatik.uni-luebeck.de', password: marv_password})
marten = User.create({name: 'Marten Experimenteur', email: 'biomarten@forschungseinrichtung.edu', password: 'foobaz'})
daniel = User.create({name: 'Daniel Überprüfer', email: 'bimschas@itm.uni-luebeck.de', password: 'bazbar'})

# Experiments
Experiment.delete_all
Experiment.create([
    {name: 'Martens erstes Experiment', user_id: marten.id},
    {name: 'Martens öffentliches Experiment', user_id: marten.id, :visibility => 'public'}])

# Testbeds
Testbed.delete_all
tb_uzl =Testbed.create({shortname: "uzl",
                        name: "University of Lübeck, Germany (UZL)",
                        urn_prefix_list: "urn:wisebed:uzl1:",
                        sessionManagementEndpointUrl: "http://wisebed.itm.uni-luebeck.de:8888/sessions",
                        wiseml_url: 'http://wisebed.itm.uni-luebeck.de/rest/2.3/uzl/experiments/network'},
                       :without_protection => true)

Testbed.create([{shortname: "tubs",
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
