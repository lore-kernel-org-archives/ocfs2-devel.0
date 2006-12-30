From: Tiger Yang <tiger.yang@oracle.com>
Date: Sat Dec 30 01:04:28 2006
Subject: [Ocfs2-devel] FWD: ocfs2 panic when o2cb offline
Message-ID: <45962B94.8090002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hi, All,

FYI.

thanks,
tiger

Subject:
ocfs2 panic when o2cb offline
From:
"haobo.zhou" <haobo.zhou@oracle.com>
Date:
Sat, 30 Dec 2006 16:25:36 +0800

To:
linux_support_ww@oracle.com


All,

/etc/init.d/o2cb offline will cause a panic, if there is mounted ocfs2 
filesystem.
Sipingal found it and I reproduced in my vmware environment.  My env is

[root@node2 ~]# uname -a
Linux node2.cn.oracle.com 2.6.9-42.ELsmp #1 SMP Wed Jul 12 23:27:17 EDT 
2006 i686 i686 i386 GNU/Linux
[root@node2 ~]# rpm -qa | grep ocfs2
ocfs2-tools-1.2.2-1
ocfs2console-1.2.2-1
ocfs2-2.6.9-42.ELsmp-1.2.3-1
[root@node2 ~]#



The workaround is as follows:

--- /etc/init.d/o2cb.old        2006-12-30 23:25:27.000000000 -0500
+++ /etc/init.d/o2cb    2006-12-30 23:17:05.000000000 -0500
@@ -714,6 +714,7 @@
    then
        echo "Failed"
        echo "Unable to stop cluster as heartbeat region still active" >&2
+       exit 1
    fi

    if [ $FORCE -eq 1 ]
