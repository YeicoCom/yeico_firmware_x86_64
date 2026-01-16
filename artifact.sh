#!/bin/bash

SELF=$(realpath $0)

mix deps.get
mix nerves.artifact
ls -l yeico_firmware*.tar.gz
mv yeico_firmware*.tar.gz ~/.nerves/dl
ls -l ~/.nerves/dl/yeico_firmware*.tar.gz
