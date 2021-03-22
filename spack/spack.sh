cd ${HOME}
git clone https://github.com/spack/spack.git
cd spack
git checkout -b spack-latest # create a new branch
git pull origin releases/latest # pull the latest release
echo '. ${HOME}/spack/share/spack/setup-env.sh' >> ~/.bashrc # setup Spack
