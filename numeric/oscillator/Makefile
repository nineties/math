anime.mp4: 
	ruby spring_v.rb > oscillator.dat
	ruby plot.rb | gnuplot
	ffmpeg -r 10 -i anime-%04d.png anime.mp4
	rm -rf *.png
