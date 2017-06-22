## mass-spring-sim
Mass spring simulation for processing

# Structure File Syntax

	garvity gravitry-Value(should be a negative)

	springDampeningConst dampening-Value (should be a negative)

	viscousDampeningConst dampening-Value 

	ballRadius radius-Value

	To create a MassBall 
		MassBall starting-X-position starting-Y-Position is-Pinned(1-Yes, 0-No)

	To create a Spring
		Spring spring-Constant rest-length phase magnitude massBall-index massBall-index (massBall indices are in the order you added them)