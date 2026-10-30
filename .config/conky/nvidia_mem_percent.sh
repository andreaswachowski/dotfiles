#!/bin/bash
# Print NVIDIA GPU 0 VRAM usage as an integer percentage (for conky's execibar).
nvidia-smi --id=0 --query-gpu=memory.used,memory.total --format=csv,noheader,nounits |
	awk -F', ' '{ printf "%d\n", 100 * $1 / $2 }'
