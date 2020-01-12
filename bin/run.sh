#!/bin/sh

HUBOT_SLACK_TOKEN=`cat data/token` bin/hubot --adapter slack
