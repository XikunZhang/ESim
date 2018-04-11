#!/bin/bash

# node_file="dblp_data/node.dat"
# link_file="dblp_data/link.dat"
# path_file="dblp_data/path.dat"
# output_file="results/vec.dat"

# node_file="uspatent_link/node.dat"
# link_file="uspatent_link/link.dat"
# path_file="uspatent_link/path.dat"
# output_file="results/vec4_link_uspatent_multi.dat"

if [ ${node_file} == "dblp_data/node.dat" ] && [ ! -e dblp_data/node.dat ]; then
    echo ${green}===Downloading DBLP Dataset===${reset}
    curl http://dmserv2.cs.illinois.edu/data/data_dblp.tar.gz --output data_dblp.tar.gz
    tar -xvf data_dblp.tar.gz
    mv data_dblp dblp_data
fi

# make clean
# make
# mkdir -p results

size=50 # embedding dimension
negative=5 # number of negative samples
samples=1 # number of path instances (Million) for training at each iteration
iters=500 # number of iterations
threads=20 # number of threads for training


for DATASET in $@
do
	case $DATASET in
		yelp)
			node_file="../yelp_data/node.dat"
			link_file="../yelp_data/link.dat"
			path_file="../yelp_data/path.dat"
			output_file="results/yelp_embedding.dat"
		;;
		imdb)
			node_file="../imdb_data/IMDBLens-by-time/node.dat"
			link_file="../imdb_data/IMDBLens-by-time/link.dat"
			path_file="../imdb_data/IMDBLens-by-time/path.dat"
			output_file="results/imdb_embedding.dat"
		;;
		dblp)
			node_file="../dblp_data/node.dat"
			link_file="../dblp_data/link.dat"
			path_file="../dblp_data/path.dat"
			output_file="results/dblp_embedding.dat"
		;;
	esac

	SECONDS=0

	./bin/esim -model 2 -alpha 0.025 -node ${node_file} -link ${link_file}  -path ${path_file} -output ${output_file} -binary 1 -size ${size} -negative ${negative} -samples ${samples} -iters ${iters} -threads ${threads}

	./search.sh $output_file

	DURATION=$SECONDS
	echo "$DATASET takes $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds."

done
