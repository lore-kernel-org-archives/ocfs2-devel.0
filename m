From: Eric Ren <zren@suse.com>
Date: Tue, 17 Jan 2017 18:09:46 +0800
Subject: [Ocfs2-devel] [PATCH v4 0/2] fix deadlock caused by recursive
	cluster locking
Message-ID: <20170117100948.11657-1-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, jiangqi903@gmail.com, sfr@canb.auug.org.au, hch@lst.de, linux-kernel@vger.kernel.org

Hi Andrew,

This patch set version has got reviewed by Joseph and Junxiao Bi. I
think it's good to queued up now.

Thanks for all of you!
Eric

This is a formal patch set v2 to solve the deadlock issue on which I
previously started a RFC (draft patch), and the discussion happened here:
[https://oss.oracle.com/pipermail/ocfs2-devel/2016-October/012455.html]

Compared to the previous draft patch, this one is much simple and neat.
It neither messes up the dlmglue core, nor has a performance penalty on
the whole cluster locking system. Instead, it is only used in places where
such recursive cluster locking may happen.
 
Changes since v1: 
- Let ocfs2_is_locked_by_me() just return true/false to indicate if the
process gets the cluster lock - suggested by: Joseph Qi <jiangqi903@gmail.com>
and Junxiao Bi <junxiao.bi@oracle.com>.
 
- Change "struct ocfs2_holder" to a more meaningful name "ocfs2_lock_holder",
suggested by: Junxiao Bi. 
 
- Add debugging output at ocfs2_setattr() and ocfs2_permission() to
catch exceptional cases, suggested by: Junxiao Bi. 
 
- Do not inline functions whose bodies are not in scope, changed by:
Stephen Rothwell <sfr@canb.auug.org.au>.

Changes since v2: 
- Use new wrappers of tracking logic code, suggested by: Junxiao Bi.

Change since v3:
- Fixes redundant space, spotted by: Joseph Qi.
 
Your comments and feedbacks are always welcomed.

Eric Ren (2):
  ocfs2/dlmglue: prepare tracking logic to avoid recursive cluster lock
  ocfs2: fix deadlock issue when taking inode lock at vfs entry points

 fs/ocfs2/acl.c     |  29 +++++++--------
 fs/ocfs2/dlmglue.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/dlmglue.h |  18 +++++++++
 fs/ocfs2/file.c    |  58 ++++++++++++++++++++++-------
 fs/ocfs2/ocfs2.h   |   1 +
 5 files changed, 179 insertions(+), 32 deletions(-)

-- 
2.10.2
