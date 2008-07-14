From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 14 Jul 2008 13:12:36 -0700
Subject: [Ocfs2-devel] OCFS2 1.4: Proposed fix for mount/recovery race
	(Attempt 4)
Message-ID: <1216066358-12090-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Two changes.

One was implementing Joel suggestion of moving bump and get recogens
into journal.c.

Second was concerning the recogen refresh on nodes that did not replay
the journal. We now refresh at the end of the recovery process just
before we release the EX on the superblock lock. Earlier we were
refreshing earlier which was adversely affecting the logic making it
do a blocking lock on a slot that was mounted.

Sunil
