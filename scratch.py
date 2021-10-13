
import hydra
import logging
import os
import torch
import wandb

from omegaconf import DictConfig, OmegaConf

log = logging.getLogger(__name__)


def set_device(cuda : bool):
    device = "cpu"
    if cuda:
        if torch.cuda.is_available():
            device = "cuda"
        else:
            log.info("no gpu found, defaulting to cpu")
    device = torch.device(device)


def train(flags : DictConfig):
    pass


def valid(flags : DictConfig):
    pass


def main(flags : DictConfig):
    set_device(flags.cuda)
    

# use hydra for config / savings outputs
@hydra.main(config_path=".", config_name="config")
def setup(flags : DictConfig):
    if os.path.exists("config.yaml"):
        # this lets us requeue runs without worrying if we changed our local config since then
        logging.info("loading pre-existing configuration, we're continuing a previous run")
        new_flags = OmegaConf.load("config.yaml")
        cli_conf = OmegaConf.from_cli()
        # however, you can override parameters from the cli still
        # this is useful e.g. if you did total_epochs=N before and want to increase it
        flags = OmegaConf.merge(new_flags, cli_conf)

    # log config + save it to local directory
    log.info(OmegaConf.to_yaml(flags))
    OmegaConf.save(flags, "config.yaml")

    if flags.wandb:
        wandb.init(project=flags.wbproject, entity=flags.wbentity, group=flags.group, config=flags)
    
    main(flags)


if __name__ == "__main__":
    setup()