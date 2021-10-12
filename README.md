# Setup

This section installs et and uses it to connect to the HPC cluster.
You'll need to install Cisco AnyConnect and then connect to the VPN.

Make sure the following works:
```
ssh {netid}@greene.hpc.nyu.edu
```

Copy a proper .bashrc file to the cluster (included one in this directory).
```
scp bashrc {netid}@greene.hpc.nyu.edu:~/.bashrc
```

Then, on the cluster, run tmux.
```
echo "set mouse -g on" > ~/.tmux.conf
tmux
```
When you reconnect to the server after timing out / etc, just run `tmux a`.

Now we will set up a local filesystem for running jobs to minimize impact on the cluster filesystem. This will take a while.
```
cp /scratch/work/public/overlay-fs-ext3/overlay-50G-10M.ext3.gz $SCRATCH/
gunzip -v $SCRATCH/overlay-50G-10M.ext3.gz
```

Then, install miniconda *after* logging into a dev machine.
```
srun --nodes=1 --tasks-per-node=1 --cpus-per-task=1 --mem=32GB --time=1:00:00 --gres=gpu:1 --pty /bin/bash
singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:rw /scratch/work/public/singularity/cuda11.1.1-cudnn8-devel-ubuntu20.04.sif /bin/bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
ln -s $SCRATCH/python_cache/.cache
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
/ext3/miniconda3/bin/conda init
```

Install pytorch.
```
conda install pytorch torchvision torchaudio cudatoolkit=11.1 -c pytorch -c nvidia
```

Create a free account on wandb.ai

```
pip install --upgrade wandb hydra-core hydra-submitit-launcher
wandb login
```

# not raedy

singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:ro /scratch/work/public/singularity/cuda11.1.1-cudnn8-devel-ubuntu20.04.sif /bin/bash
module load cuda/11.1.74 

# Test

First, try running the program locally:
```
python scratch.py
```

Then, try to launch it on a GPU server by adding the `-m` flag (for `--multirun`).
```
python scratch.py -m name=1
```