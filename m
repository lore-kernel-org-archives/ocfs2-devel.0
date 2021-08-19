Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247ECC4320E
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:41:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA94660EBD
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:41:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DA94660EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JJWExQ004397;
	Thu, 19 Aug 2021 19:41:51 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahs40grke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 19:41:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JJV8mU041381;
	Thu, 19 Aug 2021 19:41:47 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm04huf-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 19:41:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGnv7-00059M-T5; Thu, 19 Aug 2021 12:41:45 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mGnuy-00055M-4H
	for ocfs2-devel@oss.oracle.com; Thu, 19 Aug 2021 12:41:36 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JJV3jK059807
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:36 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3ae3vm4gm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:35 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JJXP1r025524
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:34 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ah6vnq7jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:34 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-186-2TlZ3mZeO76BKzVT56iwqQ-1; Thu, 19 Aug 2021 15:41:32 -0400
X-MC-Unique: 2TlZ3mZeO76BKzVT56iwqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0EBB760C0;
	Thu, 19 Aug 2021 19:41:30 +0000 (UTC)
Received: from max.com (unknown [10.40.194.206])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0399F1B46B;
	Thu, 19 Aug 2021 19:41:24 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Thu, 19 Aug 2021 21:40:48 +0200
Message-Id: <20210819194102.1491495-6-agruenba@redhat.com>
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
X-Source-IP: 170.10.133.124
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	adultscore=0 mlxscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190114
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v6 05/19] iov_iter: Introduce
	fault_in_iov_iter_writeable
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
X-Proofpoint-GUID: 0o8uJKP_CzRM7x3nXmRZvm4hyUryoXHc
X-Proofpoint-ORIG-GUID: 0o8uJKP_CzRM7x3nXmRZvm4hyUryoXHc

Introduce a new fault_in_iov_iter_writeable helper for safely faulting
in an iterator for writing.  Uses get_user_pages() to fault in the pages
without actually writing to them, which would be destructive.

We'll use fault_in_iov_iter_writeable in gfs2 once we've determined that
the iterator passed to .read_iter isn't in memory.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/pagemap.h |  1 +
 include/linux/uio.h     |  1 +
 lib/iov_iter.c          | 39 +++++++++++++++++++++++++
 mm/gup.c                | 63 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 7c9edc9694d9..a629807edb8c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -737,6 +737,7 @@ extern void add_page_wait_queue(struct page *page, wait_queue_entry_t *waiter);
  * Fault in userspace address range.
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_safe_writeable(const char __user *uaddr, size_t size);
 size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 12d30246c2e9..ffa431aeb067 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -120,6 +120,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
 size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 082ab155496d..968f2d2595cd 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -467,6 +467,45 @@ size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
 }
 EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
+/*
+ * fault_in_iov_iter_writeable - fault in iov iterator for writing
+ * @i: iterator
+ * @size: maximum length
+ *
+ * Faults in the iterator using get_user_pages(), i.e., without triggering
+ * hardware page faults.  This is primarily useful when we know that some or
+ * all of the pages in @i aren't in memory.
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ *
+ * Always returns 0 for non-user space iterators.
+ */
+size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t size)
+{
+	if (iter_is_iovec(i)) {
+		size_t count = min(size, iov_iter_count(i));
+		const struct iovec *p;
+		size_t skip;
+
+		size -= count;
+		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
+			size_t len = min(count, p->iov_len - skip);
+			size_t ret;
+
+			if (unlikely(!len))
+				continue;
+			ret = fault_in_safe_writeable(p->iov_base + skip, len);
+			count -= len - ret;
+			if (ret)
+				break;
+		}
+		return count + size;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_iov_iter_writeable);
+
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count)
diff --git a/mm/gup.c b/mm/gup.c
index 0cf47955e5a1..03ab03b68dc7 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1707,6 +1707,69 @@ size_t fault_in_writeable(char __user *uaddr, size_t size)
 }
 EXPORT_SYMBOL(fault_in_writeable);
 
+/*
+ * fault_in_safe_writeable - fault in an address range for writing
+ * @uaddr: start of address range
+ * @size: length of address range
+ *
+ * Faults in an address range using get_user_pages, i.e., without triggering
+ * hardware page faults.  This is primarily useful when we know that some or
+ * all of the pages in the address range aren't in memory.
+ *
+ * Other than fault_in_writeable(), this function is non-destructive.
+ *
+ * Note that we don't pin or otherwise hold the pages referenced that we fault
+ * in.  There's no guarantee that they'll stay in memory for any duration of
+ * time.
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
+{
+	unsigned long start = (unsigned long)uaddr;
+	unsigned long end, nstart, nend;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = NULL;
+	int locked = 0;
+
+	nstart = start & PAGE_MASK;
+	end = PAGE_ALIGN(start + size);
+	if (end < nstart)
+		end = 0;
+	for (; nstart != end; nstart = nend) {
+		unsigned long nr_pages;
+		long ret;
+
+		if (!locked) {
+			locked = 1;
+			mmap_read_lock(mm);
+			vma = find_vma(mm, nstart);
+		} else if (nstart >= vma->vm_end)
+			vma = vma->vm_next;
+		if (!vma || vma->vm_start >= end)
+			break;
+		nend = end ? min(end, vma->vm_end) : vma->vm_end;
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+			continue;
+		if (nstart < vma->vm_start)
+			nstart = vma->vm_start;
+		nr_pages = (nend - nstart) / PAGE_SIZE;
+		ret = __get_user_pages_locked(mm, nstart, nr_pages,
+					      NULL, NULL, &locked,
+					      FOLL_TOUCH | FOLL_WRITE);
+		if (ret <= 0)
+			break;
+		nend = nstart + ret * PAGE_SIZE;
+	}
+	if (locked)
+		mmap_read_unlock(mm);
+	if (nstart == end)
+		return 0;
+	return size - min_t(size_t, nstart - start, size);
+}
+EXPORT_SYMBOL(fault_in_safe_writeable);
+
 /**
  * fault_in_readable - fault in userspace address range for reading
  * @uaddr: start of user address range
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
