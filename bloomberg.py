total = 0

def paths(x, y, z):
	global total

#	print("x: " + str(x) + ", y: " + str(y) + ", z: " + str(z))
	size = 3

	if(x < size):
		paths(x + 1, y, z)
	if(y < size):
		paths(x, y + 1, z)
	if(z < size):
		paths(x, y, z + 1)
	if(x == size and y == size and z == size):
		total = total + 1

	return total

total = 0
print paths(0, 0, 0)
