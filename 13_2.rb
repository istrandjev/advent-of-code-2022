def compare(a, b)
	if a.kind_of?(Integer) and b.kind_of?(Integer)
		return a<=> b
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

l = [[[2]], [[6]]]
while as = gets
	a = eval(as)
	b = eval(gets())
	gets()
	l << a
	l << b
end
l.sort!{|x, y| compare(x, y)}
puts (l.find_index([[2]]) + 1) * (l.find_index([[6]]) +1)

