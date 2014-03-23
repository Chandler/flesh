App.User = DS.Model.extend
  firstName:          DS.attr      'string'
  lastName:           DS.attr      'string'
  screenName:         DS.attr      'string'
  email:              DS.attr      'string'
  phone:              DS.attr      'string'
  avatarUrl:          DS.attr      'string'
  password:           DS.attr      'string'
  player:             DS.belongsTo 'player', { async: true }

App.Game = DS.Model.extend
  name:               DS.attr      'string'
  slug:               DS.attr      'string'
  avatarUrl:          DS.attr      'string'
  description:        DS.attr      'string'
  runningStartTime:   DS.attr      'string'
  players:            DS.hasMany   'player', { async: true }
  organization:       DS.belongsTo 'organization'

App.Organization = DS.Model.extend
  name:               DS.attr      'string'
  slug:               DS.attr      'string'
  description:        DS.attr      'string'
  users:              DS.hasMany   'user'
  games:              DS.hasMany   'game'

App.Player = DS.Model.extend
  status:             DS.attr       'string' #human/zombie/starved
  humanCode:          DS.attr       'string'
  game:               DS.belongsTo  'game'
  user:               DS.belongsTo  'user'

App.User.FIXTURES = [
  {
    id: 1,
    screenName: "cba",
    firstName: "Chandler",
    lastName: "Abraham",
    avatarUrl: "https://pbs.twimg.com/profile_images/3724531029/e7d7b43e709d9f5d80280c11a8263afc.jpeg",
    email: "chandler@flesh.io",
    phone: "12089912446",
    password: "candles"
    player: 1
  }, {
    id: 2,
    screenName: "arkenflame"
    firstName: "Mike",
    lastName: "Solomon",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000823542205/025c065b550ce9dfbf786ff746b5ec83.jpeg",
    email: "mike@flesh.io",
    phone: "12089912446",
    password: "bicyles"
    player: 2
  },
  {
    id: 3,
    screenName: "lndndrk"
    firstName: "Sasha",
    lastName: "Solomon",
    avatarUrl: "https://pbs.twimg.com/profile_images/437126131217494017/XCV2kv3l_bigger.jpeg",
    email: "sasha@flesh.io",
    phone: "12089912446",
    password: "flowers",
    player: 3
  },
  {
    id: 4,
    firstName: "Rick",
    lastName: "Bobby",
    screenName: "RickyBobby"
    avatarUrl: "https://pbs.twimg.com/profile_images/2649571860/910e545d7537be6148b7923aa86d2144.png",
    email: "rick@hotmail.com",
    phone: "12089912446",
    password: "rick",
    player: 4
  },
  {
    id: 5,
    firstName: "a",
    lastName: "b",
    screenName: "ThinMints",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 5
  },
  {
    id: 6,
    firstName: "a",
    lastName: "b",
    screenName: "TaylorSwift",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 6
  },
  {
    id: 7,
    firstName: "a",
    lastName: "b",
    screenName: "SlideFilm",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 7
  },
  {
    id: 8,
    firstName: "a",
    lastName: "b",
    screenName: "TomClancy",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 8
  },
  {
    id: 9,
    firstName: "a",
    lastName: "b",
    screenName: "OlympicFigureSkating",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
    player: 9
  },
  {
    id: 10,
    firstName: "a",
    lastName: "b",
    screenName: "AbsoluteCitron",
    avatarUrl: "https://pbs.twimg.com/profile_images/378800000324784929/1a4ee3fde80808a96ed268a7fb94682d_bigger.png",
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
    avatarUrl: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTCCdUls2NhompPan8buZ2vaCB_to7qBWUrqzSMuZNl5FeIVvZC",
    description: "the best university in the world",
    runningStartTime: "1393117973",
    players: [1,2,3,4,5,6,7,8,9,10],
    organization: 1

  }, 
  {
    id: 2,  
    name: "WSU fall game",       
    slug: "wsufall2012",
    runningStartTime: "1393117974",
    description: "pretty decent university",
    players: [4],
    organization: 2
  }
]

App.Player.FIXTURES = [
  {
    id: 1,
    status: "human",
    humanCode: "ASDF",
    user: 1,
    game: 1
  }, 
  {
    id: 2,
    status: "starved",
    humanCode: "NEWM",
    user: 2,
    game: 1
  },
  {
    id: 3,
    status: "zombie",
    humanCode: "USHF",
    user: 3,
    game: 1
  },
  {
    id: 4,
    status: "human",
    humanCode: "MKDL",
    user: 4,
    game: 2
  },
  {
    id: 5,
    status: "human",
    humanCode: "MKDL",
    user: 5,
    game: 1
  },
  {
    id: 6,
    status: "human",
    humanCode: "MKDL",
    user: 6,
    game: 1
  },
  {
    id: 7,
    status: "human",
    humanCode: "MKDL",
    user: 7,
    game: 1
  },
  {
    id: 8,
    status: "human",
    humanCode: "MKDL",
    user: 8,
    game: 1
  },
  {
    id: 9,
    status: "human",
    humanCode: "MKDL",
    user: 9,
    game: 1
  },
  {
    id: 10,
    status: "human",
    humanCode: "MKDL",
    user: 10,
    game: 1
  }
]
