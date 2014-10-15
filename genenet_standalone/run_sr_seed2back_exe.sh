#!/bin/sh
# script for execution of deployed applications
#
# Sets up the MCR environment for the current $ARCH and executes 
# the specified command.
#
exe_name=$0
exe_dir=`dirname "$0"`

if [ "$1" = "--help" ]; then

echo -e "--------------------------------\n\nDESCRIPTION\n\nSeed to backbone connectivity analysis using seed randomisation. Shell script to run standalone executable file.\n\n\nUSAGE\n\nTo run the shell script type:\n\n./run_sr_seed2back_exe.sh <mcr_directory> <argument_list>\n\nat Linux command prompt.\n\n<mcr_directory> is the directory where version 8.2 of MCR is installed or the directory where MATLAB is installed on the machine. <argument_list> is the following list of arguments:\n\nntwk_edgelist_file ntwk_header seed_file s_header bb_file bb_header s_bb_comb rands parallelise quickview_flag basic_results_file [ --results_dir results_dir --results_tag results_tag ] [ --node_attribute_file node_attribute_file --node_attribute_indices node_attribute_indices [ --node_attribute_bins node_attribute_bins ] ]\n"

echo -e "\nINPUT\n"
echo -e "               ntwk_edgelist_file = Full or relative path to text file containing the network of interest, represented as a list of edges (Two columns, tab/ space-delimited).\n" 
echo -e "               ntwk_header = Boolean (true, false, 1 or 0) flag to indicate whether or not to remove a header-line in ntwk_edgelist_file.\n" 
echo -e "               seed_file = Full or relative path to text file containing the seeds to analyse (one column).\n"
echo -e "               s_header = Boolean (true, false, 1 or 0) flag to indicate whether or not to remove a header-line in seed_file.\n" 
echo -e "               bb_file = Full or relative path to text file containing the backbone-nodes (one column).\n"
echo -e "               bb_header = Boolean (true, false, 1 or 0) flag to indicate whether or not to remove a header-line in bb_file.\n"
echo -e "               s_bb_comb = (integer with value 1, 2 or 3) 1 = treat joint seed/backbone as backbone; 2 = treat joint seed/backbone as seeds; 3 = treat joint seed/backbone as neither."  
echo -e "               rands = Number of permutations to perform.\n"
echo -e "               parallelise = Boolean (true, false, 1 or 0) flag to indicate whether or not to use multiple processors for parallel permutations.\n"
echo -e "               quickview_flag = Boolean (true, false, 1 or 0) flag to indicate whether or not to plot a 'quickview' of the direct network among seeds.\n"
echo -e "               basic_results_file = Full or relative path to output file for basic results generated by np_seed_exe.\n"

echo -e "\nOPTIONS\n"
echo "          --results_dir results_dir"
echo -e "                  resulta_dir = Full or relative path to directory where results are to be stored.\n"
echo "          --results_tag results_tag" 
echo -e "                  results_tag = Tag with which to prefix all results files for this analysis.\n\n"

echo "          --node_attribute_file node_attribute_file"
echo -e "                  node_attribute_file = Full or relative path to text file containing node attributes to account for. The data should be stored as a table where rows are attributes and columns are nodes. The first row of the file must contain the node names, and the first column of the file must contain attribute names. The first element of the table (first row, first column) must be left blank. See user manual for further details.\n"
echo "          --node_attribute_indices node_attribute_indices" 
echo -e "                  node_attribute_indices = Comma-delimited list of integers within square brackets (e.g. [1,2,3]). The integers are row indices into the table stored in node_attribute_file (indexing starts from 1), corresponding to the attributes to account for.\n"
echo "          --node_attribute_bins node_attribute_bins"
echo "                  node_attribute_bins = Comma-delimited list of integers within square brackets (e.g. [2,2,4]). The integers are the number of groups (or bins) to be used for each attribute. Must be the same length as node_attribute_indices. If this is not supplied, then a suggested 'best' number of groups for each attribute is calculated."

echo -e "\n\nOUTPUT (written to basic_results_file as a list (each output on a new line), in the following order:)\n"
echo "          Total number of seeds and backbone-nodes in the direct network among seeds and backbone-nodes."
echo "          Total number of backbone nodes in the direct network among seeds and backbone-nodes."
echo "          Observed total number of edges in the direct network among seeds and backbone-nodes."
echo "          Expected total number of edges in the direct network among seed and backbone-nodes."
echo "          P-value for the total number of edges in the direct network among seed and backbone-nodes."
echo "          Total number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes."
echo "          Expected number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes. (Calculated as the mean observed over all permuted networks)."
echo "          Total number of seeds connected to one or more backbone-nodes in the direct network among seeds and backbone-nodes."
echo "          Total number of backbone-nodes connected to one or more seeds in the direct network among seeds and backbone-nodes."
echo "          Empirical P-value for the observed number of edges connecting seeds to backbone-nodes in the direct network among seeds and backbone-nodes."

echo -e "\n\nADDITIONAL OUTPUT\n"
echo -e "If you provide a results_dir and a results_tag, the following files will also be generated:\n"

echo "          results_dir/results_tag.LOG"
echo "          results_dir/results_tag.SEED_BB_PRESENT (List of seeds and backbone-nodes present in the network of interest, provided in ntwk_edgelist_file.)"
echo "          results_dir/results_tag.SEEDS_CONNECTED_TO_BACKBONE (List of seeds connected to backbone-nodes in the direct network among seeds and backbone-nodes.)"
echo "          results_dir/results_tag.DIRECT_CONNECTIONS (Tab delimited text file listing the edges in the direct network among seeds and backbone-nodes.)"
echo "          results_dir/results_tag.CONTEXT_CONNECTIONS (Tab delimited text file listing the edges in the context network. The context network is comprised of all nodes connected to a seed or backbone-node (including seeds and backbone-nodes), and all the edges among this set of nodes.)"
echo "          results_dir/results_tag.SUMMARY (Pretty printed basic results.)"
echo "          results_dir/results_tag.NET_STATS (Pretty printed basic results.)"

echo -e "\n\nSEE ALSO: run_sr_seed_exe.sh run_sr_seed_bg_exe.sh run_sr_seed2back_bg_exe.sh\nrun_np_seed_exe.sh run_np_seed_bg_exe.sh run_np_seed2back_exe.sh run_np_seed2back_bg_exe.sh\n"

echo -e "\nBy: Avigail Taylor  --  (July 2014)\n"
echo "**************************************************************************"
echo -e "This file is distributed as part of GeneNet Toolbox.\nCopyright (C) 2014  Avigail Taylor.\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License\nas published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty\nof MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.\n\nYou can contact the author at avigail.taylor@dpag.ox.ac.uk"
echo "%**************************************************************************"

exit
fi

echo "------------------------------------------"
if [ "x$1" = "x" ]; then
  echo Usage:
  echo    $0 \<deployedMCRroot\> args
else
  echo Setting up environment variables
  MCRROOT="$1"
  echo ---
  LD_LIBRARY_PATH=.:${MCRROOT}/runtime/glnxa64 ;
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64 ;
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64;
  XAPPLRESDIR=${MCRROOT}/X11/app-defaults ;
  export XAPPLRESDIR;
  export LD_LIBRARY_PATH;
  echo LD_LIBRARY_PATH is ${LD_LIBRARY_PATH};
  shift 1
  args=
  while [ $# -gt 0 ]; do
      token=$1
      args="${args} \"${token}\"" 
      shift
  done
  eval "\"${exe_dir}/sr_seed2back_exe\"" $args
fi
exit

