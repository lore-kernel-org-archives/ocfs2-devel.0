From: Shuning Zhang <sunny.s.zhang@oracle.com>
Date: Wed, 18 Sep 2019 10:02:53 +0800
Subject: [Ocfs2-devel] [PATCH V2 0/2] ocfs2: protect extent tree in the
	ocfs2_prepare_inode_for_write
Message-ID: <1568772175-2906-1-git-send-email-sunny.s.zhang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I split the patch into 2 patches. A unused function is removed in
the second patch. This will make patches easier to read.

v1->v2:
  - split the patch into 2 patches
  - abstract a pair of function for locking and unlocking
  - remove the function call of ocfs2_prepare_inode_for_refcount

Shuning Zhang (2):
  ocfs2: protect extent tree in the ocfs2_prepare_inode_for_write
  ocfs2: remove unused function ocfs2_prepare_inode_for_refcount

 fs/ocfs2/file.c | 136 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 91 insertions(+), 45 deletions(-)

-- 
2.7.4
