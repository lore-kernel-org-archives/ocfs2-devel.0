From: Gang He <GHe@suse.com>
Date: Wed, 25 Dec 2019 07:00:19 +0000
Subject: [Ocfs2-devel] Cannot compile ocfs2 kernel module directory
In-Reply-To: <2967264abe074c74be8e01f0a3fa04da@SOC-EX01V.e01.socionext.com>
References: <CH2PR18MB32065BA80B241E7B0B55429FCF290@CH2PR18MB3206.namprd18.prod.outlook.com>
	<2967264abe074c74be8e01f0a3fa04da@SOC-EX01V.e01.socionext.com>
Message-ID: <CH2PR18MB3206BAD26F3F4C6BD962426ECF280@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Yamada,

Thank for your reply,
I applied your patch, but still have some compile error.

sp2b1-nd1:/usr/src/linux/fs/ocfs2 # make -C /lib/modules/`uname -r`/build M=`pwd` modules
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
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmdebug.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmthread.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmrecovery.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmmaster.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmast.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmconvert.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmlock.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmunlock.o
  LD [M]  /usr/src/linux/fs/ocfs2/dlm/ocfs2_dlm.o
  CC [M]  /usr/src/linux/fs/ocfs2/dlmfs/userdlm.o
/usr/src/linux/fs/ocfs2/dlmfs/userdlm.c:24:10: fatal error: ocfs2_lockingver.h: No such file or directory
 #include "ocfs2_lockingver.h"
          ^~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [/usr/src/linux-5.3.13-1/scripts/Makefile.build:282: /usr/src/linux/fs/ocfs2/dlmfs/userdlm.o] Error 1
make[2]: *** [/usr/src/linux-5.3.13-1/scripts/Makefile.build:498: /usr/src/linux/fs/ocfs2/dlmfs] Error 2
make[1]: *** [/usr/src/linux-5.3.13-1/Makefile:1641: _module_/usr/src/linux/fs/ocfs2] Error 2
make: *** [/usr/src/linux-5.3.13-1/Makefile:179: sub-make] Error 2
make: Leaving directory '/usr/src/linux-5.3.13-1-obj/x86_64/default'


Thanks
Gang

> -----Original Message-----
> From: yamada.masahiro at socionext.com
> [mailto:yamada.masahiro at socionext.com]
> Sent: 2019?12?25? 11:46
> To: Gang He <GHe@suse.com>; ocfs2-devel at oss.oracle.com
> Cc: masahiroy at kernel.org
> Subject: RE: Cannot compile ocfs2 kernel module directory
> 
> Hi Gang,
> 
> I think the reason is Kbuild tries to search the headers under
> /lib/modules/`uname -r`/build.
> 
> I'd like to recommend to make header paths really relative if you want to keep
> your previous way for building this module.
> 
> I attached a patch.
> 
> Thanks.
> 
> 
> 
> -----Original Message-----
> From: Gang He <GHe@suse.com>
> Sent: Tuesday, December 24, 2019 1:55 PM
> To: ocfs2-devel at oss.oracle.com
> Cc: Yamada, Masahiro/?? ?? <yamada.masahiro@socionext.com>
> Subject: Cannot compile ocfs2 kernel module directory
> 
> Hi List,
> 
> I cannot compile ocfs2 kernel module directory with the below command,
> sles15sp2b1-nd2:/usr/src/linux/fs/ocfs2 # make -C /lib/modules/`uname
> -r`/build M=`pwd` modules
> make: Entering directory '/usr/src/linux-5.3.13-1-obj/x86_64/default'
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/heartbeat.o
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/masklog.o
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/sys.o
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/nodemanager.o
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/quorum.o
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/tcp.o
>   CC [M]  /usr/src/linux/fs/ocfs2/cluster/netdebug.o
>   LD [M]  /usr/src/linux/fs/ocfs2/cluster/ocfs2_nodemanager.o
>   CC [M]  /usr/src/linux/fs/ocfs2/dlm/dlmdomain.o
> /usr/src/linux/fs/ocfs2/dlm/dlmdomain.c:23:10: fatal error:
> cluster/heartbeat.h: No such file or directory  #include "cluster/heartbeat.h"
>           ^~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make[3]: *** [/usr/src/linux-5.3.13-1/scripts/Makefile.build:282:
> /usr/src/linux/fs/ocfs2/dlm/dlmdomain.o] Error 1
> make[2]: *** [/usr/src/linux-5.3.13-1/scripts/Makefile.build:498:
> /usr/src/linux/fs/ocfs2/dlm] Error 2
> make[1]: *** [/usr/src/linux-5.3.13-1/Makefile:1641:
> _module_/usr/src/linux/fs/ocfs2] Error 2
> make: *** [../../../linux-5.3.13-1/Makefile:179: sub-make] Error 2
> make: Leaving directory '/usr/src/linux-5.3.13-1-obj/x86_64/default'
> 
> If I remove the kernel commit
> 9cc342f6c4a06ea613ddef1bcaa25409260aec63/
> 9cc342f6c4a06ea613ddef1bcaa25409260aec63,
> the above command can works again.
> In the past, that command line is always OK.
> 
> Thanks
> Gang
