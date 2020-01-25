# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation:
#   https://github.com/github/hubot/blob/master/docs/scripting.md

# for executing external commands
child_process = require 'child_process'

YAML = require 'yamljs'

remocon_command_send = "bin/pi-send.sh"
remocon_command_list = "bin/pi-list.sh"
phrase_dict_file = "data/dict.yaml"

send_sig = (signal_name, res) ->
  child_process.exec "#{remocon_command_send} #{signal_name}", (error, stdout, stderr) ->
    if error?
      res.reply "error on send #{signal_name}: " + stderr + ""
    else
      res.reply "りょ"

str_contains = (sup, sub) ->
  sup.indexOf(sub) != -1

match_phrase = (phrasedef, phrase) ->
  if phrasedef.and?
    return phrasedef.and.every((ph) -> match_phrase(ph, phrase))
  else
    return str_contains phrase, phrasedef

match_single_sig = (sigdef, phrase) ->
  for phrasedef in sigdef.phrases
    if match_phrase phrasedef, phrase
      return sigdef.sig
  return null

get_sig = (phrase) ->
  sigdefs = YAML.load(phrase_dict_file)
  for sigdef in sigdefs
    sig = match_single_sig sigdef, phrase
    return sig if sig
  return null

module.exports = (robot) ->
  robot.respond /myecho (.+)/i, (res) ->
    res.reply res.match[1]

  robot.respond /send ([a-z0-9_]+)/i, (res) ->
    signal = res.match[1]
    send_sig signal, res
  
  robot.respond /lookup_send (.+)/i, (res) ->
    phrase = res.match[1]
    sig = get_sig phrase
    if sig
      send_sig sig, res
    else
      res.reply "unknown phrase: #{phrase}"

  robot.respond /list/i, (res) ->
    child_process.exec "#{remocon_command_list}", (error, stdout, stderr) ->
      if error?
        res.reply "error on list: " + stderr + ""
      else
        res.reply stdout + ''
  


  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
