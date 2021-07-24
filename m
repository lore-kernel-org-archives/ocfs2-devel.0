Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9195DC432BE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 19:35:42 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4760460E96
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 19:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4760460E96
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16OJVUao022856;
	Sat, 24 Jul 2021 19:35:41 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a09f1gsx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 19:35:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16OJUiC0041601;
	Sat, 24 Jul 2021 19:35:40 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07ysp9pe-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 19:35:40 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7NQx-0000qH-7O; Sat, 24 Jul 2021 12:35:39 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1m7NQR-0000nD-34
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 12:35:07 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16OJUb6L124616
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:35:06 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3a0a6mgd15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:35:06 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16OJWZd9022309
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:35:05 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0850nd3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:35:04 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-180-IrixSXtCNemYMhbd8sQCQw-1; Sat, 24 Jul 2021 15:35:02 -0400
X-MC-Unique: IrixSXtCNemYMhbd8sQCQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F161D8042E7;
	Sat, 24 Jul 2021 19:35:00 +0000 (UTC)
Received: from max.com (unknown [10.40.194.164])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8946718432;
	Sat, 24 Jul 2021 19:34:58 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Sat, 24 Jul 2021 21:34:42 +0200
Message-Id: <20210724193449.361667-2-agruenba@redhat.com>
In-Reply-To: <20210724193449.361667-1-agruenba@redhat.com>
References: <20210724193449.361667-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	mlxlogscore=999
	phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240117
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v4 1/8] iov_iter: Introduce
	iov_iter_fault_in_writeable helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240117
X-Proofpoint-GUID: ERp47Xt53DKiqVpkMT-sLFHttxgVPo4C
X-Proofpoint-ORIG-GUID: ERp47Xt53DKiqVpkMT-sLFHttxgVPo4C

Introduce a new iov_iter_fault_in_writeable helper for faulting in an iterator
for writing.  The pages are faulted in manually, without writing to them, so
this function is non-destructive.

We'll use iov_iter_fault_in_writeable in gfs2 once we've determined that part
of the iterator isn't in memory.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/mm.h  |  3 +++
 include/linux/uio.h |  1 +
 lib/iov_iter.c      | 40 +++++++++++++++++++++++++++++++
 mm/gup.c            | 57 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 101 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7ca22e6e694a..14b1353995e2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1840,6 +1840,9 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
 int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
 
+unsigned long fault_in_user_pages(unsigned long start, unsigned long len,
+				  bool write);
+
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 			struct task_struct *task, bool bypass_rlim);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..8e469b8b862f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -120,6 +120,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
 int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes);
+int iov_iter_fault_in_writeable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 20dc3d800573..ccf1ee8d4edf 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -460,6 +460,46 @@ int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
 }
 EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
+/**
+ * iov_iter_fault_in_writeable - fault in an iov iterator for writing
+ * @i: iterator
+ * @bytes: maximum length
+ *
+ * Faults in part or all of the iterator.  This is primarily useful when we
+ * already know that some or all of the pages in @i aren't in memory.
+ *
+ * This function uses fault_in_user_pages() to fault in the pages, which
+ * internally uses get_user_pages(), so it doesn't trigger hardware page
+ * faults.  Unlike fault_in_pages_writeable() which writes to the memory to
+ * fault it in, this function is non-destructive.
+ *
+ * Returns 0 on success, and a non-zero error code if the memory could not be
+ * accessed (i.e. because it is an invalid address).
+ */
+int iov_iter_fault_in_writeable(const struct iov_iter *i, size_t bytes)
+{
+	if (iter_is_iovec(i)) {
+		const struct iovec *p;
+		size_t skip;
+
+		if (bytes > i->count)
+			bytes = i->count;
+		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
+			unsigned long len = min(bytes, p->iov_len - skip);
+			unsigned long start;
+
+			if (unlikely(!len))
+				continue;
+			start = (unsigned long)p->iov_base + skip;
+			if (fault_in_user_pages(start, len, true) != len)
+				return -EFAULT;
+			bytes -= len;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iov_iter_fault_in_writeable);
+
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count)
diff --git a/mm/gup.c b/mm/gup.c
index 42b8b1fa6521..784809c232f1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1669,6 +1669,63 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 }
 #endif /* !CONFIG_MMU */
 
+/**
+ * fault_in_user_pages - fault in an address range for reading / writing
+ * @start: start of address range
+ * @len: length of address range
+ * @write: fault in for writing
+ *
+ * Note that we don't pin or otherwise hold the pages referenced that we fault
+ * in.  There's no guarantee that they'll stay in memory for any duration of
+ * time.
+ *
+ * Returns the number of bytes faulted in from @start.
+ */
+unsigned long fault_in_user_pages(unsigned long start, unsigned long len,
+				  bool write)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = NULL;
+	unsigned long end, nstart, nend;
+	int locked = 0;
+	int gup_flags;
+
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
+	if (write)
+		gup_flags |= FOLL_WRITE;
+
+	end = PAGE_ALIGN(start + len);
+	for (nstart = start & PAGE_MASK; nstart < end; nstart = nend) {
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
+		nend = min(end, vma->vm_end);
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+			continue;
+		if (nstart < vma->vm_start)
+			nstart = vma->vm_start;
+		nr_pages = (nend - nstart) / PAGE_SIZE;
+		ret = __get_user_pages_locked(mm, nstart, nr_pages,
+					      NULL, NULL, &locked, gup_flags);
+		if (ret <= 0)
+			break;
+		nend = nstart + ret * PAGE_SIZE;
+	}
+	if (locked)
+		mmap_read_unlock(mm);
+	if (nstart > start)
+		return min(nstart - start, len);
+	return 0;
+}
+
 /**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
