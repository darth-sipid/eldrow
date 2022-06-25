#!/usr/bin/perl

my $data_start = tell DATA;

my $word;
# https://www.gamespot.com/articles/wordle-best-starting-words-to-use-and-other-game-tips/1100-6499460/
my @seed_words = qw(react adieu later sired tears alone arise about atone irate
                    snare cream paint worse sauce anime prowl roast drape media);
my $guess = $seed_words[rand @seed_words];

my $rows = [];
my @blacklist = [];
my $known_right = qw(* * * * *);
my $known_good = {};
my $known_wrong = {};
my $known_wrong_positions = { # 0 denotes not known (or known right); 1 denotes known wrong
    "a" => [0,0,0,0,0], "b" => [0,0,0,0,0], "c" => [0,0,0,0,0], "d" => [0,0,0,0,0], "e" => [0,0,0,0,0], 
    "f" => [0,0,0,0,0], "g" => [0,0,0,0,0], "h" => [0,0,0,0,0], "i" => [0,0,0,0,0], "j" => [0,0,0,0,0], 
    "k" => [0,0,0,0,0], "l" => [0,0,0,0,0], "m" => [0,0,0,0,0], "n" => [0,0,0,0,0], "o" => [0,0,0,0,0], 
    "p" => [0,0,0,0,0], "q" => [0,0,0,0,0], "r" => [0,0,0,0,0], "s" => [0,0,0,0,0], "t" => [0,0,0,0,0], 
    "u" => [0,0,0,0,0], "v" => [0,0,0,0,0], "w" => [0,0,0,0,0], "x" => [0,0,0,0,0], "y" => [0,0,0,0,0], 
    "z" => [0,0,0,0,0]
};

TRIAL: for (my $i = 0; $i < 6; $i++) {
    print "Is the word '$guess'?\n";
    print "Enter pattern.\n";
    print "  0 for wrong (⬛).\n";
    print "  1 for right letter wrong place (🟨).\n";
    print "  2 for right letter right place (🟩).\n";
    print "  If my guess isn't in the world list, just press Enter.\n";
    my $pattern;
    while (1) {
        $pattern = <STDIN>;
        chomp $pattern;
        if ($pattern eq "22222") {
            $$rows[$i] = "22222";
            print_and_exit();
        }
        $$rows[$i] = $pattern;
        last if $pattern =~ /[012]{5}/;
        last if $pattern eq "";
        print "Try again.\n";
    }
    print "\n";
    if ($pattern eq "") {
        $i--;
        push(@blacklist, $guess);
    } else {
        my @positions = split(//, $pattern);
        my @letters = split(//, $guess);
        for (my $j = 0; $j < scalar @positions; $j++) {
            if ($positions[$j] eq "0") {
                $$known_wrong{$letters[$j]} = 1;
            }
        }
        for (my $j = 0; $j < scalar @positions; $j++) {
            if ($positions[$j] eq "1") {
                $$known_wrong_positions{$letters[$j]}[$j] = 1;
                delete $$known_wrong{$letters[$j]};
                $$known_good{$letters[$j]} = 1;
            }
        }
        for (my $j = 0; $j < scalar @positions; $j++) {
            if ($positions[$j] eq "2") {
                $$known_right[$j] = $letters[$j];
                delete $$known_wrong{$letters[$j]};
                $$known_good{$letters[$j]} = 1;
            }
        }
    }
    seek DATA, $data_start, 0;
    DATA: while (<DATA>) {
        chomp;
        $word = $_;
        @word_letters = split(//, $word);
        # Skip words on the black list
        foreach $bad (@blacklist) {
            next DATA if $bad eq $word;
        }
        # If the word contains incorrect characters, move on
        for (my $k = 0; $k < 5; $k++) {
            next DATA if $$known_wrong{$word_letters[$k]};
        }
        # if the word has a correct character in the wrong place, move on
        for (my $k = 0; $k < 5; $k++) {
            next DATA if $$known_wrong_positions{$word_letters[$k]}[$k];
        }
        # if the word has an incorrect character where a known character belongs, move on
        for (my $k = 0; $k < 5; $k++) {
            if ($$known_right[$k] ne "*") {
                next DATA if $$known_right[$k] ne $word_letters[$k];
            }
        }
        # if the word fails to use known_good characters, move on
        KG: foreach $key (keys %$known_good) {
            for (my $k = 0; $k < 5; $k++) {
                next KG if $key eq $word_letters[$k];
            }
            next DATA;
        }
        $guess = $word;
        last;
    }
}

print_and_exit();

sub print_and_exit {
    my $last_guess;
    my $score = scalar @$rows;
    print "\n$score/6\n";
    foreach(@$rows) {
        s/0/⬛/g;
        s/1/🟨/g;
        s/2/🟩/g;
        print "$_\n";
        $last_guess = $_;
    }
    if ($last_guess eq "🟩🟩🟩🟩🟩") {
        print "I win! 🥇\n";
    } else {
        print "I lose. 😔\n";
    }
    exit 0;
}

# Data derived from https://en.lexipedia.org

__DATA__
which
first
known
after
their
world
state
south
album
other
north
years
where
three
music
river
since
there
march
about
house
under
later
group
until
found
based
party
being
named
games
while
early
built
place
these
major
small
award
would
final
local
title
third
union
along
genus
radio
began
death
event
often
plays
royal
large
great
rural
times
field
among
coach
works
order
water
court
debut
japan
miles
white
black
china
total
power
actor
route
civil
given
films
short
medal
teams
video
novel
songs
level
moved
point
class
those
still
young
board
story
grand
owned
force
coast
media
rugby
books
roman
range
chief
round
track
areas
plant
wales
women
using
style
seven
human
chart
light
peter
green
stage
again
could
creek
model
space
saint
drama
lower
brown
eight
right
wrote
today
every
match
stars
whose
names
label
parts
trade
study
close
prior
smith
mount
minor
never
fifth
prize
added
youth
sound
night
least
cross
taken
above
front
means
upper
mayor
shows
press
beach
movie
dance
roles
opera
noted
spent
forms
stone
woman
lived
aired
super
metal
frank
hotel
urban
queen
tower
legal
prime
ended
heart
terms
staff
lives
rules
sixth
judge
refer
child
train
sport
cover
below
grade
maria
lines
voice
clubs
ocean
units
naval
mixed
earth
daily
hills
score
start
draft
horse
girls
takes
serve
corps
money
peace
comic
baron
honor
metro
falls
cases
heavy
ships
goals
arena
holds
brand
acres
weeks
trail
speed
store
trust
crime
block
seats
flows
paper
twice
joint
towns
owner
harry
welsh
sites
hours
types
issue
focus
basis
agent
blood
guard
count
split
labor
words
comes
theme
crown
value
shown
adult
older
reach
stock
sales
snail
color
table
grant
whole
drive
blues
motor
entry
armed
bands
steel
cause
canal
makes
ridge
chain
races
guest
going
trial
image
chair
month
basin
piano
scene
lists
cells
basic
brick
fleet
share
price
floor
banks
chile
trees
storm
allow
shore
lakes
votes
tribe
birth
dates
kings
glass
plans
pilot
birds
relay
roads
chess
solar
sides
roger
build
fight
piece
fully
might
newly
cycle
ninth
scale
reign
shape
squad
inner
parks
exist
hosts
clear
phase
frame
abbey
users
broad
manga
index
occur
guide
magic
grows
audio
cable
fruit
boxer
genre
break
billy
venue
lands
sense
mouth
jimmy
giant
homes
gives
ruled
views
mills
walls
dream
leave
stood
needs
bears
anime
stand
heads
voted
steam
claim
bible
goods
broke
hands
poems
offer
wings
yards
rapid
vocal
rocky
derby
notes
baker
ferry
sugar
brain
faith
funds
print
manor
delta
carry
rocks
equal
bring
lions
tenth
ideas
moths
brief
drums
outer
plain
chose
sweet
write
grove
roots
tools
siege
noble
marks
heard
elder
forum
robin
rifle
alone
villa
apple
enemy
worth
apart
angel
items
males
tours
strip
visit
wells
drawn
links
uncle
grown
enter
solid
grass
asked
moist
ghost
terry
organ
grace
woods
tried
quite
ahead
eagle
meant
hence
tests
ranks
elite
panel
rally
acted
globe
bobby
mines
rooms
hired
begin
plate
civic
crash
cargo
dated
leads
rower
plane
brook
tales
cards
fixed
extra
cited
doing
limit
alpha
ruler
think
sandy
drugs
plaza
rabbi
ratio
calls
tells
shell
aimed
avoid
lodge
mason
texts
happy
rider
depth
phone
throw
faced
scout
costs
snake
watch
fresh
choir
bonus
vinyl
truth
tiger
pages
cloud
rival
codes
boats
depot
speak
flies
shops
wheel
virus
blind
usage
layer
sharp
false
skier
rated
shrub
chase
wider
canon
rates
unity
spots
mouse
raise
thing
flood
abuse
seems
begun
orbit
duchy
logic
truck
marsh
gauge
waste
breed
heath
racer
elect
guild
rises
noise
haven
lying
slave
craft
seeds
shire
radar
files
deals
sheep
pairs
lords
ranch
ruins
peaks
pearl
meets
merit
angle
poets
signs
farms
exile
touch
fungi
flora
clean
alive
cream
fired
fluid
exact
rough
clerk
steps
gates
pitch
lunar
clock
cliff
faces
bases
bound
waves
graph
fifty
verse
burns
moral
cedar
widow
posts
learn
bates
coins
maker
shift
worst
camps
input
doors
pride
apply
grave
sword
genes
thick
favor
array
usual
foods
turns
smart
photo
flash
ivory
coral
error
rebel
forty
chuck
gross
maple
dwarf
buses
canoe
suite
grain
carol
moves
rings
ports
poker
ready
watts
sheet
winds
paint
bones
swing
trunk
filed
spans
devil
teach
sleep
drink
berry
yacht
stems
slope
meter
johns
hardy
laser
threw
teeth
twins
helps
zones
quest
shall
treat
finds
steep
glory
atlas
joins
aside
ideal
bills
firms
crops
curve
hawks
spell
gable
topic
dozen
porch
polar
crowd
alien
bonds
basal
fairy
naked
nurse
caves
olive
fever
inlet
taste
circa
swift
loose
brass
fraud
crazy
dress
fewer
vista
rayon
tenor
bread
trump
width
dairy
lover
tasks
cabin
dense
honey
downs
shock
proof
taxes
scope
robot
wheat
quick
nerve
draws
belle
trace
patch
empty
holes
randy
kinds
catch
wrong
bench
fault
seeks
wards
lynch
drake
edges
tries
asset
gecko
bulls
motto
vicar
essay
dying
blade
abbot
sings
deity
isles
bluff
vault
feast
vital
balls
sigma
soils
diary
trout
saved
looks
papal
gamma
dirty
crane
rides
spoke
lucky
tanks
raced
valid
prose
rouge
talks
skull
witch
grape
candy
forth
daisy
trips
stint
skill
gorge
realm
pasha
snout
stoke
disco
pupil
check
shark
stick
spend
stamp
tight
darts
bowls
liver
monks
halls
mound
tract
trend
woody
fauna
swamp
crest
sally
acids
cubic
sight
quiet
flute
mercy
acute
flags
smoke
prove
arrow
atoms
feeds
lease
humor
stake
roses
newer
pools
stops
sizes
shoot
colts
sworn
lotus
frost
inter
enjoy
butte
stern
shots
holly
frogs
tunes
booth
buddy
viola
veins
riots
fiber
alias
liner
poles
loyal
omega
overs
heats
valve
beast
demon
dodge
loved
toxic
blast
sells
amino
loans
shoes
fires
wants
cadet
fjord
drove
delay
homer
stony
wines
arose
chaos
facts
famed
solve
owing
dukes
hairy
sands
dealt
flint
lanes
modes
marry
yield
sonic
tidal
basil
viral
erect
sauce
paths
borne
comet
climb
flour
bells
paved
fatal
flats
whale
penny
slate
lyric
synod
lance
alley
eaten
flame
pound
tears
wives
privy
brave
algae
ultra
ponds
voter
wagon
troop
tooth
ashes
badge
opens
altar
ninja
email
wight
doubt
spike
shelf
lunch
knife
tumor
polls
chest
cello
amber
motif
bacon
beats
souls
bride
caste
salon
walks
birch
sonny
hello
atoll
stein
juice
bloom
peers
aided
boxes
discs
blend
aging
baton
wound
tough
cloth
theft
shaft
hopes
shade
oxide
tubes
nodes
arise
reads
merge
sixty
crews
paddy
raids
burnt
sunny
agree
lemon
alter
slide
badly
finch
aware
moody
stack
loves
flesh
piper
risks
spite
ducks
goose
moose
dunes
clash
flown
diver
decay
truly
coupe
dolls
beans
rover
stark
lined
seals
brush
gifts
pizza
focal
fried
tapes
donor
petty
smile
upset
raven
harsh
pulse
likes
tends
bombs
shale
funny
boots
panic
pagan
knows
chord
codex
punch
lacks
chips
curse
wreck
dried
curry
hymns
trick
cameo
adopt
truss
gains
hoped
bandy
wharf
twist
swept
hairs
spelt
bravo
reefs
beard
bucks
worms
shine
skate
hicks
adobe
revue
hogan
minds
crude
theta
sabre
tutor
tango
fence
forts
gases
forks
hatch
miner
cheap
horns
argue
alike
spare
wanna
piers
freed
tombs
daddy
picks
flank
pipes
fatty
tally
arbor
clown
jewel
gonna
scrub
welch
swami
habit
natal
screw
lobby
drain
annex
armor
prone
audit
heirs
proud
sears
slang
maxim
locks
teens
demos
forge
clans
click
bunny
angry
onset
shrew
rolls
chalk
thief
beech
moray
wills
wasps
oasis
niece
purse
batch
berth
drill
scrap
epoch
blank
probe
onion
mural
faint
icons
hazel
keeps
smash
vogue
parry
knots
drops
alert
leafs
clips
titan
drift
waltz
bliss
pinto
lasts
peach
rigid
pines
weird
banjo
otter
plots
myths
spine
stunt
spurs
kills
sloop
spice
gypsy
rogue
sedan
edged
mixes
serge
sting
herbs
shake
ester
hobby
maize
merry
queer
stuff
wages
heels
fanny
trams
rodeo
docks
penal
sahib
boost
torch
creed
crust
envoy
tones
cones
unite
tempo
aspen
islet
sedge
stuck
belly
anger
vowel
spark
loops
rainy
roach
chili
cache
saves
rains
firth
rites
ferns
alloy
feels
kitty
dolly
smell
yeast
sized
opted
hilly
shirt
urged
niche
worse
thumb
deeds
crush
fairs
hedge
cobra
earls
yahoo
spiny
milky
suits
tiles
norms
mecca
meals
tufts
crack
posed
alarm
sweep
rests
junta
lobes
cease
maybe
brake
multi
pygmy
skies
burst
blitz
quote
wears
knock
bison
golds
adapt
genie
drone
barge
sexes
straw
attic
thank
stiff
debts
psalm
rails
heron
viper
nests
baths
cruel
thorn
nasal
roofs
spear
drunk
fears
moors
malls
fuels
beers
paler
beams
quota
aster
backs
shear
goats
bayou
larva
mined
muddy
ditch
emery
binds
lever
patty
stout
reeve
mango
blunt
camel
euros
risen
paste
loads
liked
palms
swans
steal
snack
minus
fused
pumps
rhyme
blogs
colon
bunch
usher
charm
midst
blaze
bikes
panda
ceded
arias
buyer
gland
sends
urine
chick
coats
renal
chant
humid
surge
rusty
exams
sweat
spill
salts
champ
smoky
float
gangs
loser
salsa
crabs
spire
leach
lamps
prism
locus
limbs
tails
jokes
lungs
sided
fails
baked
fancy
sperm
cocoa
spray
lifts
friar
trait
clone
vivid
nails
cites
tying
wedge
yours
stare
loses
squid
wired
lopes
spies
masks
cents
venom
karma
vapor
wires
sited
elbow
salad
grams
stays
blame
snowy
butch
tulip
fools
septa
triad
opium
fours
shame
shiny
bouts
setup
trash
kicks
perch
seize
twain
woven
resin
crook
rhino
blown
rotor
sorry
idols
grill
samba
pedal
valor
tides
shady
expos
vague
optic
lemma
tuned
laugh
pants
guess
duets
dough
dusty
freak
query
digit
cater
pinch
pixel
mites
folds
notch
sorts
poppy
jelly
mimic
pleas
hound
mates
jolly
slain
jihad
faded
bland
tires
vines
grays
eaves
excel
ether
sails
slots
crisp
skins
guilt
logos
purge
imply
knoll
vodka
barns
tense
regal
fuzzy
cigar
ankle
manly
safer
exits
belts
helix
fined
disks
funky
react
stole
cores
renew
promo
syrup
zebra
motel
glove
reply
guise
proxy
tired
wrath
spoon
chefs
alder
forte
coded
broom
towed
gills
laden
molar
plume
hooks
groom
jeans
jumps
pious
slims
verbs
truce
foxes
fonts
packs
lipid
casts
hails
crypt
folly
acorn
domes
gotta
shout
sinus
feral
cairn
ascot
grief
solos
wrist
nexus
largo
patsy
dizzy
doses
cakes
filly
mixer
sheer
tweed
stain
gully
lupus
geese
penis
decks
slash
diner
weigh
flyer
fetal
palsy
verve
arson
snoop
sheen
crows
couch
scuba
linen
bower
mania
beads
cider
slugs
kayak
gnome
aegis
moons
byway
macro
stray
flock
brink
scent
reuse
traps
lymph
combo
gears
pasta
agile
admit
toxin
serum
cheek
bests
bitch
combs
edict
sacks
windy
shoal
brier
token
ozone
axiom
helms
neath
canto
dusky
fines
rouse
padre
mummy
sewer
ducal
hydra
magma
clues
razor
socks
posse
bight
taped
libel
azure
tiers
pests
awake
slice
waist
zonal
bingo
mares
spree
curly
plank
ropes
chill
anion
raped
grist
boxed
bites
lemur
cilia
hangs
spicy
taxis
polka
fries
knees
pence
relic
nymph
swarm
bulge
poses
bugle
silly
hoard
amend
sheds
fills
nasty
weeds
leech
bulbs
verge
folio
auger
gulch
taboo
joker
stalk
assay
slick
sable
stump
brood
dandy
siren
vegan
dives
sonar
razed
blows
erode
franc
crawl
tonic
waits
steer
skirt
fetus
nouns
edits
popes
horde
latex
avian
tonal
melon
eager
madam
cooks
claws
idiom
worry
puppy
tents
masts
timed
bowel
pivot
quake
ought
steak
cadre
bless
borer
sired
quail
modal
queue
nylon
clams
shack
stove
fares
skeet
modem
handy
fable
scare
fiery
salty
lilac
aloha
jacks
ebony
mover
brace
ovens
swain
beryl
stats
dales
aloud
cured
beaux
axial
ample
jumbo
scars
farce
dummy
axles
hauls
hertz
greed
spawn
align
ledge
glide
spoof
senna
ramps
toast
noisy
hitch
feces
scary
plaid
props
lager
bytes
fells
tarot
boron
ethos
twigs
flush
havoc
bongo
swine
piety
aroma
stall
heist
pains
shams
meats
hides
tinge
cleft
cloak
reeds
quark
fared
flaws
hunts
vases
witty
mogul
saber
gimme
temps
bully
cared
cheer
misty
sects
aisle
irons
silky
elves
hurts
husky
bumps
flair
wiped
hinds
slack
tolls
hanks
grind
abyss
biker
waged
hales
pause
idiot
pease
cupid
stair
scion
bushy
flare
quill
clamp
lisle
llano
stave
thong
domed
deans
torso
nomad
gated
bolts
kinks
cults
reset
basso
cares
grail
nanny
harem
midge
rents
brawl
yucca
jetty
mains
hints
bleak
chino
dames
naive
glens
snipe
stork
trios
ethic
piles
chute
squat
foray
leafy
eater
showy
broth
pouch
irony
lends
drier
finer
pores
lupin
cheat
crank
uncut
folks
butts
abode
pills
rowed
troll
juicy
gulls
fugue
mufti
phish
hated
vents
stead
swell
strap
polio
dykes
vigil
lofty
bowed
scoop
unify
curie
risky
pears
slabs
torus
doves
bored
epics
tramp
tawny
riffs
feats
skunk
rajah
thigh
busby
needy
highs
visas
bebop
herds
dwell
lefty
owlet
busts
adept
prank
lotto
weave
shook
sagas
manic
mambo
spins
liars
spore
divas
bleed
diode
blond
evoke
hyper
beige
lobed
wares
hears
moods
altos
flick
braid
amour
exert
bends
peril
sober
slime
cubes
swear
semen
elegy
satin
anvil
roast
sushi
carts
nadir
grime
amity
spade
gamer
grasp
deter
unfit
enact
cords
toads
booty
relax
sully
squaw
leaks
hulls
agony
harps
babel
haiku
totem
hippo
decor
reels
calyx
remit
dowry
hoops
druid
craze
creep
boney
nicks
debit
ovary
diets
robes
salvo
sooty
inert
snare
sheaf
agave
slums
cysts
fleck
kilns
furry
cough
waved
equip
kites
rarer
stags
menus
dogma
cries
lawns
wicks
grids
slips
wraps
refit
brine
glaze
sages
muses
dread
levee
pumas
kiosk
zoned
haunt
decoy
waned
pinky
buggy
comma
graft
aline
reins
fuses
lamas
mules
munch
overt
femur
matte
ochre
gloss
timer
stool
gourd
babes
crags
valet
whorl
wafer
sills
pesos
vowed
pikes
expel
sneak
choke
scalp
typed
ducts
earns
blink
gravy
emits
coils
sheik
roost
scans
lathe
flake
glade
harms
soups
hurry
rehab
cacti
rumor
lambs
ravel
silos
hoods
fates
pulls
aphid
bonny
maids
gurus
hinge
quilt
hutch
pussy
sitar
conch
evade
necks
racks
skits
gulag
jails
cacao
repay
scull
jazzy
stink
sinks
plugs
liege
lorry
clump
patio
flack
apron
cried
slept
proms
rowdy
gaunt
molds
lured
sepia
sixes
budge
volts
slump
awful
moles
hires
phlox
mamma
limbo
tibia
stomp
guyed
scaly
flaps
shank
porno
chunk
miter
rumba
denim
macho
larch
slant
dries
snuff
sloth
calif
emcee
sling
cocks
galls
fudge
winch
bales
melts
mucus
swore
cages
tiled
ovoid
prawn
ulcer
freer
medic
oxbow
zeros
laity
facet
adder
mower
liter
cures
downy
aorta
wager
eerie
hoist
sever
icing
fetch
daffy
serer
caper
oboes
gabby
soles
soaps
drank
pylon
lucid
limes
manna
slams
edema
abide
bribe
mauve
clasp
speck
grips
tamer
lofts
dikes
sieve
crumb
vigor
infer
vixen
hates
kinda
scarf
utter
coups
reedy
repel
ticks
tuner
goofy
tithe
gipsy
plumb
feuds
deuce
imams
brute
xenon
taxed
lapse
briar
warty
datum
nacho
pecan
pixie
wakes
talon
bassi
bangs
ounce
nudes
smock
nodal
vibes
tuber
mints
foggy
widen
askew
stoic
carpi
dimer
aides
shave
flume
petal
fluke
bogie
oaths
omits
agate
bulky
angst
rigor
evils
boast
koala
topaz
obese
seams
brunt
avail
boggy
abuts
thugs
ruddy
foyer
drown
tasty
sibyl
fades
punks
quays
filth
rupee
groin
gowns
heaps
guano
yarns
amigo
spoil
argon
plush
weary
capes
knobs
tiara
fixes
crick
login
carve
sauna
fecal
undue
axons
sucks
ghoul
cabal
quirk
swaps
suede
manse
novae
tweet
fryer
juror
thyme
beset
elfin
mores
greet
bards
hasty
yanks
alibi
credo
canes
quell
krone
rerun
anode
tonne
erase
barks
dicks
duels
warns
shunt
octet
tread
knack
taker
taper
runes
radii
dryer
brash
clove
satyr
wacky
rapes
tunic
foals
boles
looms
lowly
mossy
plead
rimes
lasso
conic
hikes
comer
revel
scone
pansy
trike
nutty
phyla
writs
tubby
await
oddly
studs
graze
umbel
pubic
gamut
sadly
quasi
muted
fords
rafts
strut
cramp
slits
smelt
smear
abate
glued
beret
papas
louse
whore
bogus
dicky
urges
aptly
nines
warts
dingo
psych
trill
snows
guava
tenet
flask
epoxy
llama
spiel
shush
bruin
adorn
batty
leper
vices
swung
serfs
condo
crate
aural
hover
fiefs
riser
donut
hares
salve
pawns
desks
fiend
sager
glyph
vireo
chime
hotly
grebe
vests
girth
tilde
messy
olden
deems
trope
fives
rinks
fists
licks
prong
cools
ricks
bathe
kebab
khans
aloft
navel
coven
radon
hives
nerds
haste
abort
geeks
fakir
ketch
mommy
wiles
greys
stent
scant
toner
ragas
swath
towel
felon
whips
ameer
divan
binge
dwelt
mated
wilds
puffy
peony
aunts
pipit
halts
dials
torts
piggy
flyby
pupal
booms
fleas
macaw
gusts
vying
shawl
grunt
smuts
rooks
terns
davit
toots
quack
eased
beets
skiff
rebus
blimp
copse
lingo
laced
ember
leaps
bimbo
scams
goody
steed
recap
caddy
noddy
atria
dared
inked
panes
vetch
quits
hyena
servo
hacks
savvy
kinky
floss
anise
smack
eider
sumac
piped
heros
caged
frail
swims
bigot
joule
fumes
novas
coves
wimpy
buoys
hoary
mamas
gorse
plums
doyen
booby
paced
honed
snaps
brisk
blush
gales
inept
conga
gloom
crass
dumps
skips
carat
egret
crone
voids
dally
glare
leans
noses
tacit
perks
capon
frees
punts
timid
cynic
jerky
grabs
seeps
prays
shone
twine
khaki
cress
avert
memes
slows
swank
shaky
fling
mocha
incur
sissy
weirs
itchy
bogey
fixer
newts
sassy
taffy
lures
faked
guppy
wilts
chats
inlay
tusks
clots
awash
germs
spook
dares
naves
suave
clack
frets
tabby
spout
bumpy
suing
lutes
eject
fangs
jello
stilt
flirt
colic
flees
grout
parse
cumin
bagel
borax
antes
spate
shalt
fiord
naiad
piled
horny
sleek
longs
spasm
chops
batik
silks
covey
bilge
embed
sires
dazed
bores
myrrh
latte
wield
curls
buffs
plump
frisk
tease
preys
inset
cribs
dells
vomit
colas
dudes
hooch
debug
blocs
galas
stoop
xylem
stung
mists
gumbo
bling
grits
leaky
pupae
lumps
amass
agape
weedy
latch
payer
moron
boars
toned
chewy
burro
noose
booze
labia
scorn
diced
trays
loamy
hoses
frond
civet
chasm
leash
bough
raged
cusps
rivet
cling
flips
forgo
ovals
tacos
halos
saver
coals
tulle
dimes
specs
holed
twang
vulva
puffs
cotes
visor
ruble
fouls
junco
whist
joked
brews
putty
oases
swirl
adieu
mumps
affix
balsa
voles
stile
moped
spars
wrens
slimy
humus
recur
yummy
jerks
wiser
adore
larks
stash
trice
froze
gruff
vamps
gusto
mazes
paces
bevel
memos
veils
shove
shard
beaks
slush
gusty
odors
sores
hippy
miler
easel
clout
ripen
crave
polyp
amuse
doped
howdy
wikis
bosom
cuffs
brawn
hefty
omens
rummy
keyed
chaff
loner
emirs
flier
tapir
pimps
harts
churn
pares
defer
clank
wader
igloo
quart
madly
plied
mourn
stale
droop
sylph
tromp
gnats
manes
wrest
plies
rosin
foams
flaky
attar
nigga
stews
offal
murky
erupt
grate
balmy
moats
debar
comas
vivas
shins
foils
rinse
bawdy
mesas
minis
gongs
miser
keels
rabid
wands
bossy
lapel
tsars
pique
doggy
henna
skied
ditto
jeeps
kiwis
casks
spool
recta
phony
wiper
tongs
mired
usurp
whelk
rajas
dines
wooly
shred
hiker
waxes
baggy
homie
barbs
slats
autos
reals
laces
treks
maven
tunas
rifts
saree
wheal
tamed
gummy
delve
tripe
adage
pluck
semis
skids
lumpy
swish
cased
seedy
karat
trawl
creel
gauze
curio
heals
jaded
emoji
vales
dingy
pigmy
huger
flung
waive
crier
rakes
lurid
minty
hoagy
cocky
piton
boils
godly
yeahs
dryad
telex
copra
carom
nappy
prick
parka
mealy
fakes
dirge
thine
evict
chimp
pokey
shorn
kudos
heady
pints
evens
dyers
kneel
brats
kilos
celli
mocks
aquae
flops
tykes
raked
sprat
enema
boner
dorms
idyll
hymen
waxed
fluff
dowse
banal
pewee
raves
momma
bract
scrip
gores
spits
jawed
mulch
slurs
mirth
umber
pokes
spank
booed
spiky
deism
idler
afoul
pelts
finis
wadis
swipe
campy
dinky
pager
antic
nifty
tomes
spied
prune
tardy
toddy
natty
biddy
quads
mails
knave
whirl
ensue
terse
growl
endow
pours
pacts
detox
shirk
dowdy
carps
roped
usury
hiked
gazer
dirks
swoop
gouge
taint
frock
raspy
djinn
augur
coots
sighs
scamp
vanes
harpy
asses
mires
rants
chaps
aloof
guile
snafu
dacha
strum
peels
segue
froth
coons
leapt
blobs
veers
tints
posit
corny
swash
becks
sisal
giddy
saris
saucy
sniff
furze
potty
flail
loons
chirp
sleds
dived
ewers
tarry
tilts
yolks
drags
cocci
belay
clogs
hater
scour
unwed
liens
tangy
obeys
pulps
kudzu
canny
thump
apses
pared
milch
wroth
leeks
bylaw
drape
decal
riven
bleep
blurb
ditty
mince
tempi
dilly
nears
joust
humps
singe
bolas
sodas
zippy
crock
mikes
ashen
knell
fated
wends
malts
winks
gaits
lusty
seers
gaudy
taunt
cubed
panty
ladle
copes
musky
afire
trims
pooch
crimp
dregs
nerdy
sepal
swoon
craps
curds
spurt
tepee
tenon
amaze
frill
dined
kazoo
shuts
satay
wreak
furor
faker
perky
poise
weeps
dimly
schwa
stubs
dents
amble
curvy
husks
tipsy
glows
pinks
tansy
awoke
meres
nosed
wipes
sleet
spoor
peppy
gents
poppa
burka
crept
meaty
heave
elude
outed
kooks
tubas
echos
splat
aches
oiled
mange
chums
deers
tweak
viols
dicta
warms
soapy
tacks
pasty
caret
micra
baits
sewed
corms
pasts
skein
fasts
filet
tress
blurs
enrol
tunny
ogres
crepe
fuzes
chore
ducat
welds
taser
duvet
poser
genii
yodel
slung
tacky
egged
stabs
grubs
pales
plows
tines
reams
rheum
toque
drips
sprig
scoot
legit
spats
burly
extol
pithy
chock
newel
gruel
safes
atone
hokey
odder
lanky
sofas
elope
paean
spilt
dawns
feint
zombi
twill
minim
whisk
clink
whims
chink
avast
sower
wispy
grads
gavel
brigs
whizz
silts
duped
tepid
throb
poked
claps
fishy
shahs
dicey
goons
hulks
spunk
waifs
meted
hyped
bares
rawer
yogis
quire
clung
faxes
tarts
annul
soupy
tings
prowl
tryst
trite
ocher
pudgy
antis
foots
halve
lurch
loony
dotty
mavin
reeks
oldie
foamy
splay
jocks
argot
bunks
boobs
gizmo
nicer
beady
thins
banes
gleam
amply
roams
corns
surly
inbox
dears
waver
mucky
hunch
smite
fizzy
woken
ingot
eases
wrack
oaken
teeny
groan
felts
lunge
clang
roars
lyres
afoot
clews
strep
acrid
hanky
kiddy
czars
marts
droll
amirs
hobos
exude
chews
swabs
gazes
glitz
opals
dunks
ruder
peeps
geode
dowel
payee
curbs
moldy
shuck
quash
sizer
chump
whack
shill
allot
vials
fount
colds
veldt
livid
hewer
totes
croci
cubit
melds
pesky
erred
tempt
matzo
gulfs
purer
octal
apter
annoy
blest
glues
chafe
tummy
dooms
infix
glean
wimps
preen
hoots
maces
pored
lurks
stirs
rages
brays
aeons
soggy
logon
nabob
aloes
lauds
shags
nacre
aspic
kapok
saxes
jiffy
barer
yells
ardor
touts
golly
delis
croon
whoop
staid
hokum
whine
nudge
lousy
gayer
mimes
snags
whats
runny
torte
floes
osier
bails
spake
troth
cluck
irate
rices
avers
sluts
lemme
futon
retry
zilch
frier
coped
vexed
bergs
hexes
sowed
chars
udder
gonad
kilts
rusts
quips
rungs
corks
doles
truer
lamer
dodos
whiff
beeps
gyros
gutsy
opine
plait
bakes
rebut
reran
blued
pinup
moans
balks
sappy
sward
haves
snide
clefs
pecks
feted
slays
begat
sawed
voile
filmy
techs
loopy
hooky
mimed
geeky
junky
mitts
snort
daunt
chomp
kiddo
quoit
mosey
milks
edger
crony
venal
nonce
outdo
treed
odium
soars
axing
uvula
alums
gored
synch
vapid
knits
untie
ivies
spuds
oaten
gripe
fetid
scram
brows
warps
loots
rinds
riper
twirl
catty
bused
niter
jaunt
idles
bicep
wolfs
feign
moire
aerie
liken
mends
swill
dumpy
caved
minks
sinew
snobs
joist
wench
boned
puree
amiss
tills
bloat
pilaf
boons
coops
nooks
saith
eyrie
slaps
lodes
exalt
scald
cleat
wacko
glint
stoat
oozes
nukes
gaffe
profs
upped
hussy
finks
spurn
pangs
grimy
tiros
caped
fagot
dusts
bluer
riles
liras
preps
roomy
dhoti
ovule
zooms
caulk
napes
pries
botch
shyer
mutes
ennui
drawl
yoked
junks
gooey
trots
putts
croak
shims
burrs
mutts
pucks
croup
gages
wooed
briny
pails
chive
fests
tinny
homey
chins
bared
mynah
taupe
blurt
sames
scabs
loins
gapes
sours
allay
muffs
mowed
teats
biped
artsy
shrug
halon
musty
paves
knelt
berms
brims
klutz
lefts
cozen
surer
harks
matts
gaily
bents
betas
teals
deeps
wryly
sulky
wordy
doers
paged
howls
shied
leers
jumpy
comfy
tyros
nulls
loges
thaws
cinch
rubes
covet
plunk
cheep
strop
fussy
dross
beget
hilts
frown
slags
prods
dings
rares
bidet
squab
yokes
hazes
hunks
impel
fowls
idled
fucks
abeam
cored
jades
balds
kaput
jambs
twerk
dunce
rears
bunts
nobly
lamed
lucre
baize
ritzy
thrum
julep
swags
stank
oared
prude
hocks
imbue
waked
belch
toyed
hakes
sneer
apace
nosey
dopey
robed
uteri
pates
gofer
mushy
moots
jehad
lithe
dados
fiver
ruffs
kooky
baser
snips
ruses
farts
hoofs
dunno
gamin
goner
ratty
dupes
poled
beefy
slosh
gilts
drams
welts
adzes
tucks
creak
sough
peeks
muter
banns
frack
loath
flues
ebbed
fifes
blots
winos
wades
decry
gunny
snarl
getup
wince
frays
tames
yearn
begot
buxom
sorta
nites
thees
chary
bosun
syncs
yokel
savor
drool
dosed
motes
newsy
liven
aback
mousy
auras
astir
shoon
abaci
lifer
whelp
laxer
douse
crape
picky
raved
gassy
shits
typos
fumed
smote
limos
fiats
blips
teems
lucks
gnash
saner
execs
aglow
licit
slink
tangs
hubby
hived
jabot
waded
soaks
fawns
calms
wring
hovel
poesy
sherd
cunts
amuck
cokes
inane
obits
hones
pleat
sidle
scats
maxed
mynas
gazed
finny
damps
tipis
roods
slyly
fiche
clime
nippy
toils
sways
fores
abler
ploys
tarps
jests
pulpy
pings
rheas
surfs
paled
spacy
flunk
gluey
dills
peals
rumps
reaps
rearm
pushy
nervy
chits
aught
wisps
papaw
clods
turfs
mangy
calve
addle
baled
scads
wacks
pyres
sooth
faxed
haler
staph
boozy
scold
sumps
snuck
metes
poach
tutus
wails
conks
laths
vacua
wombs
leery
gouty
bayed
mused
aquas
lames
rangy
hulas
runts
riled
homed
piked
belie
gamey
cowls
vouch
brags
ogles
leggy
tatty
snore
yogin
diked
jolts
prows
abaft
woozy
caned
codas
skews
bongs
fauns
cuter
dully
ameba
pekoe
cruet
cabby
dices
podia
irked
routs
culls
scows
clunk
wormy
skims
mooch
grope
lades
shads
wanes
lisps
biers
palmy
cuing
eking
cedes
jinni
jinns
tokes
helot
hexed
sudsy
goofs
wowed
piker
globs
lusts
umiak
emote
fondu
sunup
molts
scoff
jeers
brads
miaow
bolls
hosed
togas
quoth
keens
abhor
parch
hooey
fuzed
baste
snaky
muggy
testy
gasps
churl
upend
coeds
cooky
besom
blare
beefs
scowl
snoot
kopek
edify
ruing
whirr
smirk
scuds
tubed
hewed
huffy
flied
exult
nixed
rowel
rills
lulls
girts
coyer
shuns
sexed
redid
sicks
dweeb
spews
arced
jowls
scurf
neigh
slake
carbs
hazed
oakum
mauls
dryly
flout
waxen
peons
undid
jibes
oozed
yawls
cagey
elide
dorks
biked
dopes
flits
hurls
grins
caked
frizz
peeve
gauzy
middy
cushy
rimed
adman
lairs
pwned
vises
vends
skulk
styli
scuff
unzip
twits
balms
toady
doily
sifts
stuns
bozos
foxed
tizzy
shyly
thous
doled
slier
dungs
phial
souse
demur
roved
abets
sates
fulls
tares
cavil
cants
tikes
unsay
rusks
swats
clued
pined
razes
wrung
wefts
doted
iambs
cower
funks
boors
gaffs
snubs
jells
teary
broil
gnaws
sated
louts
unset
gooks
shies
emend
cowed
orate
scrod
chide
foist
romps
yawns
dulls
knead
slunk
quids
deify
ninny
clits
bauds
aping
burgs
divot
drays
waken
dorky
unman
yelps
fazed
bulks
golfs
retch
rasps
wanly
riced
chapt
dotes
nuked
spams
roans
whiny
coyly
goads
musts
ulnae
bided
bungs
kneed
burps
ikons
curer
flubs
spume
wafts
awing
purrs
nixes
fogey
softy
turds
hared
thymi
gilds
meows
gluts
tamps
gloat
bodes
stows
pilau
seamy
kabob
heeds
frump
wises
lubes
gamed
mussy
liker
gismo
molls
skimp
slops
japed
bawls
narcs
honks
sties
filch
bulgy
twerp
mulls
scums
aurae
sirup
weans
strew
sloes
miked
boded
ailed
garbs
troys
damns
yuppy
pried
wrapt
viand
gulps
soled
dogie
eying
haled
styes
noels
zincs
gimpy
thuds
tiffs
purls
abuzz
penes
nuder
mopes
divvy
miens
viler
shoed
bleat
appal
loafs
dozed
gelid
trues
fends
jilts
chows
fitly
chugs
ogled
milfs
idyls
nimbi
decaf
maced
luaus
drily
poops
beaus
doffs
indue
bated
perms
anted
prate
gushy
waled
slurp
yucky
admen
hypes
plods
pones
tzars
stunk
sulks
abash
jives
offed
weals
weepy
inure
befit
jibed
limed
taros
huffs
noway
hafts
ousts
cutup
deign
snugs
lazes
coked
acing
clops
mucks
prigs
hying
basks
wined
pouts
fazes
avows
pyxes
iotas
trued
maxes
roves
balky
vizor
numbs
kebob
drabs
flays
vaunt
throe
yeses
gawky
elate
limns
poxes
plops
dolts
kited
curst
whams
altho
weest
gayly
shoos
rends
lowed
anons
bides
rifer
qualm
abase
pocks
teaks
gibes
woofs
achoo
daubs
gnarl
zebus
inapt
japes
calks
wooer
quaff
craws
pupas
vasts
frats
puked
tared
spays
pricy
soppy
lards
yawed
lilts
kicky
pawed
okays
darns
tuxes
prosy
palls
crams
slobs
glads
slily
hayed
brusk
togae
payed
umped
tumid
torsi
agism
limps
flogs
laxly
hided
lolls
yacks
morns
vexes
vapes
gybed
ashed
unpin
pukes
icily
ached
oinks
toffy
outgo
shtik
orals
mooed
vised
roils
slews
toted
