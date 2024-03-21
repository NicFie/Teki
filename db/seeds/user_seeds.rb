puts 'Creating Users'
User.create!(username: 'Waiting for Opponent...', email: 'opponent@mail.com', password: '123456', avatar: 'ninja.png', score: 0)
User.create!(username: '4ar0n', email: 'aaron@mail.com', admin: true, password: '123456', avatar: 'cool-emote.png', score: 0)
User.create!(username: 'Ch4r1y', email: 'charly@mail.com', password: '123456', avatar: 'cool-doge.png', score: 0)
User.create!(username: 'W1ll', email: 'will@mail.com', admin: true, password: '123456', avatar: 'cool-cactus.png', score: 0)
User.create!(username: 'N1c0l4', email: 'nicola@mail.com', admin: true, password: '123456', avatar: 'cool-duck.png', score: 0)
User.create!(username: 'UltimateRival', email: 'DuncanMcLeod@mail.com', admin: true, password: 'Highlander', avatar: 'coolest-duck.jpg', score: 0)

puts "#{Rainbow("
        __          __          __          __
      <(o )___    <(o )___    <(o )___    <(o )___
       ( ._> /     ( ._> /     ( ._> /     ( ._> /
        `---'       `---'       `---'       `---'").yellow.bright}

"
puts 'The four ducks of luck grant you safe passage, dont linger, they could change their mind.'
