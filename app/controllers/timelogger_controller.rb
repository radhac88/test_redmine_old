class TimeloggerController < ApplicationController
require 'open-uri'
require 'rubygems'
require 'json'
require 'pp'
require 'net/http'
require "uri"
require 'active_resource'

#before_filter :verify_user
  $username=""
  $password=""
  def verify_user
  	if $username.nil? || $password.nil?
  		redirect_to login_url, :notice=>"Please Login to continue"
  	else
  		redirect_to report_url
  	end
  end

  def login
  	$username = nil
  	$password = nil
  	
  	$username = params[:user_name]
  	$password = params[:password]
  	if $username.nil? || $password.nil?
  		#redirect_to login_url, :notice=>"Please Login to continue"
  	else
  		redirect_to report_url
  	end
  end	
  def logout
  	$username = nil
  	$password = nil
  	redirect_to login_url
  end

end
