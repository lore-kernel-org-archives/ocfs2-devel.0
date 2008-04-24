From: Corey Minyard <minyard@acm.org>
Date: Thu, 24 Apr 2008 15:37:26 -0000
Subject: [Ocfs2-devel] fs/ocfs2/alloc.c too big
Message-ID: <4810A918.4080705@acm.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When compiling fs/ocfs2/alloc.c for a MIPS platform, the size of the 
section became too large for the jump using in MIPS atomics to reach the 
places it needs to go.  I've split up alloc.c into three files (tree.c 
and truncate.c) to fix it for now where I'm working.

I'm curious if this has already been done.  It could be argued that the 
MIPS code needs to be fixed to handle the size, but that would slow down 
the atomics and I think >6000 lines is probably too big, anyway.  I'm 
willing to split it up in the current code base, if the maintainers are 
willing to accept the change.

Thanks,

-corey
