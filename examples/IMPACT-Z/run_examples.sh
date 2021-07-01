#!/bin/bash
cd ../../
. run_env.sh
cd -

timestamp() {
  date +"%Y-%m-%d_%H-%M-%S" # current time
}

if [[ $ModuleEnv == *"openmpi"* ]]; then

  cd $GPTUNEROOT/examples/IMPACT-Z
  rm -rf gptune.db/*.json # do not load any database 
  tp=IMPACT-Z
  app_json=$(echo "{\"tuning_problem_name\":\"$tp\"")
  echo "$app_json$machine_json$software_json$loadable_machine_json$loadable_software_json}" | jq '.' > .gptune/meta.json
  $MPIRUN --oversubscribe --allow-run-as-root --mca btl self,tcp,vader --mca pmix_server_max_wait 3600 --mca pmix_base_exchange_timeout 3600 --mca orte_abort_timeout 3600 --mca plm_rsh_no_tree_spawn true -n 1  python ./impact-z_single.py -ntask 1 -nrun 100 -optimization GPTune 
  
fi
