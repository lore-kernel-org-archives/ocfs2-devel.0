From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 10 May 2016 12:53:41 +0800
Subject: [Ocfs2-devel] ocfs2: fix recursive locking deadlock
Message-ID: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi,

These two patches is to fix recursive locking deadlock issues. As we
talked with Mark before, recursive locking is not allowed in ocfs2,
so these two patches fixes the deadlock issue with reverting back
patches to avoid recursive locking. Please review.

Thanks,
Junxiao.
