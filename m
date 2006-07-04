From: boka <boka@piekna.pl>
Date: Tue, 4 Jul 2006 19:55:48 +0200 (CEST)
Subject: [Ocfs2-devel] ocfs2-tools-1.2.0-1 compile error
Message-ID: <12802.83.31.18.200.1152035748.squirrel@webmail.piekna.pl>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

i want to install ocfs2-tools-1.2.0-1 on slackware 10.2 (up-to-date) with
2.6.17.2 kernel and i got error:

./configure
checking build system type... i686-pc-linux-gnu
checking host system type... i686-pc-linux-gnu
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables...
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ANSI C... none needed
checking how to run the C preprocessor... gcc -E
checking for a BSD-compatible install... /usr/bin/ginstall -c
checking whether ln -s works... yes
checking for ranlib... ranlib
checking for ar... /usr/bin/ar
checking for egrep... grep -E
checking for ANSI C header files... yes
checking for an ANSI C-conforming const... yes
checking for debugging... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for pkg-config... /usr/bin/pkg-config
checking for com_err... yes
checking COM_ERR_CFLAGS... -I/include
checking COM_ERR_LIBS... -L/lib -lcom_err
checking for uuid_unparse in -luuid... yes
checking uuid/uuid.h usability... yes
checking uuid/uuid.h presence... yes
checking for uuid/uuid.h... yes
checking for debug executables... no
checking whether to build fsck dynamically... no
checking whether to build cluster control tools dynamically... no
checking for pkg-config... (cached) /usr/bin/pkg-config
checking for GLIB - version >= 2.2.3... yes (version 2.6.6)
checking for readline in -lreadline... yes
checking readline/readline.h usability... yes
checking readline/readline.h presence... yes
checking for readline/readline.h... yes
checking for a Python interpreter with version >= 2.3... python
checking for python... /usr/bin/python
checking for python version... 2.4
checking for python platform... linux2
checking for python script directory... ${prefix}/lib/python2.4/site-packages
checking for python extension module directory...
${exec_prefix}/lib/python2.4/site-packages
checking for headers required to compile python extensions... found
configure: WARNING: could not find PyGTK, ocfs2console will not be built
configure: creating ./config.status
config.status: creating Config.make
config.status: creating debugfs.ocfs2/debugfs.ocfs2.8
config.status: creating mkfs.ocfs2/mkfs.ocfs2.8
config.status: creating mounted.ocfs2/mounted.ocfs2.8
config.status: creating fsck.ocfs2/fsck.ocfs2.8
config.status: creating fsck.ocfs2/fsck.ocfs2.checks.8
config.status: creating o2cb_ctl/o2cb_ctl.8
config.status: creating ocfs2_hb_ctl/ocfs2_hb_ctl.8
config.status: creating ocfs2cdsl/ocfs2cdsl.8
config.status: creating ocfs2console/ocfs2console.8
config.status: creating tunefs.ocfs2/tunefs.ocfs2.8
config.status: creating vendor/common/ocfs2-tools.spec
root at node1:~/ocfs2/ocfs2-tools-1.2.1# make
make -C libo2dlm
make[1]: Entering directory `/root/ocfs2/ocfs2-tools-1.2.1/libo2dlm'
compile_et o2dlm_err.et
make[1]: compile_et: Command not found
make[1]: *** [o2dlm_err.h] Error 127
make[1]: Leaving directory `/root/ocfs2/ocfs2-tools-1.2.1/libo2dlm'
make: *** [libo2dlm] Error 2

Any idea ?

-- 
best regrads
Daniel
