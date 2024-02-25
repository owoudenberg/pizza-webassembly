CC = clang
CXX = clang++

%.o: %.c
	$(CC) -c $< -o $@ 

%.o: %.cpp
	$(CXX) -c $< -o $@

clean:
	rm -f *.o 