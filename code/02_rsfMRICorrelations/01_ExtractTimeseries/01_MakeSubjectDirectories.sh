for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do
	echo $subj
	mkdir /scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}
done
