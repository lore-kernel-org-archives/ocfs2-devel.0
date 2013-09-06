From: Jensen <shencanquan@huawei.com>
Date: Fri, 6 Sep 2013 09:50:22 +0800
Subject: [Ocfs2-devel] why ocfs2 quota need call ocfs2_qinfo_lock function
 before qtree_read_dquot or qtree_write_dquot ?
Message-ID: <522934DE.6070503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
   I want to know why ocfs2 quota need call ocfs2_qinfo_lock function before qtree_read_dquot or
qtree_write_dquot in ocfs2_acquire_dquot function.
   I think that it need not, because before ocfs2_qinfo_lock, it has ocfs2_lock_global_qf, it will
lock the global quota inode.

Thanks,
Jesen.
2013-9-6
