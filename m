From: Eric Ren <zren@suse.com>
Date: Mon, 16 Jan 2017 14:42:18 +0800
Subject: [Ocfs2-devel] [PATCH v2 0/2] fix deadlock caused by recursive
	cluster locking
Message-ID: <20170116064220.23720-1-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, jiangqi903@gmail.com, sfr@canb.auug.org.au, hch@lst.de, linux-kernel@vger.kernel.org

This is a formal patch set v2 to solve the deadlock issue on which I
previously started a RFC (draft patch), and the discussion happened here:
[https://oss.oracle.com/pipermail/ocfs2-devel/2016-October/012455.html]

Compared to the previous draft patch, this one is much simple and neat.
It neither messes up the dlmglue core, nor has a performance penalty on
the whole cluster locking system. Instead, it is only used in places where
such recursive cluster locking may happen.
 
Changes since v1: 
1. Let ocfs2_is_locked_by_me() just return true/false to indicate if the
process gets the cluster lock - suggested by: Joseph Qi <jiangqi903@gmail.com>
and Junxiao Bi <junxiao.bi@oracle.com>.
 
2. Change "struct ocfs2_holder" to a more meaningful name "ocfs2_lock_holder",
suggested by: Junxiao Bi <junxiao.bi@oracle.com>.
 
3. Add debugging output at ocfs2_setattr() and ocfs2_permission() to
catch exceptional cases, suggested by: Junxiao Bi <junxiao.bi@oracle.com>.
 
4. Do not inline functions whose bodies are not in scope, changed by:
Stephen Rothwell <sfr@canb.auug.org.au>.
 
Your comments and feedbacks are always welcomed.

Eric Ren (2):
  ocfs2/dlmglue: prepare tracking logic to avoid recursive cluster lock
  ocfs2: fix deadlock issue when taking inode lock at vfs entry points

 fs/ocfs2/acl.c     | 39 ++++++++++++++++++++++++----
 fs/ocfs2/dlmglue.c | 48 +++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h | 18 +++++++++++++
 fs/ocfs2/file.c    | 76 +++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/ocfs2.h   |  1 +
 5 files changed, 164 insertions(+), 18 deletions(-)

-- 
2.10.2
