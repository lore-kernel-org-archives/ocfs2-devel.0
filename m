Return-Path: <SRS0=X2TA=HK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EEDC433E6
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 16:54:12 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D2C9D64E5A
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 16:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2C9D64E5A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118GXfr4156731;
	Mon, 8 Feb 2021 16:54:11 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 36hkrmvh42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Feb 2021 16:54:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118GYZrU104144;
	Mon, 8 Feb 2021 16:54:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36j4vq5n5e-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 08 Feb 2021 16:54:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l99nd-0005jk-A3; Mon, 08 Feb 2021 08:54:09 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1l8nZC-0007Ot-VJ
	for ocfs2-devel@oss.oracle.com; Sun, 07 Feb 2021 09:09:47 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	117H0Zrq016372
	for <ocfs2-devel@oss.oracle.com>; Sun, 7 Feb 2021 17:09:46 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36j4vp0txb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 07 Feb 2021 17:09:46 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	117H4DDS022151
	for <ocfs2-devel@oss.oracle.com>; Sun, 7 Feb 2021 17:09:46 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2030.oracle.com with ESMTP id 36hh5gj0pd-5
	for <ocfs2-devel@oss.oracle.com>; Sun, 07 Feb 2021 17:09:45 +0000
X-IronPort-AV: E=Sophos;i="5.81,160,1610380800"; d="scan'208";a="104299378"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 08 Feb 2021 01:09:44 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id A63F74CE6F74;
	Mon,  8 Feb 2021 01:09:38 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 8 Feb 2021 01:09:38 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 8 Feb 2021 01:09:37 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
Date: Mon, 8 Feb 2021 01:09:24 +0800
Message-ID: <20210207170924.2933035-8-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: A63F74CE6F74.AE72D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	malwarescore=0 mlxscore=0
	adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=95
	suspectscore=0 clxscore=240 bulkscore=0 mlxlogscore=999 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102070121
X-Spam: Clean
X-Mailman-Approved-At: Mon, 08 Feb 2021 08:54:07 -0800
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 7/7] fs/xfs: Add dedupe support for fsdax
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1034
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080107

Add xfs_break_two_dax_layouts() to break layout for tow dax files.  Then
call compare range function only when files are both DAX or not.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/xfs/xfs_file.c    | 20 ++++++++++++++++++++
 fs/xfs/xfs_inode.c   |  8 +++++++-
 fs/xfs/xfs_inode.h   |  1 +
 fs/xfs/xfs_reflink.c | 21 ++++++++++++++++++---
 4 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ab738641a3f4..64ded96b43c8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -791,6 +791,26 @@ xfs_break_dax_layouts(
 			0, 0, xfs_wait_dax_page(inode));
 }
 
+int
+xfs_break_two_dax_layouts(
+	struct inode		*src,
+	struct inode		*dest)
+{
+	int			error;
+	bool			retry = false;
+
+retry:
+	error = xfs_break_dax_layouts(src, &retry);
+	if (error || retry)
+		goto retry;
+
+	error = xfs_break_dax_layouts(dest, &retry);
+	if (error || retry)
+		goto retry;
+
+	return error;
+}
+
 int
 xfs_break_layouts(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..6483dbaa4d57 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3786,8 +3786,10 @@ xfs_ilock2_io_mmap(
 	struct xfs_inode	*ip2)
 {
 	int			ret;
+	struct inode		*inode1 = VFS_I(ip1);
+	struct inode		*inode2 = VFS_I(ip2);
 
-	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
+	ret = xfs_iolock_two_inodes_and_break_layout(inode1, inode2);
 	if (ret)
 		return ret;
 	if (ip1 == ip2)
@@ -3795,6 +3797,10 @@ xfs_ilock2_io_mmap(
 	else
 		xfs_lock_two_inodes(ip1, XFS_MMAPLOCK_EXCL,
 				    ip2, XFS_MMAPLOCK_EXCL);
+
+	if (IS_DAX(inode1) && IS_DAX(inode2))
+		ret = xfs_break_two_dax_layouts(inode1, inode2);
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 751a3d1d7d84..462b61bea691 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -431,6 +431,7 @@ enum xfs_prealloc_flags {
 
 int	xfs_update_prealloc_flags(struct xfs_inode *ip,
 				  enum xfs_prealloc_flags flags);
+int	xfs_break_two_dax_layouts(struct inode *inode1, struct inode *inode2);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 38bde16cdb39..bdb9a07e703f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_sb.h"
 #include "xfs_ag_resv.h"
+#include <linux/dax.h>
 
 /*
  * Copy on Write of Shared Blocks
@@ -1251,6 +1252,14 @@ xfs_reflink_zero_posteof(
 			&xfs_buffered_write_iomap_ops);
 }
 
+int xfs_reflink_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+					  struct inode *dest, loff_t destoff,
+					  loff_t len, bool *is_same)
+{
+	return dax_file_range_compare(src, srcoff, dest, destoff, len, is_same,
+				      &xfs_read_iomap_ops);
+}
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
@@ -1293,6 +1302,7 @@ xfs_reflink_remap_prep(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
+	compare_range_t		compare_range_fn;
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1306,12 +1316,17 @@ xfs_reflink_remap_prep(
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
 
-	/* Don't share DAX file data for now. */
-	if (IS_DAX(inode_in) || IS_DAX(inode_out))
+	/* Don't share DAX file data with non-DAX file. */
+	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
+	if (IS_DAX(inode_in))
+		compare_range_fn = xfs_reflink_dedupe_file_range_compare;
+	else
+		compare_range_fn = vfs_dedupe_file_range_compare;
+
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, remap_flags, vfs_dedupe_file_range_compare);
+			len, remap_flags, compare_range_fn);
 	if (ret || *len == 0)
 		goto out_unlock;
 
-- 
2.30.0




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
