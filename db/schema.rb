# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130711105801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "questions", force: true do |t|
    t.text     "title"
    t.text     "answer"
    t.integer  "thread_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workfeed_thread_id"
    t.text     "representation"
    t.integer  "user_id"
    t.integer  "answer_id"
  end

  create_table "questions_topics", force: true do |t|
    t.integer "question_id"
    t.integer "topic_id"
  end

  create_table "topics", force: true do |t|
    t.integer  "workfeed_topic_id"
    t.text     "name"
    t.integer  "questions_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "mugshot_url"
    t.string   "permalink"
    t.string   "profile_url"
  end

end
