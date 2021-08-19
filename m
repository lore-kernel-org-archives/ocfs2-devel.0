Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9C9C432BE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:42:24 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2427B61051
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2427B61051
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JJWELO004403;
	Thu, 19 Aug 2021 19:42:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahs40grm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 19:42:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JJV8Ko041368;
	Thu, 19 Aug 2021 19:42:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm04jht-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 19:42:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGnvg-0005KI-UI; Thu, 19 Aug 2021 12:42:20 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mGnvc-0005K1-MO
	for ocfs2-devel@oss.oracle.com; Thu, 19 Aug 2021 12:42:16 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JJV8q6041391
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:42:16 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3aeqm04jed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:42:16 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JJXU5a022151
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:42:14 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahg4asuaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:42:14 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-ko63kXHdO_GJs2Q7EkborA-1; Thu, 19 Aug 2021 15:42:07 -0400
X-MC-Unique: ko63kXHdO_GJs2Q7EkborA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BD3D760D0;
	Thu, 19 Aug 2021 19:42:06 +0000 (UTC)
Received: from max.com (unknown [10.40.194.206])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A98C260938;
	Thu, 19 Aug 2021 19:42:01 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Thu, 19 Aug 2021 21:40:58 +0200
Message-Id: <20210819194102.1491495-16-agruenba@redhat.com>
In-Reply-To: <20210819194102.1491495-1-agruenba@redhat.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.129.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 malwarescore=0
	mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=846 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190114
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v6 15/19] iomap: Add done_before argument to
	iomap_dio_rw
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190114
X-Proofpoint-GUID: 8ChicShqsKmkPTF8T9rFf16POrEIL4Pn
X-Proofpoint-ORIG-GUID: 8ChicShqsKmkPTF8T9rFf16POrEIL4Pn

Add a done_before argument to iomap_dio_rw that indicates how much of
the request has already been transferred.  When the request succeeds, we
report that done_before additional bytes were tranferred.  This is
useful for finishing a request asynchronously when part of the request
has already been completed synchronously.

We'll use that to allow iomap_dio_rw to be used with page faults
disabled: when a page fault occurs while submitting a request, we
synchronously complete the part of the request that has already been
submitted.  The caller can then take care of the page fault and call
iomap_dio_rw again for the rest of the request, passing in the number of
bytes already tranferred.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/btrfs/file.c       |  5 +++--
 fs/ext4/file.c        |  5 +++--
 fs/gfs2/file.c        |  4 ++--
 fs/iomap/direct-io.c  | 11 ++++++++---
 fs/xfs/xfs_file.c     |  6 +++---
 fs/zonefs/super.c     |  4 ++--
 include/linux/iomap.h |  4 ++--
 7 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 281c77cfe91a..8817fe6b5fc0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1945,7 +1945,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			     0);
+			     0, 0);
 
 	btrfs_inode_unlock(inode, ilock_flags);
 
@@ -3637,7 +3637,8 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 		return 0;
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
-	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops, 0);
+	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			   0, 0);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	return ret;
 }
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 816dedcbd541..4a5e7fd31fb5 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -74,7 +74,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return generic_file_read_iter(iocb, to);
 	}
 
-	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, 0);
 	inode_unlock_shared(inode);
 
 	file_accessed(iocb->ki_filp);
@@ -566,7 +566,8 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ilock_shared)
 		iomap_ops = &ext4_iomap_overwrite_ops;
 	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
-			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0);
+			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0,
+			   0);
 	if (ret == -ENOTBLK)
 		ret = 0;
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index c4262d6ba5e4..8ca6bdba907c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -822,7 +822,7 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 	if (ret)
 		goto out_uninit;
 
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
 	gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
@@ -856,7 +856,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	if (offset + len > i_size_read(&ip->i_inode))
 		goto out;
 
-	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
 out:
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ba88fe51b77a..dcf9a2b4381f 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -31,6 +31,7 @@ struct iomap_dio {
 	atomic_t		ref;
 	unsigned		flags;
 	int			error;
+	size_t			done_before;
 	bool			wait_for_completion;
 
 	union {
@@ -126,6 +127,9 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 	if (ret > 0 && (dio->flags & IOMAP_DIO_NEED_SYNC))
 		ret = generic_write_sync(iocb, ret);
 
+	if (ret > 0)
+		ret += dio->done_before;
+
 	kfree(dio);
 
 	return ret;
@@ -450,7 +454,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 struct iomap_dio *
 __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags)
+		unsigned int dio_flags, size_t done_before)
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -477,6 +481,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	dio->dops = dops;
 	dio->error = 0;
 	dio->flags = 0;
+	dio->done_before = done_before;
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
@@ -648,11 +653,11 @@ EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 ssize_t
 iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags)
+		unsigned int dio_flags, size_t done_before)
 {
 	struct iomap_dio *dio;
 
-	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags);
+	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, done_before);
 	if (IS_ERR_OR_NULL(dio))
 		return PTR_ERR_OR_ZERO(dio);
 	return iomap_dio_complete(dio);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cc3cfb12df53..3103d9bda466 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -259,7 +259,7 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
-	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, 0);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -569,7 +569,7 @@ xfs_file_dio_write_aligned(
 	}
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
-			   &xfs_dio_write_ops, 0);
+			   &xfs_dio_write_ops, 0, 0);
 out_unlock:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
@@ -647,7 +647,7 @@ xfs_file_dio_write_unaligned(
 
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
-			   &xfs_dio_write_ops, flags);
+			   &xfs_dio_write_ops, flags, 0);
 
 	/*
 	 * Retry unaligned I/O with exclusive blocking semantics if the DIO
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 70055d486bf7..85ca2f5fe06e 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -864,7 +864,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 		ret = zonefs_file_dio_append(iocb, from);
 	else
 		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
-				   &zonefs_write_dio_ops, 0);
+				   &zonefs_write_dio_ops, 0, 0);
 	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
 		if (ret > 0)
@@ -999,7 +999,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		}
 		file_accessed(iocb->ki_filp);
 		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
-				   &zonefs_read_dio_ops, 0);
+				   &zonefs_read_dio_ops, 0, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, to);
 		if (ret == -EIO)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bcae4814b8e3..908bda10024c 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -276,10 +276,10 @@ struct iomap_dio_ops {
 
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags);
+		unsigned int dio_flags, size_t done_before);
 struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags);
+		unsigned int dio_flags, size_t done_before);
 ssize_t iomap_dio_complete(struct iomap_dio *dio);
 int iomap_dio_iopoll(struct kiocb *kiocb, bool spin);
 
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
