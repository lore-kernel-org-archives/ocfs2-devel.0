From: Sasha Levin <sashal@kernel.org>
Date: Sat, 18 Apr 2020 10:44:00 -0400
Subject: [Ocfs2-devel] [PATCH AUTOSEL 4.9 18/23] ocfs2: no need try to
	truncate file beyond i_size
In-Reply-To: <20200418144405.10565-1-sashal@kernel.org>
References: <20200418144405.10565-1-sashal@kernel.org>
Message-ID: <20200418144405.10565-18-sashal@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Changwei Ge <chge@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Junxiao Bi <junxiao.bi@oracle.com>, Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>, Jun Piao <piaojun@huawei.com>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, ocfs2-devel@oss.oracle.com

From: Changwei Ge <chge@linux.alibaba.com>

[ Upstream commit 783fda856e1034dee90a873f7654c418212d12d7 ]

Linux fallocate(2) with FALLOC_FL_PUNCH_HOLE mode set, its offset can
exceed the inode size.  Ocfs2 now doesn't allow that offset beyond inode
size.  This restriction is not necessary and violates fallocate(2)
semantics.

If fallocate(2) offset is beyond inode size, just return success and do
nothing further.

Otherwise, ocfs2 will crash the kernel.

  kernel BUG at fs/ocfs2//alloc.c:7264!
   ocfs2_truncate_inline+0x20f/0x360 [ocfs2]
   ocfs2_remove_inode_range+0x23c/0xcb0 [ocfs2]
   __ocfs2_change_file_space+0x4a5/0x650 [ocfs2]
   ocfs2_fallocate+0x83/0xa0 [ocfs2]
   vfs_fallocate+0x148/0x230
   SyS_fallocate+0x48/0x80
   do_syscall_64+0x79/0x170

Signed-off-by: Changwei Ge <chge@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://urldefense.com/v3/__http://lkml.kernel.org/r/20200407082754.17565-1-chge at linux.alibaba.com__;!!GqivPVa7Brio!LUrD352okiIdCwv4iKGw97iYKybbPF1-QjfRg5fG-SokF5WyTtdqcd3OvwvG0URGXuFPNg$ 
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 06089becca607..dfb8a923921e0 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7246,6 +7246,10 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_inline_data *idata = &di->id2.i_data;
 
+	/* No need to punch hole beyond i_size. */
+	if (start >= i_size_read(inode))
+		return 0;
+
 	if (end > i_size_read(inode))
 		end = i_size_read(inode);
 
-- 
2.20.1
