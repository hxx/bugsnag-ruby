Feature: App type is set correctly for integrations in a Rails app

Background:
  Given I start the rails service
  And I run the "db:prepare" rake task in the rails app
  And I run the "db:migrate" rake task in the rails app

@rails_integrations
Scenario: Using Sidekiq as the Active Job queue adapter
  When I set environment variable "ACTIVE_JOB_QUEUE_ADAPTER" to "sidekiq"
  And I run "bundle exec sidekiq" in the rails app
  And I run "UnhandledJob.perform_later(1, yes: true)" with the rails runner
  And I wait to receive a request
  Then the request is valid for the error reporting API version "4.0" for the "Ruby Bugsnag Notifier"
  And the event "unhandled" is true
  And the event "context" equals "UnhandledJob@default"
  And the event "severity" equals "error"
  And the event "severityReason.type" equals "unhandledExceptionMiddleware"
  And the event "severityReason.attributes.framework" equals "Sidekiq"
  And the event "app.type" equals "sidekiq"
  And the exception "errorClass" equals "RuntimeError"
  And the event "metaData.active_job" is null
  And the event "metaData.sidekiq.msg.queue" equals "default"
  And the event "metaData.sidekiq.msg.class" equals "ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper"
  And the event "metaData.sidekiq.msg.wrapped" equals "UnhandledJob"
  And the event "metaData.sidekiq.msg.args.0.arguments.0" equals 1
  And the event "metaData.sidekiq.msg.args.0.arguments.1.yes" is true
  And the event "metaData.sidekiq.queue" equals "default"

@rails_integrations
Scenario: Using Rescue as the Active Job queue adapter
  When I set environment variable "ACTIVE_JOB_QUEUE_ADAPTER" to "resque"
  And I run "bundle exec rake resque:work" in the rails app
  And I run "UnhandledJob.perform_later(1, yes: true)" with the rails runner
  And I wait to receive a request
  Then the request is valid for the error reporting API version "4.0" for the "Ruby Bugsnag Notifier"
  And the event "unhandled" is true
  And the event "context" equals "UnhandledJob@default"
  And the event "severity" equals "error"
  And the event "severityReason.type" equals "unhandledExceptionMiddleware"
  And the event "severityReason.attributes.framework" equals "Resque"
  And the event "app.type" equals "resque"
  And the exception "errorClass" equals "RuntimeError"
  And the event "metaData.active_job" is null
  And the event "metaData.payload.class" equals "ActiveJob::QueueAdapters::ResqueAdapter::JobWrapper"
  And the event "metaData.payload.wrapped" equals "UnhandledJob"
  And the event "metaData.payload.args.0.arguments.0" equals 1
  And the event "metaData.payload.args.0.arguments.1.yes" is true
  And the event "metaData.payload.args.0.queue_name" equals "default"

@rails_integrations
Scenario: Using Que as the Active Job queue adapter
  When I set environment variable "ACTIVE_JOB_QUEUE_ADAPTER" to "que"
  And I run "bundle exec que -q default ./config/environment.rb" in the rails app
  And I run "UnhandledJob.perform_later(1, yes: true)" with the rails runner
  And I wait to receive a request
  Then the request is valid for the error reporting API version "4.0" for the "Ruby Bugsnag Notifier"
  And the event "unhandled" is true
  And the event "context" is null
  And the event "severity" equals "error"
  And the event "severityReason.type" equals "unhandledExceptionMiddleware"
  And the event "severityReason.attributes.framework" equals "Que"
  And the event "app.type" equals "que"
  And the exception "errorClass" equals "RuntimeError"
  And the event "metaData.active_job" is null
  And the event "metaData.job.wrapper_job_class" equals "ActiveJob::QueueAdapters::QueAdapter::JobWrapper"
  And the event "metaData.job.job_class" equals "UnhandledJob"
  And the event "metaData.job.args.0" equals 1
  And the event "metaData.job.args.1.yes" is true
  And the event "metaData.job.queue" equals "default"

@rails_integrations
Scenario: Using Delayed Job as the Active Job queue adapter
  When I set environment variable "ACTIVE_JOB_QUEUE_ADAPTER" to "delayed_job"
  And I run the "jobs:work" rake task in the rails app
  And I run "UnhandledJob.perform_later(1, yes: true)" with the rails runner
  And I wait to receive a request
  Then the request is valid for the error reporting API version "4.0" for the "Ruby Bugsnag Notifier"
  And the event "unhandled" is true
  And the event "context" equals "UnhandledJob@default"
  And the event "severity" equals "error"
  And the event "severityReason.type" equals "unhandledExceptionMiddleware"
  And the event "severityReason.attributes.framework" equals "DelayedJob"
  And the event "app.type" equals "delayed_job"
  And the exception "errorClass" equals "RuntimeError"
  And the event "metaData.active_job" is null
  And the event "metaData.job.payload.class" equals "ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper"
  And the event "metaData.job.payload.job_class" equals "UnhandledJob"
  And the event "metaData.job.payload.arguments.0" equals 1
  And the event "metaData.job.payload.arguments.1.yes" is true
  And the event "metaData.job.queue" equals "default"
