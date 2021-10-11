# Setup

This section installs et and uses it to connect to the HPC cluster.
You'll need to install Cisco AnyConnect and then connect to the VPN.

Make sure the following works:
```
ssh {netid}@greene.hpc.nyu.edu
```

Copy a proper .bashrc file to the cluster (included one in this directory).
```
ssh bashrc {netid}@greene.hpc.nyu.edu:~/.bashrc
```

Then, on the cluster, install miniconda.
```
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
bash Miniconda3-py39_4.10.3-Linux-x86_64.sh
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


# Test

First, try running the program locally:
```
python scratch.py
```

Then, try to launch it on a GPU server by adding the `-m` flag (for `--multirun`).
```
python scratch.py -m name=1
```