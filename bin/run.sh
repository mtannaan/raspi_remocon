#!/bin/sh

# runs hubot with slack adapter.

HUBOT_SLACK_TOKEN=`cat data/token` bin/hubot --adapter slack
