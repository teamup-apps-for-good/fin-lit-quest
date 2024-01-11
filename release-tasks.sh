#!/bin/bash

rails db:migrate
rails db:seed
rails assets:precompile
