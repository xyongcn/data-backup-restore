# data-backup-restore
Application data backup and restore for openthos
各脚本功能描述如下：
１、autosh.sh脚本中调用了mountgetsh.sh和treesh.sh，用于生成旧版和新版的目录树文件（.txt格式）和它们之间的差异文件（.patch格式）
２、mountgetsh.sh用于挂载安卓镜像文件
３、treesh.sh用于生成目录树文件（.txt格式）
４、mergesh.sh用于合并生成的patch文件中的同名目录
５、summary.sh用于去掉patch文件中没有修饰符（eg:! + -）的目录，生成精简的patch文件
６、backupsh.sh进行微信聊天信息的备份
７、recoversh.sh进行微信聊天信息的恢复

注:以上脚本须在root权限下执行
