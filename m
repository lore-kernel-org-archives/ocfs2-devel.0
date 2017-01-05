From: Eric Ren <zren@suse.com>
Date: Thu,  5 Jan 2017 23:31:00 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] fix deadlock caused by recursive cluster
	locking
Message-ID: <1483630262-22227-1-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, jiangqi903@gmail.com, zren@suse.com, linux-kernel@vger.kernel.org

This is a formal patch set to solve the deadlock issue on which I
previously started a RFC (draft patch), and the discussion happened here:
[https://oss.oracle.com/pipermail/ocfs2-devel/2016-October/012455.html]

Compared to the previous draft patch, this one is much simple and neat. 
It neither messes up the dlmglue core, nor has a performance penalty on
the whole cluster locking system. Instead, it is only used in places where
such recursive cluster locking may happen.

Your comments and feedbacks are always welcomed.

Eric Ren (2):
  ocfs2/dlmglue: prepare tracking logic to avoid recursive cluster lock
  ocfs2: fix deadlocks when taking inode lock at vfs entry points

 fs/ocfs2/acl.c     | 39 ++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/dlmglue.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h | 18 ++++++++++++++++++
 fs/ocfs2/file.c    | 44 ++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/ocfs2.h   |  1 +
 5 files changed, 131 insertions(+), 18 deletions(-)

-- 
2.6.6
