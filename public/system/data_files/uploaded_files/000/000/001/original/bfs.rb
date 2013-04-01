arr = [[0,1,1,0,0,1],
	   [0,0,0,1,1,0],
	   [0,0,0,0,0,0],
	   [0,0,0,0,0,0],
	   [0,0,0,0,0,0],
	   [0,1,0,0,0,0]]
n = 6
i = 0

viz = []
stack = []

viz[i] = 0
stack << i
gasit = 0

while !stack.empty? do
  v = stack.pop
  (0..n - 1).each do |i|
	if viz[i].nil? && arr[v][i] == 1
	  stack << i
	  viz[i] = 1
	  print "#{i + 1} "
	end
  end
end



def dfs(arr, n, i)
  viz = []
  queue = []
  first = 0
  last = 0

  viz[i] = 1
  queue << i

  while first <= last do
    v = queue[first]
    (0..n - 1).each do |i|
      if viz[i].nil? && arr[v][i] == 1
	    last += 1
	    queue[last] = i
		viz[i] = 1
	  end
    end
    first += 1
  end
  queue
end