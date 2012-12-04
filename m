From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Tue,  4 Dec 2012 11:15:46 +0800
Subject: [Ocfs2-devel] [PATCH] mkfs.ocfs2 null pointer dereference.
Message-ID: <1354590947-7762-1-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Reproduce steps as below:
1.minimal install OL5.8 x86_64
2.install 2.6.39-300.17.1.el5uek.bug14842737
3.cofigure ocfs2
[root at ca-ostest284 ~]# cat /etc/ocfs2/cluster.conf
cluster:
        node_count = 1
        name = ocfs2

node:
        ip_port = 7777
        ip_address = 139.185.50.68
        number = 1
        name = ca-ostest284.us.oracle.com
        cluster = ocfs2
4. run ocfs2 test suit single node test, and hit panic
[root at ca-ostest284 ~]# nohup ./single_run-WIP.sh -k ~/linux-kernel.tar.gz -m
/mnt/ocfs2 -l ~/ocfs2log -d /dev/sda3 &> sin_1119_1 &
5. reboot
6. run ocfs2 test suit disontig single node test, and hit panic again
[root at ca-ostest284 ~]# nohup time ./discontig_runner.sh -d /dev/sda3 -o
~/ocfs2log/ /mnt/ocfs2 &> dis_sin_1121 & 
