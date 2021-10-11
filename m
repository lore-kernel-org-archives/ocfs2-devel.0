Return-Path: <SRS0=Exlr=O7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AF5C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 21:08:30 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A3E57601FC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Oct 2021 21:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A3E57601FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BKbsjD012464;
	Mon, 11 Oct 2021 21:08:28 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bmq2vjjsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Oct 2021 21:08:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BL540Z165712;
	Mon, 11 Oct 2021 21:08:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bkyv7p0fe-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 11 Oct 2021 21:08:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1ma2X4-0005Zx-Ca; Mon, 11 Oct 2021 14:08:26 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1ma2X1-0005ZW-Ko
	for ocfs2-devel@oss.oracle.com; Mon, 11 Oct 2021 14:08:23 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BL4gLm010425
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 21:08:23 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bmadwvmyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 21:08:23 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19BJIbM9006819
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 21:08:22 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bmuajsdve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 21:08:22 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47FA360F43;
	Mon, 11 Oct 2021 21:08:18 +0000 (UTC)
Date: Mon, 11 Oct 2021 22:08:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YWSnvq58jDsDuIik@arm.com>
References: <CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110120
X-Proofpoint-GUID: 4D_18gN-EoY2WhuW0LXdfPagmdNN8U92
X-Proofpoint-ORIG-GUID: 4D_18gN-EoY2WhuW0LXdfPagmdNN8U92

On Mon, Oct 11, 2021 at 12:15:43PM -0700, Linus Torvalds wrote:
> On Mon, Oct 11, 2021 at 10:38 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > I cleaned up this patch [1] but I realised it still doesn't solve it.
> > The arm64 __copy_to_user_inatomic(), while ensuring progress if called
> > in a loop, it does not guarantee precise copy to the fault position.
> 
> That should be ok., We've always allowed the user copy to return early
> if it does word copies and hits a page crosser that causes a fault.
> 
> Any user then has the choice of:
> 
>  - partial copies are bad
> 
>  - partial copies are handled and then you retry from the place
> copy_to_user() failed at
> 
> and in that second case, the next time around, you'll get the fault
> immediately (or you'll make some more progress - maybe the user copy
> loop did something different just because the length and/or alignment
> was different).
> 
> If you get the fault immediately, that's -EFAULT.
> 
> And if you make some more progress, it's again up to the caller to
> rinse and repeat.
> 
> End result: user copy functions do not have to report errors exactly.
> It is the caller that has to handle the situation.
> 
> Most importantly: "exact error or not" doesn't actually _matter_ to
> the caller. If the caller does the right thing for an exact error, it
> will do the right thing for an inexact one too. See above.

Yes, that's my expectation (though fixed fairly recently in the arm64
user copy routines).

> > The copy_to_sk(), after returning an error, starts again from the previous
> > sizeof(sh) boundary rather than from where the __copy_to_user_inatomic()
> > stopped. So it can get stuck attempting to copy the same search header.
> 
> That seems to be purely a copy_to_sk() bug.
> 
> Or rather, it looks like a bug in the caller. copy_to_sk() itself does
> 
>                 if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
>                         ret = 0;
>                         goto out;
>                 }
> 
> and the comment says
> 
>          *  0: all items from this leaf copied, continue with next
> 
> but that comment is then obviously not actually true in that it's not
> "continue with next" at all.

The comments were correct before commit a48b73eca4ce ("btrfs: fix
potential deadlock in the search ioctl") which introduced the
potentially infinite loop.

Something like this would make the comments match (I think):

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cc61813213d8..1debf6a124e8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2161,7 +2161,7 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 		 * properly this next time through
 		 */
 		if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
-			ret = 0;
+			ret = -EFAULT;
 			goto out;
 		}

@@ -2175,7 +2175,7 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 			 */
 			if (read_extent_buffer_to_user_nofault(leaf, up,
 						item_off, item_len)) {
-				ret = 0;
+				ret = -EFAULT;
 				*sk_offset -= sizeof(sh);
 				goto out;
 			}
@@ -2260,12 +2260,8 @@ static noinline int search_ioctl(struct inode *inode,
 	key.type = sk->min_type;
 	key.offset = sk->min_offset;

-	while (1) {
-		ret = fault_in_pages_writeable(ubuf + sk_offset,
-					       *buf_size - sk_offset);
-		if (ret)
-			break;
-
+	ret = fault_in_pages_writeable(ubuf, *buf_size);
+	while (ret == 0) {
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
 		if (ret != 0) {
 			if (ret > 0)
@@ -2275,9 +2271,14 @@ static noinline int search_ioctl(struct inode *inode,
 		ret = copy_to_sk(path, &key, sk, buf_size, ubuf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
-		if (ret)
-			break;

+		/*
+		 * Fault in copy_to_sk(), attempt to bring the page in after
+		 * releasing the locks and retry.
+		 */
+		if (ret == -EFAULT)
+			ret = fault_in_pages_writeable(ubuf + sk_offset,
+				       sizeof(struct btrfs_ioctl_search_header));
 	}
 	if (ret > 0)
 		ret = 0;

> > An ugly fix is to fall back to byte by byte copying so that we can
> > attempt the actual fault address in fault_in_pages_writeable().
> 
> No, changing the user copy machinery is wrong. The caller really has
> to do the right thing with partial results.
> 
> And I think we need to make fault_in_pages_writeable() match the
> actual faulting cases - maybe remote the "pages" part of the name?

Ah, good point. Without removing "pages" from the name (too late over
here to grep the kernel), something like below:

diff --git a/arch/arm64/include/asm/page-def.h b/arch/arm64/include/asm/page-def.h
index 2403f7b4cdbf..3768ac4a6610 100644
--- a/arch/arm64/include/asm/page-def.h
+++ b/arch/arm64/include/asm/page-def.h
@@ -15,4 +15,9 @@
 #define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
+#ifdef CONFIG_ARM64_MTE
+#define FAULT_GRANULE_SIZE	(16)
+#define FAULT_GRANULE_MASK	(~(FAULT_GRANULE_SIZE-1))
+#endif
+
 #endif /* __ASM_PAGE_DEF_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 62db6b0176b9..7aef732e4fa7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -16,6 +16,11 @@
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
 
+#ifndef FAULT_GRANULE_SIZE
+#define FAULT_GRANULE_SIZE	PAGE_SIZE
+#define FAULT_GRANULE_MASK	PAGE_MASK
+#endif
+
 struct pagevec;
 
 static inline bool mapping_empty(struct address_space *mapping)
@@ -751,12 +756,12 @@ static inline int fault_in_pages_writeable(char __user *uaddr, size_t size)
 	do {
 		if (unlikely(__put_user(0, uaddr) != 0))
 			return -EFAULT;
-		uaddr += PAGE_SIZE;
+		uaddr += FAULT_GRANULE_SIZE;
 	} while (uaddr <= end);
 
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK))
+	/* Check whether the range spilled into the next granule. */
+	if (((unsigned long)uaddr & FAULT_GRANULE_MASK) ==
+			((unsigned long)end & FAULT_GRANULE_MASK))
 		return __put_user(0, end);
 
 	return 0;

If this looks in the right direction, I'll do some proper patches
tomorrow.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
