(($) ->

) jQuery

f_dur = 400

bid_symbols =
  4 : '4'
  5 : '5'
  6 : '6'
  7 : '&#x1F319;'
  14 : '&#x1F319;&#x1F319;'

suit_symbols = 
  'clubs':'<span>&#9827;</span>'
  'diamonds':'<span style="color: red;">&#9830;</span>'
  'spades':'<span>&#9824;</span>'
  'hearts':'<span style="color: red;">&#9829;</span>'
  'no trump': '<span>&#8709;</span>'

class Team

  constructor: (@player1, @player2) ->
    @name = ''
    @scores = [0]
    @players = [@player1, @player2]
    for player in @players
      player.setTeam(this)

  updatePoints: (newPoints) ->
    @scores.push(@score() + newPoints)

  score: () ->
    @scores[@scores.length - 1]

  setName: (newName) ->
    @name = newName

  victorious: (otherTeam) ->
    (@score() > otherTeam.score()) and (@score() >= 42)

  resetScore: () ->
    @scores = [0]

class Player

  constructor: (name) ->
    @name = name
    @teamAffil = null

  setTeam: (newTeam) ->
    @teamAffil = newTeam

  setName: (newName) ->
    @name = newName

class PepperGame

  constructor: (@team1, @team2) ->
    @i = 0
    @biddingTeams = []
    @defendingTeams = []
    @bidders = []
    @suits = []
    @bids = []
    @passPlays = []
    @players = [
      @team1.players[0],
      @team2.players[0],
      @team1.players[1],
      @team2.players[1]
    ]
    @teams = [@team1, @team2]

  biddingTeam: () ->
    # if @biddingTeams.length != @i + 1
      # alert("ERROR: number of bidding teams (#{@biddingTeams.length}) does " +
      # "not match number of hands (#{@i + 1}).")
    @biddingTeams[@biddingTeams.length - 1]

  defendingTeam: () ->
    # if @biddingTeams.length != @i + 1
      # alert("ERROR: number of defending teams (#{@defendingTeams.length}) " +
      # "does not match number of hands (#{@i + 1}).")
    @defendingTeams[@defendingTeams.length - 1]

  bidder: () ->
    # if @bidders.length != @i + 1
      # alert("ERROR: number of bidders (#{@bidders.length}) does not match " +
      # "number of hands (#{@i + 1}).")    
    @bidders[@bidders.length - 1]

  suit: () ->
    # if @suits.length != @i + 1
      # alert("ERROR: number of suits (#{@suits.length}) does not match number " +
      # "of hands (#{@i + 1}).")
    @suits[@suits.length - 1]

  bid: () ->
    # if @bids.length != @i + 1
      # alert("ERROR: number of bids (#{@bids.length}) does not match number " +
      # "of hands (#{@i + 1}).")
    @bids[@bids.length - 1]

  passPlay: ->
    # if @passPlay.length != @i + 1
      # alert("ERROR: number of passes/plays (#{@passPlays.length}) does not " +
      # "match number of hands (#{@i + 1}).")
    @passPlays[@passPlays.length - 1]    

  setBidder: (newBidder) ->
    @bidders.push(newBidder)

  setBid: (newBid) ->
    @bids.push(newBid)

  setTeams: () ->
    for team in @teams
      if @bidder() in team.players
        @biddingTeams.push(team)
      else
        @defendingTeams.push(team)

  setSuit: (newSuit) ->
    @suits.push(newSuit)

  setPassPlay: (newPassPlay) ->
    @passPlays.push(newPassPlay)    

  passRound: () ->
    @setBidder('Pass')
    @biddingTeams.push('pass')
    @defendingTeams.push('pass')
    @setBid('pass')
    @setSuit('pass')
    @setPassPlay('pass')

  getBidder: () ->
    dealer = @players[@i % 4]
    $( '.instruct' ).text("#{dealer.name} deals. Who won the bid?")
    $( '.instruct' ).fadeIn()
    $( '.btn-player' ).fadeIn()

  getBid: () ->
    $( '.instruct' ).text("Okay, what did #{@bidder().name} bid?")
    $( '.instruct' ).fadeIn()
    $( '.btn-bid' ).fadeIn()

  getSuit: () ->
    $( '.instruct' ).text("What suit is #{@bidder().name}'s bid in?")
    $( '.instruct' ).fadeIn()
    $( '.btn-suit' ).fadeIn()

  getDecision: () ->
    if @suit() == 'clubs'
      @setPassPlay('play')
      @getOutcome()
    else
      # setPassPlay will be called by buttons user presses
      $( '.instruct' ).html("#{@bidder().name} has bid " +
        "#{bid_symbols[@bid()]} in #{suit_symbols[@suit()]}. What will "+
        "#{@defendingTeam().name} do?")
      $( '.instruct' ).fadeIn()
      if @bid() == 4
        $( '.btn-decision4' ).fadeIn()
      else if @bid() == 5
        $( '.btn-decision5' ).fadeIn()
      else
        $( '.btn-decision-other' ).fadeIn()

  getOutcome: () ->
    if @suit() == 'clubs'
      $( '.instruct' ).html("Too bad for #{@defendingTeam().name}, they're " +
        "playing because #{@bidder().name} has bid #{bid_symbols[@bid()]} in " +
        "#{suit_symbols[@suit()]}. How many tricks did they get?")
      $( '.instruct' ).fadeIn()
    else
      $( '.instruct' ).html("#{@bidder().name} has bid #{bid_symbols[@bid()]} "+
        "in #{suit_symbols[@suit()]} and #{@defendingTeam().name} is playing. "+
        "How many tricks did they get?")
      $( '.instruct' ).fadeIn()
    $( '.btn-tricks' ).fadeIn()

  startPepperHand: () ->
    @setBidder(@players[(@i + 1) % 4])
    @setTeams()
    @setBid(4)
    dealer = @players[@i].name
    $( '.instruct' ).text("#{dealer} deals, and #{@bidder().name} " +
      "automatically bids #{@bid()}. What suit is it in?")
    $( '.instruct' ).fadeIn()
    $( '.btn-suit' ).fadeIn()

  startRegularHand: () ->
    dealer = @players[@i % 4].name
    $( '.instruct' ).text("#{dealer} deals. Who won the bid?")
    $( '.instruct' ).fadeIn()
    $( '.btn-player' ).fadeIn()

  defChange: (defenseTricks, theyStayed) ->
    if defenseTricks > 0
      if @bid() > 6
        @bid()
      else
        defenseTricks
    else
      if theyStayed then -@bid()  else 0

  bidChange: (defenseTricks) ->
    if @bid() < 7
      tricksAvailable = 6 - @bid()
    else
      tricksAvailable = 0
    if defenseTricks <= tricksAvailable
      @bid()
    else
      -@bid()

  updateScores: (bidder, bid, suit, team1Change, team2Change) ->
    @team1.updatePoints(team1Change)
    @team2.updatePoints(team2Change)
    dealer = @players[@i % 4]
    pepper = false
    if @i < 4
      pepper = true

    partialSet = false
    wasSet = false

    # Color code sets and weak sets
    if team1Change < 0
      team1ScoreString = "<span style='color:red;'>#{@team1.score()}</span>"
      if @team1 == @defendingTeam()
        if @suit() == 'clubs'
          partialSet = true
        else
          wasSet = true
      else
        if pepper
          partialSet = true
        else
          wasSet = true
    else
      team1ScoreString = "<span>#{@team1.score()}</span>"
    if team2Change < 0
      team2ScoreString = "<span style='color:red;'>#{@team2.score()}</span>"
      if @team2 == @defendingTeam()
        if @suit() == 'clubs'
          partialSet = true
        else
          wasSet = true
      else
        if pepper
          partialSet = true
        else
          wasSet = true
    else
      team2ScoreString = "<span>#{@team2.score()}</span>"

    # Make moons show up in bid
    bid = bid_symbols[bid]

    # Make all passes show up right
    if bidder == "Pass"
      bidString = "#{bidder}"
    else
      bidString = "#{bidder}-#{bid}#{suit}"

    # Update the detailed score table
    $( '#score tr:last' ).after( "<tr><td>#{@i + 1}</td><td>#{dealer.name}</td>" +
      "<td>#{team1ScoreString}</td>" +
      "<td>#{team2ScoreString}</td><td>#{bidString}</td></tr>")
    if wasSet
      $( '#score tr:last' ).addClass('danger')
    if partialSet
      $( '#score tr:last' ).addClass('warning')
    if @passPlay() == 'pass'
      $( '#score tr:last' ).addClass('success')
    score_1 = "#{@team1.score()}"
    score_2 = "#{@team2.score()}"
    $( '#team1-score' ).fadeOut(f_dur/2.0, () ->
      $( '#team2-score' ).fadeOut(f_dur/2.0, () ->     
        $( '#team1-score' ).text score_1
        $( '#team2-score' ).text score_2
        $( '#team1-score' ).fadeIn(f_dur/2.0, () ->
          $( '#team2-score' ).fadeIn(f_dur/2.0)
        )
      )
    )

    # End the game if someone has won, otherwise start the next hand
    if @team1.victorious(@team2)
      @triggerVictory(@team1)
    else if @team2.victorious(@team1)
      @triggerVictory(@team2)
    else
      @i += 1
      dealer = @players[@i%4].name 
      if @i < 4
        @startPepperHand()
      else
        @startRegularHand()

  triggerVictory: (team) ->
    $( '.instruct' ).text("#{team.name} has won the game!")
    $( '.instruct' ).fadeIn()    
    $( '#btn-restart' ).fadeIn()

  restart: () ->
    @i = 0
    @biddingTeams = []
    @defendingTeams = []
    @bidders = []
    @suits = []
    @bids = []
    team.resetScore() for team in @teams
    score_1 = "#{@team1.score()}"
    score_2 = "#{@team2.score()}"    
    $( '#score' ).html("<tr><th>Hand</th><th>Dealer</th>" +
    "<th>#{@team1.name}</th><th>#{@team2.name}</th><th>Bid</th></tr>")
    $( '#team1-score' ).fadeOut(f_dur/2.0, () ->
      $( '#team2-score' ).fadeOut(f_dur/2.0, () ->     
        $( '#team1-score' ).text score_1
        $( '#team2-score' ).text score_2
        $( '#team1-score' ).fadeIn(f_dur/2.0, () ->
          $( '#team2-score' ).fadeIn(f_dur/2.0)
        )
      )
    )
    @startPepperHand()


  revertToOutcome: ->
    # go back one hand
    @i -= 1

    # remove newest score
    @team1.scores.pop()
    @team2.scores.pop()

    # delete newest line in score table
    $( '#score tr:last' ).fadeOut(f_dur)
    $( '#score tr:last' ).remove()

    # update summary scores
    score_1 = "#{@team1.score()}"
    score_2 = "#{@team2.score()}"
    $( '#team1-score' ).fadeOut(f_dur/2.0, () ->
      $( '#team2-score' ).fadeOut(f_dur/2.0, () ->     
        $( '#team1-score' ).text score_1
        $( '#team2-score' ).text score_2
        $( '#team1-score' ).fadeIn(f_dur/2.0, () ->
          $( '#team2-score' ).fadeIn(f_dur/2.0)
        )
      )
    )    
    if @bidder() == 'Pass'
      @biddingTeams.pop()
      @defendingTeams.pop()
      @bidders.pop()
      @suits.pop()
      @bids.pop()
      @getBidder()
    else
      if @passPlay() == 'play'
        @getOutcome()
      else
        @revertToDecision()

  revertToPlayer: ->
    @bidders.pop()
    @getBidder()

  revertToBid: ->
    @bid.pop()
    @defendingTeams.pop()
    @biddingTeams.pop()
    @getBid()

  revertToSuit: ->
    @suits.pop()
    @getSuit()

  revertToDecision: ->
    @passPlays.pop()
    @getDecision()

$( document ).ready( ->

  player1 = new Player 'player1'
  player2 = new Player 'player2'
  player3 = new Player 'player3'
  player4 = new Player 'player4'
  team1 = new Team(player1, player3)
  team2 = new Team(player2, player4)
  game = new PepperGame(team1, team2)

  # set initial focus in first field
  $( '#player-1-name' ).focus()
  # stuff that happens once the "I like my names" button is pressed
  $( ".names form input" ).keypress( (e) ->
    if ((e.which and e.which == 13) or (e.keyCode and e.keyCode == 13))
      $('#name-submit').click()
      false
    else
      true
  )

  $( '#name-submit' ).click(() ->
    # save player names
    player1.setName $( '#player-1-name' ).val()
    player2.setName $( '#player-2-name' ).val()
    player3.setName $( '#player-3-name' ).val()
    player4.setName $( '#player-4-name' ).val()
    # update prompt for team names
    $( '#team-1-prompt' ).text("#{player1.name} and #{player3.name}'s team")
    $( '#team-2-prompt' ).text("#{player2.name} and #{player4.name}'s team")
    # fill in player names in buttons
    $( '#player-1' ).text(player1.name)
    $( '#player-2' ).text(player2.name)
    $( '#player-3' ).text(player3.name)
    $( '#player-4' ).text(player4.name)
    # fade out name selection screen, then fade in team name selection screen
    # $( '.names' ).fadeOut(f_dur, () -> $( '.teams' ).fadeIn())
    $('.names').fadeOut( () -> 
      $( '.teams' ).fadeIn( () -> $('#team-1-name').focus())
    )
  )

    
  # stuff that happens once the "I like my team names" button is pressed
  $( ".teams form input" ).keypress( (e) ->
    if ((e.which and e.which == 13) or (e.keyCode and e.keyCode == 13))
      $('#team-submit').click()
      false
    else
      true
  )

  $( '#team-submit' ).click () ->
    # save team names
    team1.setName $( '#team-1-name' ).val()
    team2.setName $( '#team-2-name' ).val()

    # put the appropriate team name in the DOM wherever it should show up
    $( '.team-1' ).text(team1.name)
    $( '.team-2' ).text(team2.name)

    # fade out team name selection screen, then bring in everthing in the games
    # setion except the non-suit buttons
    $( '.teams' ).fadeOut(f_dur,  () ->
      $( '.game' ).fadeIn()
    ) 
    # start with a pepper hand
    game.startPepperHand()

  # set behavior for every possible button... probably done poorly
  # PepperGame class takes care of showing stuff. Button actions should hide
  # themselves and then call the appropriate method in PepperGame.

  $( '#btn-restart' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '#btn-restart' ).fadeOut(f_dur,  () -> game.restart())
  )  

  # First do bidder buttons
  $( '#player-1' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-player' ).fadeOut(f_dur,  () -> 
      game.setBidder(player1)
      game.setTeams()
      game.getBid()
    )
  )
  $( '#player-2' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-player' ).fadeOut(f_dur,  () ->
      game.setBidder(player2)
      game.setTeams()
      game.getBid()
    )
  )    
  $( '#player-3' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-player' ).fadeOut(f_dur,  () ->
      game.setBidder(player3)
      game.setTeams()
      game.getBid()
    )
  )    
  $( '#player-4' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-player' ).fadeOut(f_dur,  () ->
      game.setBidder(player4)
      game.setTeams()
      game.getBid()
    )
  )    
  $( '#player-no' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-player' ).fadeOut(f_dur,  () -> 
      game.passRound()
      game.updateScores('Pass', '', '', 0, 0)
    )
  )

  # Bid buttons
  $( '#bid-4' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-bid' ).fadeOut(f_dur,  () -> 
      game.setBid(4)
      game.getSuit()
    )
  )    
  $( '#bid-5' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-bid' ).fadeOut(f_dur,  () -> 
      game.setBid(5)
      game.getSuit()
    )
  )    
  $( '#bid-6' ).click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-bid' ).fadeOut(f_dur,  () ->
      game.setBid(6)
      game.getSuit()
    )
  )    
  $( '#bid-7' ).click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-bid' ).fadeOut(f_dur,  () ->
      game.setBid(7)
      game.getSuit()
    )
  )    
  $( '#bid-14' ).click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-bid' ).fadeOut(f_dur,  () ->
      game.setBid(14)
      game.getSuit()
    )
  )    

  # Suit buttons
  $( '#clubs' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-suit' ).fadeOut(f_dur,  () -> 
      game.setSuit('clubs')
      game.getDecision()
    )
  )    
  $( '#diamonds' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-suit' ).fadeOut(f_dur,  () -> 
      game.setSuit('diamonds')
      game.getDecision()
    )
  )
  $( '#spades' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-suit' ).fadeOut(f_dur,  () -> 
      game.setSuit('spades')
      game.getDecision()
    )
  )
  $( '#hearts' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-suit' ).fadeOut(f_dur,  () ->
      game.setSuit('hearts')
      game.getDecision()
    )
  )
  $( '#no-trump' ).click(() -> 
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-suit' ).fadeOut(f_dur,  () ->
      game.setSuit('no trump')
      game.getDecision()
    )
  )

  # Decision buttons    
  $( '.pass' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(0, false)
      team2Change = game.bidChange(0)
    else
      team2Change = game.defChange(0, false)
      team1Change = game.bidChange(0)
    bid = game.bid()
    if bid == 4
      cls = '.btn-decision4'
    else if bid == 5   
      cls = '.btn-decision5'
    else
      cls = '.btn-decision-other'
    game.setPassPlay('pass')
    $( '.instruct' ).fadeOut(f_dur)
    $( cls ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '.pass1' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(1, false)
      team2Change = game.bidChange(1)
    else
      team2Change = game.defChange(1, false)
      team1Change = game.bidChange(1)
    bid = game.bid()
    if bid == 4
      cls = '.btn-decision4'
    else if bid == 5   
      cls = '.btn-decision5'
    else
      cls = '.btn-decision-other'
    game.setPassPlay('pass')
    $( '.instruct' ).fadeOut(f_dur)
    $( cls ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '.pass2' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(2, false)
      team2Change = game.bidChange(2)
    else
      team2Change = game.defChange(2, false)
      team1Change = game.bidChange(2)    
    bid = game.bid()
    if bid == 4
      cls = '.btn-decision4'
    else if bid == 5   
      cls = '.btn-decision5'
    else
      cls = '.btn-decision-other'
    game.setPassPlay('pass')
    $( '.instruct' ).fadeOut(f_dur)
    $( cls ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '.play' ).click(() -> 
    bid = game.bid()
    if bid == 4
      cls = '.btn-decision4'
    else if bid == 5   
      cls = '.btn-decision5'
    else
      cls = '.btn-decision-other'    
    game.setPassPlay('play')
    $( '.instruct' ).fadeOut(f_dur)
    $( cls ).fadeOut(f_dur,  () -> game.getOutcome())
  )

  # Outcome Buttons
  $( '#0-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(0, true)
      team2Change = game.bidChange(0)
    else
      team2Change = game.defChange(0, true)
      team1Change = game.bidChange(0)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '#1-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(1, true)
      team2Change = game.bidChange(1)
    else
      team2Change = game.defChange(1, true)
      team1Change = game.bidChange(1)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '#2-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(2, true)
      team2Change = game.bidChange(2)
    else
      team2Change = game.defChange(2, true)
      team1Change = game.bidChange(2)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '#3-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(3, true)
      team2Change = game.bidChange(3)
    else
      team2Change = game.defChange(3, true)
      team1Change = game.bidChange(3)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '#4-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(4, true)
      team2Change = game.bidChange(4)
    else
      team2Change = game.defChange(4, true)
      team1Change = game.bidChange(4)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '#5-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(5, true)
      team2Change = game.bidChange(5)
    else
      team2Change = game.defChange(5, true)
      team1Change = game.bidChange(5)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )
  $( '#6-tricks' ).click(() ->
    if game.team1 == game.defendingTeam()
      team1Change = game.defChange(6, true)
      team2Change = game.bidChange(6)
    else
      team2Change = game.defChange(6, true)
      team1Change = game.bidChange(6)
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur,  () ->
      game.updateScores(game.bidder().name, game.bid(),
        suit_symbols[game.suit()], team1Change, team2Change)
    )
  )

  #back buttons
  $( '.btn-player .btn-back' ).click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-player' ).fadeOut(f_dur, () ->
      game.revertToOutcome()  
    )
  )
  $( '.btn-bid .btn-back').click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-bid' ).fadeOut(f_dur, () ->
      game.revertToPlayer()
    )
  )
  $( '.btn-suit .btn-back').click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-suit' ).fadeOut(f_dur, () ->
      if game.i < 4
        if game.i == 0
          $( '.game' ).fadeOut(f_dur, () ->
            $( '.teams' ).fadeIn(f_dur)
          )
        else
          game.bidders.pop()
          game.defendingTeams.pop()
          game.biddingTeams.pop()
          game.bids.pop()
          game.revertToOutcome()
      else
        game.revertToBid()
    )
  )
  $( '.btn-decision4 .btn-back').click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-decision4' ).fadeOut(f_dur, () ->
      game.revertToSuit()
    )
  )

  $( '.btn-decision5 .btn-back').click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-decision5' ).fadeOut(f_dur, () ->
      game.revertToSuit()
    )
  )

  $( '.btn-decision-other .btn-back').click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-decision-other' ).fadeOut(f_dur, () ->
      game.revertToSuit()
    )
  )

  $( '.btn-tricks .btn-back').click(() ->
    $( '.instruct' ).fadeOut(f_dur)
    $( '.btn-tricks' ).fadeOut(f_dur, () ->
      if game.suit() == 'clubs'
        game.passPlays.pop()
        game.revertToSuit()
      else
        game.revertToDecision()
    )
  )
)




