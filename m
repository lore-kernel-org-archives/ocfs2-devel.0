Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF1A4A991
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Nov 2023 12:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DMSgh77W"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALB9NaZ009930;
	Tue, 21 Nov 2023 12:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=MbhGWsApsD/LUIroLWUz2V7v0ub0+Q6g1AnObLHT9PA=;
 b=DMSgh77WvljN5S+h+e850R/avJMsC4zgPoqBSvh5920ZJOzbhwP70qxLHS2VIyX28/9h
 k3KgriGePR9/gNfYRcPzAO02K5+kIzeF8YoANeY6lAz19784A8LAQd8/1LZxwN5CTVAm
 Qw5eR7QV9AXUNtN+48ZhzrmK/hsVCsNflTYA4EVUoGyb34uqNpGSGwwpzSdKa/fYCHaK
 EGyXctGJUqb5mT0mHyFsCEXm2v149l+2Yqa2pRra7pk44Vm4YnxWQT/DRzVHjJJ/cdU3
 qV6eqVPHnxFc0J5LD2F0+XojM2Hl18ZDgTiUVJ1gC1B/Y6oxrTn/M2RRTK+g3cS7mewy jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uekv2vxk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 12:25:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALBNLXe023548;
	Tue, 21 Nov 2023 12:25:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq6w929-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 12:25:27 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ALCPR32036011;
	Tue, 21 Nov 2023 12:25:27 GMT
Received: from sridara-source.osdevelopmeniad.oraclevcn.com (sridara-source.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.252.239])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uekq6w91q-1;
	Tue, 21 Nov 2023 12:25:27 +0000
From: Srivathsa Dara <srivathsa.d.dara@oracle.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ailiop@suse.com
Cc: srivathsa.d.dara@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com, ocfs2-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, gautham.ananthakrishna@oracle.com
Subject: [PATCH v2] ocfs2: call ocfs2_abort when journal abort
Date: Tue, 21 Nov 2023 12:25:23 +0000
Message-Id: <20231121122523.1859827-1-srivathsa.d.dara@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_05,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311210097
X-Proofpoint-GUID: OUrioSaDep2pGoVU_BWqoZofVzb3cBW9
X-Proofpoint-ORIG-GUID: OUrioSaDep2pGoVU_BWqoZofVzb3cBW9

From: Ryan Ding <ryan.ding@oracle.com>

Journal can not recover from abort state, so we should panic. Because we
can not release lock resource in this state, other node will hung when it
require a lock owned by this node. So, panic and remaster is a reasonable
choice.

ocfs2_abort() will do above work.

Co-Developed-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Signed-off-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
---
v1-> v2: Remove redundant code and comments related to local mount.
 fs/ocfs2/journal.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ce215565d061..52d71e9ded2e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -14,7 +14,6 @@
 #include <linux/kthread.h>
 #include <linux/time.h>
 #include <linux/random.h>
-#include <linux/delay.h>
 #include <linux/writeback.h>
 
 #include <cluster/masklog.h>
@@ -2326,7 +2325,7 @@ static int __ocfs2_wait_on_mount(struct ocfs2_super *osb, int quota)
 
 static int ocfs2_commit_thread(void *arg)
 {
-	int status;
+	int status = 0;
 	struct ocfs2_super *osb = arg;
 	struct ocfs2_journal *journal = osb->journal;
 
@@ -2343,18 +2342,11 @@ static int ocfs2_commit_thread(void *arg)
 
 		status = ocfs2_commit_cache(osb);
 		if (status < 0) {
-			static unsigned long abort_warn_time;
-
-			/* Warn about this once per minute */
-			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
-				mlog(ML_ERROR, "status = %d, journal is "
-						"already aborted.\n", status);
 			/*
-			 * After ocfs2_commit_cache() fails, j_num_trans has a
-			 * non-zero value.  Sleep here to avoid a busy-wait
-			 * loop.
+			 * Journal can not recover from abort state, there is
+			 * no need to keep commit cache. So, we should panic.
 			 */
-			msleep_interruptible(1000);
+			ocfs2_abort(osb->sb, "Detected aborted journal");
 		}
 
 		if (kthread_should_stop() && atomic_read(&journal->j_num_trans)){
-- 
2.39.3

