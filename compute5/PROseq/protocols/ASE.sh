#MOLGENIS walltime=23:59:00 mem=8gb ppn=1

### variables to help adding to database (have to use weave)
#string project
###
#string stage
#string checkStage

#string WORKDIR
#string projectDir
#string dbsnpVcf
#string dbsnpVcfIdx

#string tabixVersion
#string samtoolsVersion
#string haplotyperDir
#string AseDir
#string ASFiles
#string AseOutput
#string ASReadsDir
#string couplingFile
#list ASReads
echo "## "$(date)" Start $0"


#Load gatk module
${checkStage}

mkdir -p ${AseDir}

printf '%s\n' "${ASReads[@]}" > ${ASFiles}

if java -jar /groups/umcg-wijmenga/tmp04/umcg-ndeklein/scripts/cellTypeSpecificAlleleSpecificExpression-1.0.3_niekRequest-jar-with-dependencies.jar \
--action 2 \
--output ${AseOutput} \
--as_locations ${ASFiles} \
--minimum_hets 1 \
--minimum_reads 10

then
 echo "returncode: $?";
 echo "succes moving files";
else
 echo "returncode: $?";
 echo "fail";
fi

echo "## "$(date)" ##  $0 Done "I
