Return-Path: <SRS0=ZEQb=M2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE84C43214
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:19:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3AF3A61037
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3AF3A61037
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173JCQHk003221;
	Tue, 3 Aug 2021 19:19:12 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqdc1w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Aug 2021 19:19:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173JBNxs193825;
	Tue, 3 Aug 2021 19:19:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a4un07sgk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 03 Aug 2021 19:19:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mAzwT-00007t-3x; Tue, 03 Aug 2021 12:19:09 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mAzw7-0008VD-Ih
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 12:18:47 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	173JA5eI085375
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:18:47 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3a78d5a44w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:18:47 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	173JD7hQ013095
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:18:46 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a6avvj81p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:18:45 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-392-I4hoRkuWOxmVpzPQ0rrEZQ-1; Tue, 03 Aug 2021 15:18:41 -0400
X-MC-Unique: I4hoRkuWOxmVpzPQ0rrEZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D5771802968;
	Tue,  3 Aug 2021 19:18:39 +0000 (UTC)
Received: from max.com (unknown [10.40.193.155])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 271F460C0F;
	Tue,  3 Aug 2021 19:18:36 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Tue,  3 Aug 2021 21:18:10 +0200
Message-Id: <20210803191818.993968-5-agruenba@redhat.com>
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
X-Source-IP: 170.10.133.124
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
Subject: [Ocfs2-devel] [PATCH v5 04/12] Turn iov_iter_fault_in_readable into
	fault_in_iov_iter_readable
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030123
X-Proofpoint-ORIG-GUID: hMh_onbZSdP0EK3hlHt5nWeiT6A2ZLwM
X-Proofpoint-GUID: hMh_onbZSdP0EK3hlHt5nWeiT6A2ZLwM

Turn iov_iter_fault_in_readable into a function that returns the number of
bytes faulted in instead of returning a non-zero value when any of the
requested pages couldn't be faulted in.  This supports the existing users that
require all pages to be faulted in, but also new users that are happy if any
pages can be faulted in.

Rename iov_iter_fault_in_readable to an unfortunately clumsy
fault_in_iov_iter_readable to make sure that code that uses it can be fixed
instead of breaking silently.

Fix up the existing users.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/btrfs/file.c        |  3 ++-
 fs/f2fs/file.c         |  6 +++---
 fs/fuse/file.c         |  2 +-
 fs/iomap/buffered-io.c |  2 +-
 fs/ntfs/file.c         |  2 +-
 include/linux/uio.h    |  2 +-
 lib/iov_iter.c         | 33 ++++++++++++++++++++++-----------
 mm/filemap.c           |  2 +-
 8 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ee34497500e1..8ff9e0bb5b0f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1698,7 +1698,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		 * Fault pages before locking them in prepare_pages
 		 * to avoid recursive lock
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, write_bytes) !=
+				write_bytes)) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6afd4562335f..7c172573f18a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4255,16 +4255,16 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	ret = generic_write_checks(iocb, from);
 	if (ret > 0) {
+		size_t count = iov_iter_count(from);
 		bool preallocated = false;
 		size_t target_size = 0;
 		int err;
 
-		if (iov_iter_fault_in_readable(from, iov_iter_count(from)))
+		if (fault_in_iov_iter_readable(from, count) != count)
 			set_inode_flag(inode, FI_NO_PREALLOC);
 
 		if ((iocb->ki_flags & IOCB_NOWAIT)) {
-			if (!f2fs_overwrite_io(inode, iocb->ki_pos,
-						iov_iter_count(from)) ||
+			if (!f2fs_overwrite_io(inode, iocb->ki_pos, count) ||
 				f2fs_has_inline_data(inode) ||
 				f2fs_force_buffered_io(inode, iocb, from)) {
 				clear_inode_flag(inode, FI_NO_PREALLOC);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 97f860cfc195..d5dd01f20f1e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1160,7 +1160,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 
  again:
 		err = -EFAULT;
-		if (iov_iter_fault_in_readable(ii, bytes))
+		if (fault_in_iov_iter_readable(ii, bytes) != bytes)
 			break;
 
 		err = -ENOMEM;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 87ccb3438bec..d5de094fef73 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -749,7 +749,7 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes) != bytes)) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ab4f3362466d..cddac274c35a 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1829,7 +1829,7 @@ static ssize_t ntfs_perform_write(struct file *file, struct iov_iter *i,
 		 * pages being swapped out between us bringing them into memory
 		 * and doing the actual copying.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes) != bytes)) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..12d30246c2e9 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -119,7 +119,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 				  size_t bytes, struct iov_iter *i);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 92d877a698f0..c0fa1618561c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -432,33 +432,44 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 }
 
 /*
+ * fault_in_iov_iter_readable - fault in iov iterator for reading
+ * @i: iterator
+ * @size: maximum length
+ *
  * Fault in one or more iovecs of the given iov_iter, to a maximum length of
- * bytes.  For each iovec, fault in each page that constitutes the iovec.
+ * @size.  For each iovec, fault in each page that constitutes the iovec.
+ *
+ * Returns the number of bytes faulted in, or 0 if no bytes could be faulted in
+ * (i.e., because the address is invalid).
  *
- * Return 0 on success, or non-zero if the memory could not be accessed (i.e.
- * because it is an invalid address).
+ * Always returns the number of avaliable bytes for non-user space iterators.
  */
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
 {
+	if (size > i->count)
+		size = i->count;
+
 	if (iter_is_iovec(i)) {
 		const struct iovec *p;
+		size_t bytes = size;
 		size_t skip;
 
-		if (bytes > i->count)
-			bytes = i->count;
 		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
 			size_t len = min(bytes, p->iov_len - skip);
+			size_t ret;
 
 			if (unlikely(!len))
 				continue;
-			if (fault_in_readable(p->iov_base + skip, len) != len)
-				return -EFAULT;
-			bytes -= len;
+			ret = fault_in_readable(p->iov_base + skip, len);
+			bytes -= ret;
+			if (ret != len)
+				break;
 		}
+		return size - bytes;
 	}
-	return 0;
+	return size;
 }
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
+EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
diff --git a/mm/filemap.c b/mm/filemap.c
index 4dec3bc7752e..5f5aed060c9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3643,7 +3643,7 @@ ssize_t generic_perform_write(struct file *file,
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes) != bytes)) {
 			status = -EFAULT;
 			break;
 		}
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
