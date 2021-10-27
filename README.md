# Setup

You'll need to install Cisco AnyConnect and then connect to the VPN.

Set up VSCode from https://code.visualstudio.com/Download.
Install the remote extension and then connect to the hpc cluster using vscode to remotely edit files after you have ssh set up.


Make sure you can connect to the cluster (then log back out).
```
ssh {netid}@greene.hpc.nyu.edu
```

Copy your ssh id so you don't need to login with your password all the time.
```
ssh-copy-id {netid}@greene.hpc.nyu.edu
```

Now log back in. Should work without needing a password.

From the cluster, clone this repo and copy over the bashrc if you don't have one that you like.
```
git clone https://github.com/alexholdenmiller/nyu_cluster.git
cp ~/nyu_cluster/bashrc ~/.bashrc
```

I recommend using tmux.
```
echo "set mouse -g on" > ~/.tmux.conf
tmux
```
When you reconnect to the server after timing out / etc, just run `tmux a`.

Optionally set up a few basic helpers...
```
ln -s $SCRATCH ~/scratch

mkdir ~/bin && cd ~/bin

echo srun --nodes=1 --tasks-per-node=1 --cpus-per-task=1 --mem=4GB --time=0:30:00 --pty /bin/bash > get_cpu
echo srun --nodes=1 --tasks-per-node=1 --cpus-per-task=1 --mem=4GB --time=0:30:00 --gres=gpu:1 --pty /bin/bash > get_gpu
echo squeue -u $USER > sjobs
echo scancel -u $USER > stop

chmod +x *
```

Now, install a local miniconda on scratch.
```
ln -s $SCRATCH/python_cache/.cache
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p $SCRATCH/miniconda3
$SCRATCH/miniconda3/bin/conda init
```

Install pytorch.
```
conda install pytorch torchvision cudatoolkit=11.1 -c pytorch -c nvidia
```

Create a free account on wandb.ai, then install hydra & wandb.
Cloning hydra should be unnecessary soon - they needed to update their pip release with a bug fix.

```
pip install --upgrade wandb hydra-core hydra_colorlog hydra_submitit_launcher
git clone https://github.com/facebookresearch/hydra.git
git checkout 1.1_branch
cd hydra/plugins/hydra_submitit_launcher
pip install .
wandb login     # if this fails due to a locked file in /tmp/, use get_cpu to get a basic cpu machine and run it again
```

# Test

First, try running the program locally:
```
python scratch.py
```

Then, try to launch it on a GPU server by adding the `-m` flag (for `--multirun`).
```
python scratch.py -m
```

# Tips

Use `myquota` command to check your storage usage.

# TBD: skip this for now, need to figure out singularity

Now we will set up a local filesystem for running jobs to minimize impact on the cluster filesystem. This will take a while.
```
cp /scratch/work/public/overlay-fs-ext3/overlay-50G-10M.ext3.gz $SCRATCH/
gunzip -v $SCRATCH/overlay-50G-10M.ext3.gz
```

Then, install miniconda again into singularity*after* logging into a dev machine.
```
srun --nodes=1 --tasks-per-node=1 --cpus-per-task=1 --mem=32GB --time=1:00:00 --gres=gpu:1 --pty /bin/bash
singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:rw /scratch/work/public/singularity/cuda11.1.1-cudnn8-devel-ubuntu20.04.sif /bin/bash
ln -s $SCRATCH/python_cache/.cache
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
/ext3/miniconda3/bin/conda activate
```

setup read vs read-write
```
echo singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:rw /scratch/work/public/singularity/cuda11.1.1-cudnn8-devel-ubuntu20.04.sif /bin/bash > ~/bin/singrw
echo singularity exec --nv --overlay $SCRATCH/overlay-50G-10M.ext3:ro /scratch/work/public/singularity/cuda11.1.1-cudnn8-devel-ubuntu20.04.sif /bin/bash > ~/bin/singro
chmod +x ~/bin/*

singro
```
