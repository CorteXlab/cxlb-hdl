ADPROOT=/opt/Nutaq/ADP6/ADP_MicroTCA/sdk/bin/
DIRNAME=$(dirname $0)
${ADPROOT}/adp_cli.py ${DIRNAME}/radio420s_playback.txt
