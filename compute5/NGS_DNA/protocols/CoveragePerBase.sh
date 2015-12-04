#MOLGENIS walltime=10:00:00 mem=12gb nodes=1 ppn=1

#Parameter mapping
#string gatkVersion
#string gatkJar
#string intermediateDir
#string dedupBam
#string project
#string sample
#string indexFile
#string capturedIntervalsPerBase
#string capturedBed
#string GCC_Analysis


sleep 5
module load ${gatkVersion}
module load ngs-utils

if [ "${GCC_Analysis}" == "diagnostiek" ] || [ "${GCC_Analysis}" == "diagnostics" ] || [ "${GCC_Analysis}" == "Diagnostiek" ] || [ "${GCC_Analysis}" == "Diagnostics" ]
then
	if [ -f ${capturedIntervalsPerBase} ]
	then
		java -Xmx10g -XX:ParallelGCThreads=4 -jar ${EBROOTGATK}/${gatkJar} \
		-R ${indexFile} \
		-T DepthOfCoverage \
		-o ${sample}.samtools.coveragePerBase \
		-I ${dedupBam} \
		-L ${capturedIntervalsPerBase}

		sed '1d' ${sample}.samtools.coveragePerBase > ${sample}.samtools.coveragePerBase_withoutHeader

		paste ${capturedIntervalsPerBase} ${sample}.samtools.coveragePerBase_withoutHeader > ${sample}.combined_bedfile_and_samtoolsoutput.txt

		echo -e "chr\tstart\tstop\tgene\tcoverage" > ${sample}.coveragePerBase.txt

		awk -v OFS='\t' '{print $1,$2,$3,$5,$7}' ${sample}.combined_bedfile_and_samtoolsoutput.txt >> ${sample}.coveragePerBase.txt

		python ${EBROOTNGSMINUTILS}/calculateCoveragePerGene.py --input ${sample}.coveragePerBase.txt --output ${sample}.coveragePerGene.txt.tmp

		sort ${sample}.coveragePerGene.txt.tmp > ${sample}.coveragePerGene.txt

	else
		echo "there is no capturedIntervalsPerBase: ${capturedIntervalsPerBase}, please run coverageperbase: (module load ngs-utils --> run coverage_per_base.sh)" 
	fi
else
	echo "CoveragePerBase skipped"

fi

