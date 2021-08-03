Return-Path: <SRS0=ZEQb=M2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C367C4320E
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:19:22 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C98C560F56
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:19:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C98C560F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173JBV13026482;
	Tue, 3 Aug 2021 19:19:21 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntmhwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Aug 2021 19:19:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173JBNSC079839;
	Tue, 3 Aug 2021 19:19:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a5g9vm6g8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 03 Aug 2021 19:19:18 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mAzwb-0000FM-V0; Tue, 03 Aug 2021 12:19:17 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mAzwa-0000F7-KP
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 12:19:16 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	173JA3Zg085273
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:19:16 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3a78d5a4gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:19:16 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	173JDq5c012123
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:19:15 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a7axergjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:19:15 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-495-L1wwZNlZOW-pGMgnx9sAag-1; Tue, 03 Aug 2021 15:19:10 -0400
X-MC-Unique: L1wwZNlZOW-pGMgnx9sAag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6971800489;
	Tue,  3 Aug 2021 19:19:08 +0000 (UTC)
Received: from max.com (unknown [10.40.193.155])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD6C560C0F;
	Tue,  3 Aug 2021 19:19:02 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Tue,  3 Aug 2021 21:18:18 +0200
Message-Id: <20210803191818.993968-13-agruenba@redhat.com>
In-Reply-To: <20210803191818.993968-1-agruenba@redhat.com>
References: <20210803191818.993968-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030123
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 12/12] gfs2: Fix mmap + page fault
	deadlocks for direct I/O
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030123
X-Proofpoint-ORIG-GUID: mUV2AjRZajdy2oBRx9VpXn7qagabwyIv
X-Proofpoint-GUID: mUV2AjRZajdy2oBRx9VpXn7qagabwyIv

Also disable page faults during direct I/O requests and implement the same
kind of retry logic as in the buffered I/O case.

Direct I/O requests differ from buffered I/O requests in that they use
bio_iov_iter_get_pages for grabbing page references and faulting in pages
instead of triggering physical page faults.  Those manual page faults can be
disabled with the new iocb->noio flag.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index d98f690097e2..ed42b7675551 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -782,21 +782,47 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 	struct file *file = iocb->ki_filp;
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
 	size_t count = iov_iter_count(to);
+	size_t written = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we drop the
+	 * inode glock, fault in the pages manually, and retry.
+	 *
+	 * Unlike generic_file_read_iter, for reads, iomap_dio_rw can trigger
+	 * physical as well as manual page faults, and we need to disable both
+	 * kinds.
+	 */
+
 	if (!count)
 		return 0; /* skip atime */
 
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
 
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
+	pagefault_disable();
+	to->noio = true;
+	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, written);
+	to->noio = false;
+	pagefault_enable();
+
 	gfs2_glock_dq(gh);
+	if (ret > 0)
+		written = ret;
+	if (unlikely(iov_iter_count(to) && (ret > 0 || ret == -EFAULT)) &&
+	    iter_is_iovec(to) &&
+	    fault_in_iov_iter_writeable(to, SIZE_MAX) != 0)
+		goto retry;
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return written;
 }
 
 static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
@@ -809,6 +835,15 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we drop the
+	 * inode glock, fault in the pages manually, and retry.
+	 *
+	 * For writes, iomap_dio_rw only triggers manual page faults, so we
+	 * don't need to disable physical ones.
+	 */
+
 	/*
 	 * Deferred lock, even if its a write, since we do no allocation on
 	 * this path. All we need to change is the atime, and this lock mode
@@ -818,6 +853,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	 * VFS does.
 	 */
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
@@ -826,11 +862,18 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	if (offset + len > i_size_read(&ip->i_inode))
 		goto out;
 
+	from->noio = true;
 	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
+	from->noio = false;
+
 	if (ret == -ENOTBLK)
 		ret = 0;
 out:
 	gfs2_glock_dq(gh);
+	if (unlikely(ret == -EFAULT) &&
+	    iter_is_iovec(from) &&
+	    fault_in_iov_iter_readable(from, len) == len)
+		goto retry;
 out_uninit:
 	gfs2_holder_uninit(gh);
 	return ret;
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
