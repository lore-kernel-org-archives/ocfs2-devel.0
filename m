From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon Mar 29 03:29:55 2004
Subject: [Ocfs2-devel] resend the new patch for bug 48 to remove incorrect
	autowrap in last mail
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4B@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wim,

	You can help me to forward the patch to RedHat/Suse. I think the patch =
can be applied to all 2.6.x kernels.=20

	If you can't find the last one, I can attach it again.

------------------------------------------
--- linux-2.6.4a/fs/jbd/journal.c	2004-03-19 10:40:49.264613984 +0800
+++ linux-2.6.4/fs/jbd/journal.c	2004-03-19 10:41:12.091143824 +0800
@@ -832,10 +832,10 @@
 		bh =3D __getblk(journal->j_dev, blocknr, journal->j_blocksize);
 		lock_buffer(bh);
 		memset (bh->b_data, 0, journal->j_blocksize);
-		BUFFER_TRACE(bh, "marking dirty");
-		mark_buffer_dirty(bh);
 		BUFFER_TRACE(bh, "marking uptodate");
 		set_buffer_uptodate(bh);
+		BUFFER_TRACE(bh, "marking dirty");
+		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		__brelse(bh);
 	}


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: wim.coekaerts@oracle.com [mailto:wim.coekaerts@oracle.com]=20
Sent: 2004=C4=EA3=D4=C229=C8=D5 11:47
To: Zhang, Sonic
Cc: joel.becker@oracle.com; ocfs2-devel
Subject: Re: [Ocfs2-devel] resend the new patch for bug 48 to remove =
incorrect autowrap in last mail


Sonic,

that bug you found in jbd, is that soemthing you forwarded on to
rhat/suse or do you want us to do that ? if you have generic kernel
fixes I want to make sure we get them fixed upstream

wim
