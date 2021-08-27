Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F88C4320A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 16:53:12 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7C3060FD9
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 16:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C7C3060FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGcfOG024871;
	Fri, 27 Aug 2021 16:53:11 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4xv41jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 16:53:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RGpcQP180585;
	Fri, 27 Aug 2021 16:53:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb92end5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 16:53:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJf3H-0003DC-Hc; Fri, 27 Aug 2021 09:49:59 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mJf3F-0003CJ-KS
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 09:49:57 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RGnmXB036145
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 16:49:57 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ajpm50g1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 16:49:57 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RGjtDb017205
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 16:49:56 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq3um01fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 16:49:55 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-499-UYs3DcWCOEyEPZPkf4-OQg-1; Fri, 27 Aug 2021 12:49:53 -0400
X-MC-Unique: UYs3DcWCOEyEPZPkf4-OQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05B1A8799E0;
	Fri, 27 Aug 2021 16:49:52 +0000 (UTC)
Received: from max.com (unknown [10.40.194.206])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 728D160C04;
	Fri, 27 Aug 2021 16:49:49 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 27 Aug 2021 18:49:10 +0200
Message-Id: <20210827164926.1726765-4-agruenba@redhat.com>
In-Reply-To: <20210827164926.1726765-1-agruenba@redhat.com>
References: <20210827164926.1726765-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
X-Source-IP: 216.205.24.124
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270101
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v7 03/19] gup: Turn fault_in_pages_{readable,
	writeable} into fault_in_{readable, writeable}
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270101
X-Proofpoint-ORIG-GUID: Y-Jbh5cWm6xHhQ8IKeBGJvTVJOZmEL_s
X-Proofpoint-GUID: Y-Jbh5cWm6xHhQ8IKeBGJvTVJOZmEL_s

Turn fault_in_pages_{readable,writeable} into versions that return the
number of bytes not faulted in (similar to copy_to_user) instead of
returning a non-zero value when any of the requested pages couldn't be
faulted in.  This supports the existing users that require all pages to
be faulted in as well as new users that are happy if any pages can be
faulted in at all.

Neither of these functions is entirely trivial and it doesn't seem
useful to inline them, so move them to mm/gup.c.

Rename the functions to fault_in_{readable,writeable} to make sure that
this change doesn't silently break things.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 arch/powerpc/kernel/kvm.c           |  3 +-
 arch/powerpc/kernel/signal_32.c     |  4 +-
 arch/powerpc/kernel/signal_64.c     |  2 +-
 arch/x86/kernel/fpu/signal.c        |  7 ++-
 drivers/gpu/drm/armada/armada_gem.c |  7 ++-
 fs/btrfs/ioctl.c                    |  5 +-
 include/linux/pagemap.h             | 57 ++---------------------
 lib/iov_iter.c                      | 10 ++--
 mm/filemap.c                        |  2 +-
 mm/gup.c                            | 72 +++++++++++++++++++++++++++++
 10 files changed, 93 insertions(+), 76 deletions(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index d89cf802d9aa..6568823cf306 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -669,7 +669,8 @@ static void __init kvm_use_magic_page(void)
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_readable((const char __user *)KVM_MAGIC_PAGE,
+			      sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 0608581967f0..38c3eae40c14 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1048,7 +1048,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
 	if (new_ctx == NULL)
 		return 0;
 	if (!access_ok(new_ctx, ctx_size) ||
-	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
+	    fault_in_readable((char __user *)new_ctx, ctx_size))
 		return -EFAULT;
 
 	/*
@@ -1237,7 +1237,7 @@ SYSCALL_DEFINE3(debug_setcontext, struct ucontext __user *, ctx,
 #endif
 
 	if (!access_ok(ctx, sizeof(*ctx)) ||
-	    fault_in_pages_readable((u8 __user *)ctx, sizeof(*ctx)))
+	    fault_in_readable((char __user *)ctx, sizeof(*ctx)))
 		return -EFAULT;
 
 	/*
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 1831bba0582e..9f471b4a11e3 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -688,7 +688,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
 	if (new_ctx == NULL)
 		return 0;
 	if (!access_ok(new_ctx, ctx_size) ||
-	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
+	    fault_in_readable((char __user *)new_ctx, ctx_size))
 		return -EFAULT;
 
 	/*
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 445c57c9c539..ba6bdec81603 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -205,7 +205,7 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+		if (!fault_in_writeable(buf_fx, fpu_user_xstate_size))
 			goto retry;
 		return -EFAULT;
 	}
@@ -278,10 +278,9 @@ static int restore_fpregs_from_user(void __user *buf, u64 xrestore,
 		if (ret != -EFAULT)
 			return -EINVAL;
 
-		ret = fault_in_pages_readable(buf, size);
-		if (!ret)
+		if (!fault_in_readable(buf, size))
 			goto retry;
-		return ret;
+		return -EFAULT;
 	}
 
 	/*
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 21909642ee4c..8fbb25913327 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -336,7 +336,7 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	struct drm_armada_gem_pwrite *args = data;
 	struct armada_gem_object *dobj;
 	char __user *ptr;
-	int ret;
+	int ret = 0;
 
 	DRM_DEBUG_DRIVER("handle %u off %u size %u ptr 0x%llx\n",
 		args->handle, args->offset, args->size, args->ptr);
@@ -349,9 +349,8 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	if (!access_ok(ptr, args->size))
 		return -EFAULT;
 
-	ret = fault_in_pages_readable(ptr, args->size);
-	if (ret)
-		return ret;
+	if (fault_in_readable(ptr, args->size))
+		return -EFAULT;
 
 	dobj = armada_gem_object_lookup(file, args->handle);
 	if (dobj == NULL)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ba98e08a029..9233ecc31e2e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2244,9 +2244,8 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;
 
 	while (1) {
-		ret = fault_in_pages_writeable(ubuf + sk_offset,
-					       *buf_size - sk_offset);
-		if (ret)
+		ret = -EFAULT;
+		if (fault_in_writeable(ubuf + sk_offset, *buf_size - sk_offset))
 			break;
 
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ed02aa522263..7c9edc9694d9 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -734,61 +734,10 @@ int wait_on_page_private_2_killable(struct page *page);
 extern void add_page_wait_queue(struct page *page, wait_queue_entry_t *waiter);
 
 /*
- * Fault everything in given userspace address range in.
+ * Fault in userspace address range.
  */
-static inline int fault_in_pages_writeable(char __user *uaddr, int size)
-{
-	char __user *end = uaddr + size - 1;
-
-	if (unlikely(size == 0))
-		return 0;
-
-	if (unlikely(uaddr > end))
-		return -EFAULT;
-	/*
-	 * Writing zeroes into userspace here is OK, because we know that if
-	 * the zero gets there, we'll be overwriting it.
-	 */
-	do {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			return -EFAULT;
-		uaddr += PAGE_SIZE;
-	} while (uaddr <= end);
-
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK))
-		return __put_user(0, end);
-
-	return 0;
-}
-
-static inline int fault_in_pages_readable(const char __user *uaddr, int size)
-{
-	volatile char c;
-	const char __user *end = uaddr + size - 1;
-
-	if (unlikely(size == 0))
-		return 0;
-
-	if (unlikely(uaddr > end))
-		return -EFAULT;
-
-	do {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			return -EFAULT;
-		uaddr += PAGE_SIZE;
-	} while (uaddr <= end);
-
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK)) {
-		return __get_user(c, end);
-	}
-
-	(void)c;
-	return 0;
-}
+size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 25dfc48536d7..069cedd9d7b4 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -191,7 +191,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_writeable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_writeable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		from = kaddr + offset;
 
@@ -275,7 +275,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -446,13 +446,11 @@ int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
 			bytes = i->count;
 		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
 			size_t len = min(bytes, p->iov_len - skip);
-			int err;
 
 			if (unlikely(!len))
 				continue;
-			err = fault_in_pages_readable(p->iov_base + skip, len);
-			if (unlikely(err))
-				return err;
+			if (fault_in_readable(p->iov_base + skip, len))
+				return -EFAULT;
 			bytes -= len;
 		}
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index d1458ecf2f51..4dec3bc7752e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -88,7 +88,7 @@
  *    ->lock_page		(access_process_vm)
  *
  *  ->i_mutex			(generic_perform_write)
- *    ->mmap_lock		(fault_in_pages_readable->do_page_fault)
+ *    ->mmap_lock		(fault_in_readable->do_page_fault)
  *
  *  bdi->wb.list_lock
  *    sb_lock			(fs/fs-writeback.c)
diff --git a/mm/gup.c b/mm/gup.c
index b94717977d17..0cf47955e5a1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1672,6 +1672,78 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 }
 #endif /* !CONFIG_MMU */
 
+/**
+ * fault_in_writeable - fault in userspace address range for writing
+ * @uaddr: start of address range
+ * @size: size of address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_writeable(char __user *uaddr, size_t size)
+{
+	char __user *start = uaddr, *end;
+
+	if (unlikely(size == 0))
+		return 0;
+	if (!PAGE_ALIGNED(uaddr)) {
+		if (unlikely(__put_user(0, uaddr) != 0))
+			return size;
+		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
+	}
+	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
+	if (unlikely(end < start))
+		end = NULL;
+	while (uaddr != end) {
+		if (unlikely(__put_user(0, uaddr) != 0))
+			goto out;
+		uaddr += PAGE_SIZE;
+	}
+
+out:
+	if (size > uaddr - start)
+		return size - (uaddr - start);
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_writeable);
+
+/**
+ * fault_in_readable - fault in userspace address range for reading
+ * @uaddr: start of user address range
+ * @size: size of user address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_readable(const char __user *uaddr, size_t size)
+{
+	const char __user *start = uaddr, *end;
+	volatile char c;
+
+	if (unlikely(size == 0))
+		return 0;
+	if (!PAGE_ALIGNED(uaddr)) {
+		if (unlikely(__get_user(c, uaddr) != 0))
+			return size;
+		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
+	}
+	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
+	if (unlikely(end < start))
+		end = NULL;
+	while (uaddr != end) {
+		if (unlikely(__get_user(c, uaddr) != 0))
+			goto out;
+		uaddr += PAGE_SIZE;
+	}
+
+out:
+	(void)c;
+	if (size > uaddr - start)
+		return size - (uaddr - start);
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_readable);
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
