From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 08 Oct 2010 15:40:59 -0700
Subject: [Ocfs2-devel] Fwd:  O2CB global heartbeat - hopefully final drop!
Message-ID: <4CAF9DFB.2040905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

git://oss.oracle.com/git/smushran/linux-2.6.git  globalheartbeat

All the patches are available in the above git repo.

Sunil

-------- Original Message --------
Subject: 	[Ocfs2-devel] O2CB global heartbeat - hopefully final drop!
Date: 	Thu, 7 Oct 2010 17:15:14 -0700
From: 	Sunil Mushran <sunil.mushran@oracle.com>
To: 	ocfs2-devel at oss.oracle.com



All,

This is hopefully the final drop of the patches for adding global heartbeat
to the o2cb stack.

The diff from the previous set is here:
http://oss.oracle.com/~smushran/global-hb-diff-2010-10-07

Implemented most of the suggestions provided by Joel and Wengang.
The most important one was to activate the feature only at the end,

Also, got mostly a clean run with checkpatch.pl.

Sunil

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101008/03bfd928/attachment.html 
