# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121221151352) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "experiment_runs", :force => true do |t|
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "experiment_id",        :default => 0, :null => false
    t.string   "experiment_version"
    t.string   "experiment_data_host"
    t.string   "experiment_data_path"
    t.integer  "testbed_id"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string   "commit"
    t.integer  "user_id"
    t.integer  "runtime"
    t.string   "reservation"
    t.string   "failreason"
    t.string   "tb_exp_id"
    t.string   "state"
    t.string   "config_checksum"
    t.string   "download_config_url"
  end

  add_index "experiment_runs", ["commit"], :name => "index_experiment_runs_on_commit"

  create_table "experiment_users", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "experiments", :force => true do |t|
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.string   "name",                        :default => "awesome but unnamed experiment", :null => false
    t.integer  "user_id",                     :default => 0,                                :null => false
    t.string   "visibility",                  :default => "private",                        :null => false
    t.string   "default_download_config_url"
    t.string   "description"
  end

  create_table "testbeds", :force => true do |t|
    t.string   "wiseml_url"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "shortname"
    t.string   "name"
    t.string   "urn_prefix_list"
    t.string   "sessionManagementEndpointUrl"
  end

  add_index "testbeds", ["shortname"], :name => "index_testbeds_on_shortname"

  create_table "user_testbed_credentials", :force => true do |t|
    t.integer  "user_id"
    t.integer  "testbed_id"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_testbed_credentials", ["testbed_id"], :name => "index_user_testbed_credentials_on_testbed_id"
  add_index "user_testbed_credentials", ["user_id"], :name => "index_user_testbed_credentials_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                        :null => false
    t.string   "password"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "type",                         :default => "", :null => false
    t.string   "github_uid"
    t.string   "avatar_url"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
