From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Aug  6 17:06:01 2004
Subject: [Ocfs2-devel] 
	[patch] fix bug 53--- Disk usage status reported in "df" is
	incorrect
Message-ID: <3ACA40606221794F80A5670F0AF15F8405167BD3@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is bug for 2.6 kernel.

------------------------------------------------------------------------
--------------------
Index: super.c
===================================================================
--- super.c     (revision 1331)
+++ super.c     (working copy)
@@ -757,6 +757,8 @@
                            reserved_bits);
        buf->f_bfree =
            (sector_t) (freebits * (osb->s_clustersize >>
osb->sb->s_blocksize_bits));
+
+       buf->f_bavail = buf->f_bfree;
        buf->f_files = (sector_t) (numbits);
        buf->f_ffree = (sector_t) (numbits) - freebits;
 #endif
-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-26740

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
