# For http://bugs.winehq.org/show_bug.cgi?id=30410
# A patch is included in the ppa, but if you build from source, you need this workaround for ubuntu 12.04 and up
echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope
