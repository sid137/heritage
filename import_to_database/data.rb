#!/usr/bin/env ruby
require 'data_mapper'
require 'csv-mapper'

include CsvMapper
# Library homepage - http://csv-mapper.rubyforge.org/
# What Ruby programmers consider as documentation - http://csv-mapper.rubyforge.org/rdoc/
# http://csv-mapper.rubyforge.org/rdoc/classes/CsvMapper.html   Shows more
# detailed options

DataMapper::Logger.new($stdout, :debug)
#DataMapper.setup(:default, 'sqlite:///dataset.db')
DataMapper.setup(:default, 'sqlite::memory:')

class Member
  include DataMapper::Resource
  property :id, Integer, :key => true
  property :age_at_first_claim, String
  property :sex, String
end

class Claim
  include DataMapper::Resource
  property :id, Serial
  property :member_id, Integer
  property :provider_id, Integer
  property :vendor, Integer
  property :pcp, Integer
  property :year, String
  property :specialty, String
  property :place_svc, String
  property :pay_delay, String
  property :length_of_stay, String
  property :dsfc, String
  property :primary_condition_group, String
  property :charlson_index, String
  property :procedure_group, String
  property :sup_los, String
end

class PrimaryCondition
  include DataMapper::Resource
  property :primary_condition_group, String, :key => true
  property :description, String
end

class Procedure
  include DataMapper::Resource
  property :procedure_group, String, :key => true
  property :description, String
end

class DaysInHospitalY2
  include DataMapper::Resource
  property :member_id, String, :key => true
  property :claims_truncated, Integer
  property :days_in_hospital
end

class DaysInHospitalY3
  include DataMapper::Resource
  property :member_id, String, :key => true
  property :claims_truncated, Integer
  property :days_in_hospital
end

DataMapper.finalize
DataMapper.auto_migrate!

#--------------------------------------------------------------
# Load data from CSV files into database

import('../data/Members.csv') do
  map_to Member
  after_row lambda{|row, member| member.save }  # Call this lambda and save each record after it's parsed.
  start_at_row 1
  [id, age_at_first_claim, sex]
end

import('../data/Claims.csv') do
  map_to Claim
  after_row lambda{|row, claim| claim.save }  
  start_at_row 1
  [member_id, provider_id, vendor, pcp, year, specialty, place_svc, pay_delay, length_of_stay, dsfc, primary_condition_group, charlson_index, procedure_group, sup_los]
end

import('../data/Lookup PrimaryConditionGroup.csv') do
  map_to PrimaryCondition
  after_row lambda{|row, primary_condition| primary_condition.save }  
  start_at_row 1
  [primary_condition_group, description]
end

import('../data/Lookup ProcedureGroup.csv') do
  map_to Procedure
  after_row lambda{|row, procedure| procedure.save }  
  start_at_row 1
  [procedure_group, description]
end

import('../data/DaysInHospital_Y2.csv') do
  map_to DaysInHospitalY2
  after_row lambda{|row, days| days.save }  
  start_at_row 1
  [member_id, claims_truncated, days_in_hospital]
end

import('../data/DaysInHospital_Y3.csv') do
  map_to DaysInHospitalY3
  after_row lambda{|row, days| days.save }  
  start_at_row 1
  [member_id, claims_truncated, days_in_hospital]
end
