#!/bin/bash
bundle exec rerun --background --dir app,db,lib --pattern '{**/*.rb}' -- bundle exec sidekiq --verbose
