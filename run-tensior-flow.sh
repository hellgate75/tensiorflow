#!/bin/bash

echo "Running TensorFlow™ container ..."

if ! [[ -e /dev/nvidia0  ]]; then
  if [[ -e /dev/nvidia-uvm  ]]; then
    ln -s /dev/nvidia-uvm /dev/nvidia0
  else
    echo "No Nvidia Card present, please try to run container with nvidia-docker ..."
  fi
fi

if ! [[ -z "$TARGZ_ROOT_SSH_KEYS_URL" ]]; then
  if ! [[ -e /root/root_sshkeys_installed ]]; then
    echo "Downloading gzipped ROOT ssh keys from : \"$TARGZ_ROOT_SSH_KEYS_URL\" ...."
    curl -L $TARGZ_ROOT_SSH_KEYS_URL -O /root/my-root-ssh-keys.tgz
    if [[ "0" != "$?" ]] && [[ -e /root/my-root-ssh-keys.tgz ]]; then
      echo "Something went wrong accessing file from : \"s$TARGZ_ROOT_SSH_KEYS_URL\" ...."
    else
      echo "Extracting gzipped ROOT ssh keys into folder : /root/.ssh ...."
      mkdir -p /root/.ssh
      tar -C /root/.ssh xzf /root/my-root-ssh-keys.tgz
      if [[ "0" != "$?" ]]; then
        echo "Something went wrong extracting ROOT ssh keys from : \"$TARGZ_ROOT_SSH_KEYS_URL\" ...."
      else
        echo "Extracted ROOT ssh keys into folder :  /root/.ssh ...."
        touch /root/root_sshkeys_installed
      fi
      rm -f /root/my-root-ssh-keys.tgz
    fi
  fi
else
  if ! [[ -e /root/root_sshkeys_installed ]]; then
    sudo su - root bash -c "echo -e \"\\ny\\n\" | ssh-keygen -t rsa -N \"\""
    touch /root/root_sshkeys_installed
  fi
fi

if [[ -e /root/.ssh ]] && [[ -e /root/.ssh/id_rsa.pub ]]; then
  echo -e "Root public key:\n$(cat /root/.ssh/id_rsa.pub)\n"
fi

if ! [[ -z "$TARGZ_USER_SSH_KEYS_URL" ]]; then
  if ! [[ -e /root/user_sshkeys_installed ]]; then
    echo "Downloading gzipped $NB_USER ssh keys from : \"$TARGZ_USER_SSH_KEYS_URL\" ...."
    curl -L $TARGZ_USER_SSH_KEYS_URL -O /root/my-user-ssh-keys.tgz
    if [[ "0" != "$?" ]] && [[ -e /root/my-user-ssh-keys.tgz ]]; then
      echo "Something went wrong accessing file from : \"s$TARGZ_USER_SSH_KEYS_URL\" ...."
    else
      echo "Extracting gzipped $NB_USER ssh keys into folder : /home/$NB_USER/.ssh ...."
      mkdir -p /home/$NB_USER/.ssh
      tar -C /home/$NB_USER/.ssh xzf /root/my-user-ssh-keys.tgz
      if [[ "0" != "$?" ]]; then
        echo "Something went wrong extracting $NB_USER ssh keys from : \"$TARGZ_USER_SSH_KEYS_URL\" ...."
      else
        echo "Extracted $NB_USER ssh keys into folder :  /home/$NB_USER/.ssh ...."
        touch /root/user_sshkeys_installed
      fi
      rm -f /root/my-user-ssh-keys.tgz
    fi
  fi
else
  if ! [[ -e /root/user_sshkeys_installed ]]; then
    sudo su - $NB_USER bash -c "echo -e \"\\ny\\n\" | ssh-keygen -t rsa -N \"\""
    touch /root/user_sshkeys_installed
  fi
fi

if [[ -e /home/$NB_USER/.ssh ]] && [[ -e /home/$NB_USER/.ssh/id_rsa.pub ]]; then
  echo -e "$NB_USER public key:\n$(cat /home/$NB_USER/.ssh/id_rsa.pub)\n"
fi


if ! [[ -z "$TARGZ_SOURCE_URL" ]]; then
  if ! [[ -e /root/gzipsource_installed ]]; then
    echo "Downloading gzipped source from : \"$TARGZ_SOURCE_URL\" ...."
    curl -L $TARGZ_SOURCE_URL -O /root/my-source-code.tgz
    if [[ "0" != "$?" ]] && [[ -e /root/my-source-code.tgz ]]; then
      echo "Something went wrong accessing file from : \"$TARGZ_SOURCE_URL\" ...."
    else
      echo "Extracting gzipped source into folder : /root/tf-app ...."
      tar -C /root/tf-app xzf /root/my-source-code.tgz
      if [[ "0" != "$?" ]]; then
        echo "Something went wrong extracting source from : \"$TARGZ_SOURCE_URL\" ...."
      else
        echo "Extracted source into folder : /root/tf-app ...."
        touch /root/gzipsource_installed
      fi
      rm -f /root/my-source-code.tgz
    fi
  fi
fi

if ! [[ -z "$GIT_URL" ]]; then
  if ! [[ -e /root/gitsource_installed ]]; then
    if [[ -z "$GIT_BRANCH" ]]; then
      GIT_BRANCH="master"
    fi
    if ! [[ -z "$GIT_USER" ]]; then
      git config --global user.name "$GIT_USER"
    fi
    if ! [[ -z "$GIT_EMAIL" ]]; then
      git config --global user.email "$GIT_EMAIL"
    fi
    echo "Cloning Source Repository from : \"$GIT_URL\" ...."
    git clone --recursive $GIT_URL /root/tf-app
    if [[ "0" != "$?" ]] && [[ -e /root/my-source-code.tgz ]]; then
      echo "Something went wrong cloning Source Repository from from : \"$TARGZ_SOURCE_URL\" ...."
    else
      if [[ "master" != "$GIT_BRANCH" ]]; then
        echo "Switching to branch : $GIT_BRANCH ...."
        cd /root/tf-app
        git fetch
        git checkout "$GIT_BRANCH"
      fi
      echo "Source Repository clone complated ...."
      touch /root/gitsource_installed
    fi
  fi
fi

if ! [[ -z "$1" ]] && [[ "-bash" == "$1" ]]; then
  echo "Starting SSH daemon ..."
  service ssh start

  echo "Starting Jupyter Notebook ..."
  if [[ -z "$(netstat -anp | grep 8888)" ]]; then
    nohup bash -c "jupyter notebook --NotebookApp.token="$JUPYTHER_TOKEN" --allow-root /root/tf-app 1> $TENSORFLOW_LOG_FOLDER/notebook.log  2>&1" &
  fi

  echo "Starting TensorBoard™ ..."
  start-tensoboard

  if ! [[  -z "$2" ]]; then
    /bin/bash -c "${@:2}"
  fi
else
  echo "Starting SSH daemon ..."
  service ssh start
  # if ! [[ -e /root/go/src/$PACKAGE_NAME ]]; then
  #   ln -s /root/tf-app /root/go/src/$PACKAGE_NAME
  # fi

  if [[ "true" == "$AUTO_BUILD" ]]; then
    echo "Building and install Go Custom Package : $PACKAGE_NAME"
    echo "Building Argument : $BUILD_ARGUMENTS"
    echo "Repeat At Start-Up : $REPEAT_BUILD"
    echo ""
    echo ""
    if ! [[ -e /root/app_built ]]; then
      go install "$BUILD_ARGUMENTS" $PACKAGE_NAME
      if [[ "true" != "$REPEAT_BUILD" ]]; then
        touch /root/app_built
      fi
    fi
  fi

  echo "Starting Jupyter Notebook ..."
  if [[ -z "$(netstat -anp | grep 8888)" ]]; then
    nohup bash -c "jupyter notebook --NotebookApp.token="$JUPYTHER_TOKEN" --allow-root /root/tf-app 1> $TENSORFLOW_LOG_FOLDER/notebook.log  2>&1" &
  fi

  echo "Starting TensorBoard™ ..."
  start-tensoboard

  echo "Running TensiorFlow™ TensoBoard logs : "

  tail -f $TENSORFLOW_LOG_FOLDER/tensoboard.log
  tail -f /dev/null
fi
