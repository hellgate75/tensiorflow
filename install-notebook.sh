#!/bin/bash
if ! [[ -e /root/.jupyter_installed  ]]; then
  echo "Install Jupyther pre-conditions ..."
  apt-get update && apt-get install -y fonts-liberation && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo "Install Tini" && \
  wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
  echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
  mv tini /usr/local/bin/tini && \
  chmod +x /usr/local/bin/tini


  useradd -m -d $NB_HOME -s /bin/bash -N -u $NB_UID $NB_USER -g users && \
  mkdir -p $CONDA_DIR && \
  chown $NB_USER $CONDA_DIR && \
  cat /tmp/bashrc-diff >> /home/$NB_USER/.bashrc && \
  rm -f /tmp/bashrc-diff && \
  echo "export UID=100" /home/$NB_USER/.bashrc && \
  chown -R $NB_USER:users /etc/jupyter/

  sudo su - $NB_USER

  sudo su - $NB_USER bash -c "echo -e \"\\n\" | ssh-keygen -t rsa -N \"\""
  sleep 10
  sudo su - $NB_USER bash -c "mkdir /home/$NB_USER/work"

  echo "Install conda as $NB_USER and check the md5 sum provided on the download site" && \
  cd /tmp && \
  wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
  echo "c1c15d3baba15bf50293ae963abef853 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
  /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
  rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
  $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
  $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
  $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
  $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
  $CONDA_DIR/bin/conda update --yes --all && \
  conda clean -tipsy
  echo "Install Jupyter Notebook and Hub"
  conda install --quiet --yes \
  'notebook=5.0.*' \
  'jupyterhub=0.7.*' \
  'jupyterlab=0.24.*' \
  'nomkl' \
  'ipywidgets=6.0*' \
  'pandas=0.19*' \
  'numexpr=2.6*' \
  'matplotlib=2.0*' \
  'scipy=0.19*' \
  'seaborn=0.7*' \
  'scikit-learn=0.18*' \
  'scikit-image=0.12*' \
  'sympy=1.0*' \
  'cython=0.25*' \
  'patsy=0.4*' \
  'statsmodels=0.8*' \
  'cloudpickle=0.2*' \
  'dill=0.2*' \
  'numba=0.31*' \
  'bokeh=0.12*' \
  'sqlalchemy=1.1*' \
  'hdf5=1.8.17' \
  'h5py=2.6*' \
  'vincent=0.4.*' \
  'beautifulsoup4=4.5.*' \
  'xlrd' \
  && conda clean -tipsy
  sudo su
  touch /root/.jupyter_installed
fi
