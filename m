From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Mon Jan 26 16:12:00 2004
Subject: [Ocfs2-devel] Problems building OCFS2
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A6178023@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I noticed that OCFS2 got updated in the last few days.

I just tried to do a build and got this:
[root@linuxjohn2 trunk]# make
make -C src
make[1]: Entering directory `/root/ocfs2/trunk/src'
make[1]: *** No rule to make target `inc/io.h', needed by `alloc.c'.
Stop.
make[1]: Leaving directory `/root/ocfs2/trunk/src'
make: *** [src] Error 2
[root@linuxjohn2 trunk]#

I can not find the io.h file that the Makefile specifies.

Thanks,
John
