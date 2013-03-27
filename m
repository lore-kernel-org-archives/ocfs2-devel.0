From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Wed, 27 Mar 2013 14:01:11 -0000
Subject: [Ocfs2-devel] [PATCH -next] ocfs2: fix error return code in
	ocfs2_info_handle_freefrag()
Message-ID: <CAPgLHd_JduxWJtpcvFsYJD+39neJf5xQOZfNO0qS+zAX4GTzug@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: yongjun_wei@trendmicro.com.cn, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ocfs2/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 6cab301..0c60ef2 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -706,8 +706,10 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 
 	o2info_set_request_filled(&oiff->iff_req);
 
-	if (o2info_to_user(*oiff, req))
+	if (o2info_to_user(*oiff, req)) {
+		status = -EFAULT;
 		goto bail;
+	}
 
 	status = 0;
 bail:
