extends Sprite

"""

Thank you Yas Meteora for seeing the problems with the original code where
the code would not move left when max speed to the right was maxed out.
Also, issue with if checks on accelerationOnX() & accelerationOnY() not 
working when moving to the left or up.

Code better reflects getting the code to work.

Quesiton to ask yourself when looking at the code:
'Do we need an if statement on accelerationOnX() & accelerationOnY() methods
when their is a method called clampSpeed() that "clamps" the speed values within a range?'

"""

var gameWidth: int = OS.get_window_size().x
var gameHeight: int = OS.get_window_size().y
var spriteWidth: int = get_texture().get_width()
var spriteHeight: int = get_texture().get_height()
var halfSpriteHeight: int = spriteHeight / 2
var halfSpriteWidth: int = spriteWidth / 2

var speedOnXAxis: float = 0.0
var speedOnYAxis: float = 0.0
export var maxSpeed: float = 1000.0
export var acceleration: float = 300.0

# Limits
var lowerLimit: int = gameHeight #+ halfSpriteHeight
var upperLimit: int = 0 #+ halfSpriteHeight
var leftLimit: int = 0 #+ halfSpriteWidth
var rightLimit: int = gameWidth #+ halfSpriteWidth

func _enter_tree():
	positionMiddle()

# Issue: it does not have those fancy input chain stoppers
# Solution: Pause the object when needed
func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_D):
		moveRight(delta)
	if Input.is_key_pressed(KEY_A):
		moveLeft(delta)
	if Input.is_key_pressed(KEY_W):
		moveUp(delta)
	if Input.is_key_pressed(KEY_S):
		moveDown(delta)
	
	moveHero(delta)
	clampSpeed()
	wrapAroundCheck()

func wrapAroundCheck()->void:
	if position.y > lowerLimit:
		position.y = 0
	if position.y < upperLimit:
		position.y = gameHeight
	if position.x > rightLimit:
		position.x = 0
	if position.x < leftLimit:
		position.x = gameWidth

func moveRight(delta: float) -> void:
	accelerationOnX(delta)

func moveLeft(delta: float) -> void:
	accelerationOnX(-delta)

func moveUp(delta: float) -> void:
	accelerationOnY(-delta)

func moveDown(delta: float) -> void:
	accelerationOnY(delta)

# added abs() method, abs() keeps positive numbers positive, and turns negative numbers positive
# Yas Meteora pointed out that their was no abs() method!
func accelerationOnX(delta: float) -> void:
	if abs(speedOnXAxis) <= maxSpeed:
		speedOnXAxis += acceleration * delta

# added abs() method, abs() keeps positive numbers positive, and turns negative numbers positive
# Yas Meteora pointed out that their was no abs() method!
func accelerationOnY(delta: float) -> void:
	if abs(speedOnYAxis) <= maxSpeed:
		speedOnYAxis += acceleration * delta

func moveHero(delta: float)->void:
	position.x += speedOnXAxis * delta
	position.y += speedOnYAxis * delta



func positionMiddle() -> void:
	self.position.x = gameWidth / 2
	self.position.y = gameHeight / 2


#issue with float going above maxSpeed or below -maxSpeed by one hundred-thousandth (0.00001)
func clampSpeed() -> void:
	# you can use the clamp method to keep a value within a range
	# speedOnXAxis = clamp(speedOnXAxis, -maxSpeed, maxSpeed)
	# speedOnYAxis = clamp(speedOnYAxis, -maxSpeed, maxSpeed)
	
	# check X speed
	if speedOnXAxis > maxSpeed:
		speedOnXAxis = maxSpeed
	if speedOnXAxis < -maxSpeed:
		speedOnXAxis = -maxSpeed
	
	# check Y speed
	if speedOnYAxis > maxSpeed:
		speedOnYAxis = maxSpeed
	if speedOnYAxis < -maxSpeed:
		speedOnYAxis = -maxSpeed
