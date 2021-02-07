Return-Path: <SRS0=X2TA=HK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F53C4332E
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 16:54:13 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C26E64E9D
	for <ocfs2-devel@archiver.kernel.org>; Mon,  8 Feb 2021 16:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C26E64E9D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118GZCqJ184538;
	Mon, 8 Feb 2021 16:54:12 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36hk2kck16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Feb 2021 16:54:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118GYvTc010119;
	Mon, 8 Feb 2021 16:54:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36j51uwv77-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 08 Feb 2021 16:54:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l99nd-0005kF-CQ; Mon, 08 Feb 2021 08:54:09 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1l8nZE-0007PC-8h
	for ocfs2-devel@oss.oracle.com; Sun, 07 Feb 2021 09:09:48 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	117H9mjp069186
	for <ocfs2-devel@oss.oracle.com>; Sun, 7 Feb 2021 17:09:48 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 36j4pkfv6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 07 Feb 2021 17:09:48 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	117H58wt017840
	for <ocfs2-devel@oss.oracle.com>; Sun, 7 Feb 2021 17:09:41 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 36hhqt2jqt-2
	for <ocfs2-devel@oss.oracle.com>; Sun, 07 Feb 2021 17:09:41 +0000
X-IronPort-AV: E=Sophos;i="5.81,160,1610380800"; d="scan'208";a="104299371"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 08 Feb 2021 01:09:38 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id BF2554CE6F77;
	Mon,  8 Feb 2021 01:09:35 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
	G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 8 Feb 2021 01:09:36 +0800
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 8 Feb 2021 01:09:37 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 8 Feb 2021 01:09:36 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
Date: Mon, 8 Feb 2021 01:09:23 +0800
Message-ID: <20210207170924.2933035-7-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: BF2554CE6F77.AE2A0
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 adultscore=0
	spamscore=0 bulkscore=0 clxscore=188 malwarescore=0 suspectscore=0
	priorityscore=95 mlxscore=0 mlxlogscore=570 impostorscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102070121
X-Spam: Clean
X-Mailman-Approved-At: Mon, 08 Feb 2021 08:54:07 -0800
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 6/7] fs/xfs: Handle CoW for fsdax write() path
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1034 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080107

In fsdax mode, WRITE and ZERO on a shared extent need CoW mechanism
performed.  After CoW, new extents needs to be remapped to the file.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/xfs/xfs_bmap_util.c |  6 +++++-
 fs/xfs/xfs_file.c      | 10 +++++++---
 fs/xfs/xfs_iomap.c     |  3 ++-
 fs/xfs/xfs_iops.c      | 11 ++++++++---
 fs/xfs/xfs_reflink.c   |  2 ++
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..eb0c7ff103f8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -977,10 +977,14 @@ xfs_free_file_space(
 	if (offset + len > XFS_ISIZE(ip))
 		len = XFS_ISIZE(ip) - offset;
 	error = iomap_zero_range(VFS_I(ip), offset, len, NULL,
-			&xfs_buffered_write_iomap_ops);
+		  IS_DAX(VFS_I(ip)) ?
+		  &xfs_direct_write_iomap_ops : &xfs_buffered_write_iomap_ops);
 	if (error)
 		return error;
 
+	if (xfs_is_reflink_inode(ip))
+		xfs_reflink_end_cow(ip, offset, len);
+
 	/*
 	 * If we zeroed right up to EOF and EOF straddles a page boundary we
 	 * must make sure that the post-EOF area is also zeroed because the
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..ab738641a3f4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -624,9 +624,13 @@ xfs_file_dax_write(
 
 	trace_xfs_file_dax_write(ip, count, pos);
 	ret = dax_iomap_rw(iocb, from, &xfs_direct_write_iomap_ops);
-	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
-		i_size_write(inode, iocb->ki_pos);
-		error = xfs_setfilesize(ip, pos, ret);
+	if (ret > 0) {
+		if (iocb->ki_pos > i_size_read(inode)) {
+			i_size_write(inode, iocb->ki_pos);
+			error = xfs_setfilesize(ip, pos, ret);
+		}
+		if (xfs_is_cow_inode(ip))
+			xfs_reflink_end_cow(ip, pos, ret);
 	}
 out:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7b9ff824e82d..d6d4cc0f084e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -765,13 +765,14 @@ xfs_direct_write_iomap_begin(
 		goto out_unlock;
 
 	if (imap_needs_cow(ip, flags, &imap, nimaps)) {
+		bool need_convert = flags & IOMAP_DIRECT || IS_DAX(inode);
 		error = -EAGAIN;
 		if (flags & IOMAP_NOWAIT)
 			goto out_unlock;
 
 		/* may drop and re-acquire the ilock */
 		error = xfs_reflink_allocate_cow(ip, &imap, &cmap, &shared,
-				&lockmode, flags & IOMAP_DIRECT);
+				&lockmode, need_convert);
 		if (error)
 			goto out_unlock;
 		if (shared)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1414ab79eacf..480bda0f16d0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -860,6 +860,7 @@ xfs_setattr_size(
 	int			error;
 	uint			lock_flags = 0;
 	bool			did_zeroing = false;
+	const struct iomap_ops	*ops;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
@@ -906,10 +907,15 @@ xfs_setattr_size(
 	 * extension, or zeroing out the rest of the block on a downward
 	 * truncate.
 	 */
+	if (IS_DAX(inode))
+		ops = &xfs_direct_write_iomap_ops;
+	else
+		ops = &xfs_buffered_write_iomap_ops;
+
 	if (newsize > oldsize) {
 		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
 		error = iomap_zero_range(inode, oldsize, newsize - oldsize,
-				&did_zeroing, &xfs_buffered_write_iomap_ops);
+				&did_zeroing, ops);
 	} else {
 		/*
 		 * iomap won't detect a dirty page over an unwritten block (or a
@@ -921,8 +927,7 @@ xfs_setattr_size(
 						     newsize);
 		if (error)
 			return error;
-		error = iomap_truncate_page(inode, newsize, &did_zeroing,
-				&xfs_buffered_write_iomap_ops);
+		error = iomap_truncate_page(inode, newsize, &did_zeroing, ops);
 	}
 
 	if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 26708c01fd78..38bde16cdb39 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1246,6 +1246,8 @@ xfs_reflink_zero_posteof(
 
 	trace_xfs_zero_eof(ip, isize, pos - isize);
 	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
+			IS_DAX(VFS_I(ip)) ?
+			&xfs_direct_write_iomap_ops :
 			&xfs_buffered_write_iomap_ops);
 }
 
-- 
2.30.0




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
