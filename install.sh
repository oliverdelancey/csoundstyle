set -e
install_path="/usr/local/bin"
echo "-----> Compiling csoundstyle.nim"
nim c -d:release csoundstyle.nim
echo "-----> Installing csoundstyle to $install_path"
sudo cp csoundstyle "$install_path"
echo "-----> Installation complete."