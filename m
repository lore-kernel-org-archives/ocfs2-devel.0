From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:57:56 +0200
Subject: [Ocfs2-devel] Quota locking fixes for OCFS2
Message-ID: <1273780683-3638-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


This patch series fixes several issues I've found in OCFS2 quota code when I
looked at lockdep warning Joel reported in
http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg05269.html

Currently ocfs2 with quotas survives fsstress and fsx runs without oopsing
and the first lockdep warning I get is
http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03188.html
which is somewhere deep in DLM code and I don't have a clue how to fix it.

The patch set is on top of:
  git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6 for_next

Since it really depends on some of the cleanups I have there we have to
somehow resolve how to merge it. Either I can do it after getting your
acks or if you wish to wait with the changes until after the merge window,
I can merge all the generic quota bits and ocfs2 patches can be pulled
into ocfs2 tree after that.

								Honza
