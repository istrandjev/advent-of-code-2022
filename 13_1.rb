# your code goes here

def compare(a, b)
	if a.kind_of?(Integer) and b.kind_of?(Integer)
		x = b <=> a
		if x == -1
			return 2
		end
		return x
	end
	if a.kind_of?(Integer)
		return compare([a], b)
	end
	if b.kind_of?(Integer)
		return compare(a, [b])
	end
	(0...[a.size, b.size].min).each do |i|
		x = compare(a[i], b[i])
		if x != 0
			return x
		end
	end
	return compare(a.size, b.size)
end

index = 1
res = 0
while as = gets
	a = eval(as)
	b = eval(gets())
	gets()
	if compare(a, b) == 1
		res += index
	end
	index += 1
end
puts res

