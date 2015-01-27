App.User = DS.Model.extend
  first_name:          DS.attr      'string'
  last_name:           DS.attr      'string'
  screen_name:         DS.attr      'string'
  email:               DS.attr      'string'
  phone:               DS.attr      'string'
  avatar_url:          DS.attr      'string'
  password:            DS.attr      'string'
  active_player_id:    DS.attr      'number'
  active_game_id:      DS.attr      'number'
  players:             DS.hasMany   'player', { async: true }
  active_player: (->
    @get('players').findBy('id', @get('active_player_id'))
  ).property('players', 'active_player_id')

App.Game = DS.Model.extend
  name:               DS.attr      'string'
  slug:               DS.attr      'string'
  avatar_url:         DS.attr      'string'
  description:        DS.attr      'string'
  game_start:         DS.attr      'string'
  game_end:           DS.attr      'string'
  players:            DS.hasMany   'player', { async: true }
  organization:       DS.belongsTo 'organization'
  is_running: (->
    start = moment(@get('game_start'))
    end   = moment(@get('game_end'))
    now   = moment()
    (now > start && now < end)
  ).property('game_start', 'game_end')
  is_ended: (->
    end = moment(@get('game_end'))
    now = moment()
    (now > end)
  ).property('game_end')

App.Organization = DS.Model.extend
  name:               DS.attr      'string'
  slug:               DS.attr      'string'
  description:        DS.attr      'string'
  location:           DS.attr      'string'
  users:              DS.hasMany   'user'
  games:              DS.hasMany   'game'

App.Player = DS.Model.extend
  status:             DS.attr       'string'
  human_code:         DS.attr       'string'
  game:               DS.belongsTo  'game'
  user:               DS.belongsTo  'user'
  is_human: (->
    @get('status') == 'human'
  ).property('status')
  is_zombie: (->
    @get('status') == 'zombie'
  ).property('status')

App.Event = DS.Model.extend
  event_type:         DS.attr       'string'
  user:               DS.belongsTo  'user'
  game:               DS.belongsTo  'game'
  organization:       DS.belongsTo  'organization'
  player:             DS.belongsTo  'player'
  tag:                DS.belongsTo  'tag'
  created_at:         DS.attr       'raw'

App.Tag = DS.Model.extend
  tagger:     DS.belongsTo 'player'
  taggee:     DS.belongsTo 'player'
  event:      DS.belongsTo 'event'
  claimed:    DS.attr      'raw'

App.Event.FIXTURES = [
  {
    id: 1,
    tag: 1
    event_type: 'tag'
  },
  {
    id: 2,
    player: 2,
    event_type: 'join'
  }
]

App.Tag.FIXTURES = [
  {
    id: 1,
    tagger: 1,
    taggee: 2
  },
  {
    id: 2,
    tagger: 1,
    taggee: 2
  }
]

App.User.FIXTURES = [
  {
    id: 1,
    screen_name: "cba",
    first_name: "Chandler",
    last_name: "Abraham",
    avatar_url: "https://pbs.twimg.com/profile_images/3724531029/e7d7b43e709d9f5d80280c11a8263afc.jpeg",
    email: "chandler@flesh.io",
    phone: "12089912446",
    password: "candles"
    player: 1
  }, {
    id: 2,
    screen_name: "arkenflame"
    first_name: "Mike",
    last_name: "Solomon",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000823542205/025c065b550ce9dfbf786ff746b5ec83.jpeg",
    email: "mike@flesh.io",
    phone: "12089912446",
    password: "bicyles"
    player: 2
  },
  {
    id: 3,
    screen_name: "lndndrk"
    first_name: "Sasha",
    last_name: "Solomon",
    avatar_url: "https://pbs.twimg.com/profile_images/437126131217494017/XCV2kv3l_bigger.jpeg",
    email: "sasha@flesh.io",
    phone: "12089912446",
    password: "flowers",
    player: 3
  },
  {
    id: 4,
    first_name: "Rick",
    last_name: "Bobby",
    screen_name: "RickyBobby"
    avatar_url: "https://pbs.twimg.com/profile_images/2649571860/910e545d7537be6148b7923aa86d2144.png",
    email: "rick@hotmail.com",
    phone: "12089912446",
    password: "rick",
    player: 4
  },
  {
    id: 5,
    first_name: "a",
    last_name: "b",
    screen_name: "ThinMints",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 5
  },
  {
    id: 6,
    first_name: "a",
    last_name: "b",
    screen_name: "TaylorSwift",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 6
  },
  {
    id: 7,
    first_name: "a",
    last_name: "b",
    screen_name: "SlideFilm",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 7
  },
  {
    id: 8,
    first_name: "a",
    last_name: "b",
    screen_name: "TomClancy",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 8
  },
  {
    id: 9,
    first_name: "a",
    last_name: "b",
    screen_name: "OlympicFigureSkating",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 9
  },
  {
    id: 10,
    first_name: "a",
    last_name: "b",
    screen_name: "AbsoluteCitron",
    avatar_url: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 10
  }
]


App.Organization.FIXTURES = [
  {
    id: 1,
    name: "University of Idaho",
    slug: "uidaho",
    description: "the best university in the world",
    users: [1,2,3],
    games: [1]
  },
  {
    id: 2,
    name: "Washington State University",
    slug: "wsu",
    description: "pretty decent university",
    users: [4],
    games: [2]
  }
]

App.Game.FIXTURES = [
  {
    id: 1,
    name: "Idaho Fall Game",
    slug: "idahofall2012",
    avatar_url: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTCCdUls2NhompPan8buZ2vaCB_to7qBWUrqzSMuZNl5FeIVvZC",
    description: "the best university in the world",
    running_start_time: "1393117973",
    players: [1,2,3,4,5,6,7,8,9,10],
    organization: 1

  },
  {
    id: 2,
    name: "WSU fall game",
    slug: "wsufall2012",
    running_start_time: "1393117974",
    description: "pretty decent university",
    players: [4],
    organization: 2
  }
]

App.Player.FIXTURES = [
  {
    id: 1,
    status: "human",
    human_code: "ASDF",
    user: 1,
    game: 1
  },
  {
    id: 2,
    status: "starved",
    human_code: "NEWM",
    user: 2,
    game: 1
  },
  {
    id: 3,
    status: "zombie",
    human_code: "USHF",
    user: 3,
    game: 1
  },
  {
    id: 4,
    status: "human",
    human_code: "MKDL",
    user: 4,
    game: 2
  },
  {
    id: 5,
    status: "human",
    human_code: "MKDL",
    user: 5,
    game: 1
  },
  {
    id: 6,
    status: "human",
    human_code: "MKDL",
    user: 6,
    game: 1
  },
  {
    id: 7,
    status: "human",
    human_code: "MKDL",
    user: 7,
    game: 1
  },
  {
    id: 8,
    status: "human",
    human_code: "MKDL",
    user: 8,
    game: 1
  },
  {
    id: 9,
    status: "human",
    human_code: "MKDL",
    user: 9,
    game: 1
  },
  {
    id: 10,
    status: "human",
    human_code: "MKDL",
    user: 10,
    game: 1
  }
]
