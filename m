From: Gang He <GHe@suse.com>
Date: Tue, 24 Dec 2019 04:55:03 +0000
Subject: [Ocfs2-devel] Cannot compile ocfs2 kernel module directory
Message-ID: <CH2PR18MB32065BA80B241E7B0B55429FCF290@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi List,

I cannot compile ocfs2 kernel module directory with the below command,
sles15sp2b1-nd2:/usr/src/linux/fs/ocfs2 # make -C /lib/modules/`uname -r`/build M=`pwd` modules
make: Entering directory '/usr/src/linux-5.3.13-1-obj/x86_64/default'
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/heartbeat.o
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/masklog.o
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/sys.o
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/nodemanager.o
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/quorum.o
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/tcp.o
  CC [M]  /usr/src/linux/fs/ocfs2/cluster/netdebug.o
  LD [M]  /usr/src/linux/fs/ocfs2/cluster/ocfs2_nodemanager.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmdomain.o
/usr/src/linux/fs/ocfs2/dlm/dlmdomain.c:23:10: fatal error: cluster/heartbeat.h: No such file or directory  #include "cluster/heartbeat.h"
          ^~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [/usr/src/linux-5.3.13-1/scripts/Makefile.build:282: /usr/src/linux/fs/ocfs2/dlm/dlmdomain.o] Error 1
make[2]: *** [/usr/src/linux-5.3.13-1/scripts/Makefile.build:498: /usr/src/linux/fs/ocfs2/dlm] Error 2
make[1]: *** [/usr/src/linux-5.3.13-1/Makefile:1641: _module_/usr/src/linux/fs/ocfs2] Error 2
make: *** [../../../linux-5.3.13-1/Makefile:179: sub-make] Error 2
make: Leaving directory '/usr/src/linux-5.3.13-1-obj/x86_64/default'

If I remove the kernel commit 9cc342f6c4a06ea613ddef1bcaa25409260aec63/ 9cc342f6c4a06ea613ddef1bcaa25409260aec63,
the above command can works again.
In the past, that command line is always OK.

Thanks
Gang
