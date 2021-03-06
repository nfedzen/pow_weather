Resort.destroy_all
User.destroy_all

Resort.create ({name: "Breckenridge", lat: 39.4817, long: -106.0384})
Resort.create ({name: "Keystone", lat: 39.5792, long: -105.9347})
Resort.create ({name: "Vail", lat: 39.6403, long: -106.3742})
Resort.create ({name: "Crested Butte", lat: 38.8697, long: -106.9878})
Resort.create ({name: "Beaver Creek", lat: 39.6042, long: -106.5165})
Resort.create ({name: "Arapahoe Basin", lat: 39.6425, long: -105.8719})
Resort.create ({name: "Aspen", lat: 39.1911, long: -106.8175})
Resort.create ({name: "Loveland Basin", lat: 39.6800, long: -105.8979})
Resort.create ({name: "Copper Mountain", lat: 39.5022, long: -106.1497})
Resort.create ({name: "Echo Mountain Park", lat: 39.6846, long: -105.5194})
Resort.create ({name: "Eldora", lat: 39.9486, long: -105.5639})
Resort.create ({name: "Monarch Mountain", lat: 38.5121, long: -106.3320})
Resort.create ({name: "Powderhorn Resort", lat: 39.0694, long: -108.1507})
Resort.create ({name: "Purgatory Resort", lat: 37.6302, long: -107.8140})
Resort.create ({name: "Silverton Mountain", lat: 37.8846, long: -107.6659})
Resort.create ({name: "Ski Cooper", lat: 39.3602, long: -106.3014})
Resort.create ({name: "Steamboat", lat: 40.4850, long: -106.8317})
Resort.create ({name: "Silverton Mountain", lat: 37.8846, long: -107.6659})
Resort.create ({name: "Sunlight", lat: 39.3998, long: -107.3388})
Resort.create ({name: "Telluride", lat: 37.9363, long: -107.8466})
Resort.create ({name: "Winter Park", lat: 39.8868, long: -105.7625})
Resort.create ({name: "Wolf Creek", lat: 37.4722, long: -106.7930})

nate = User.create username: "ncrotes", password_string: "password", age: 32, location: "Denver", favorite_resort: "Breckenridge"
