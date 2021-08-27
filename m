Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA41C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:15:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B193760FD8
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B193760FD8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RHGUBs025353;
	Fri, 27 Aug 2021 19:15:12 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvgpc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 19:15:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RJBeL9053283;
	Fri, 27 Aug 2021 19:15:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb92n886-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 19:15:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJhDf-0002ZN-2C; Fri, 27 Aug 2021 12:08:51 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1mJhDc-0002Z5-93
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 12:08:48 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RJ5ol3083670
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:08:47 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3ajpm56y76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:08:47 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RIk5sd032111
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:08:46 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq5m1g872-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:08:46 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mJhDO-00GZVm-U4; Fri, 27 Aug 2021 19:08:34 +0000
Date: Fri, 27 Aug 2021 19:08:34 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YSk4Mvbyp8lxPfPF@zeniv-ca.linux.org.uk>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-4-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210827164926.1726765-4-agruenba@redhat.com>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 mlxlogscore=999
	phishscore=0 spamscore=0 priorityscore=181 malwarescore=0 bulkscore=0
	impostorscore=0 clxscore=278 adultscore=0 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108270111 domainage_hfrom=9157
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270111
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 03/19] gup: Turn
 fault_in_pages_{readable, writeable} into fault_in_{readable, writeable}
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
 definitions=main-2108270112
X-Proofpoint-GUID: nKhvDaWxktIsTAEsNZP-PpPJHBffDpLt
X-Proofpoint-ORIG-GUID: nKhvDaWxktIsTAEsNZP-PpPJHBffDpLt

On Fri, Aug 27, 2021 at 06:49:10PM +0200, Andreas Gruenbacher wrote:
> Turn fault_in_pages_{readable,writeable} into versions that return the
> number of bytes not faulted in (similar to copy_to_user) instead of
> returning a non-zero value when any of the requested pages couldn't be
> faulted in.  This supports the existing users that require all pages to
> be faulted in as well as new users that are happy if any pages can be
> faulted in at all.
> 
> Neither of these functions is entirely trivial and it doesn't seem
> useful to inline them, so move them to mm/gup.c.
> 
> Rename the functions to fault_in_{readable,writeable} to make sure that
> this change doesn't silently break things.

I'm sorry, but this is wrong.  The callers need to be reviewed and
sanitized.  You have several oddball callers (most of them simply
wrong) *and* the ones on a very hot path in write(2).  And _there_
the existing behaviour does the wrong thing for memory poisoning setups.

	Do we have *any* cases where we both need the fault-in at all *and*
would not be better off with "fail only if the first byte couldn't have been
faulted in"?

> diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
> index 0608581967f0..38c3eae40c14 100644
> --- a/arch/powerpc/kernel/signal_32.c
> +++ b/arch/powerpc/kernel/signal_32.c
> @@ -1048,7 +1048,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
>  	if (new_ctx == NULL)
>  		return 0;
>  	if (!access_ok(new_ctx, ctx_size) ||
> -	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
> +	    fault_in_readable((char __user *)new_ctx, ctx_size))
>  		return -EFAULT;

This is completely pointless.  Look at do_setcontext() there.  Seriously,
it immediately does
        if (!user_read_access_begin(ucp, sizeof(*ucp)))
			return -EFAULT;
so this access_ok() is so much garbage.  Then it does normal unsage_get_...()
stuff, so it doesn't need that fault-in crap at all - it *must* handle
copyin failures, fault-in or not.  Just lose that fault_in_... call and be
done with that.


> @@ -1237,7 +1237,7 @@ SYSCALL_DEFINE3(debug_setcontext, struct ucontext __user *, ctx,
>  #endif
>  
>  	if (!access_ok(ctx, sizeof(*ctx)) ||
> -	    fault_in_pages_readable((u8 __user *)ctx, sizeof(*ctx)))
> +	    fault_in_readable((char __user *)ctx, sizeof(*ctx)))
>  		return -EFAULT;

Ditto.

> diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
> index 1831bba0582e..9f471b4a11e3 100644
> --- a/arch/powerpc/kernel/signal_64.c
> +++ b/arch/powerpc/kernel/signal_64.c
> @@ -688,7 +688,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
>  	if (new_ctx == NULL)
>  		return 0;
>  	if (!access_ok(new_ctx, ctx_size) ||
> -	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
> +	    fault_in_readable((char __user *)new_ctx, ctx_size))
>  		return -EFAULT;

... and again.

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0ba98e08a029..9233ecc31e2e 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2244,9 +2244,8 @@ static noinline int search_ioctl(struct inode *inode,
>  	key.offset = sk->min_offset;
>  
>  	while (1) {
> -		ret = fault_in_pages_writeable(ubuf + sk_offset,
> -					       *buf_size - sk_offset);
> -		if (ret)
> +		ret = -EFAULT;
> +		if (fault_in_writeable(ubuf + sk_offset, *buf_size - sk_offset))
>  			break;

Really?

> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 25dfc48536d7..069cedd9d7b4 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -191,7 +191,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
>  	buf = iov->iov_base + skip;
>  	copy = min(bytes, iov->iov_len - skip);
>  
> -	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_writeable(buf, copy)) {
> +	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_writeable(buf, copy)) {

Here we definitely want "fail only if nothing could be faulted in"

>  		kaddr = kmap_atomic(page);
>  		from = kaddr + offset;
>  
> @@ -275,7 +275,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
>  	buf = iov->iov_base + skip;
>  	copy = min(bytes, iov->iov_len - skip);
>  
> -	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
> +	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_readable(buf, copy)) {

Same.

> @@ -446,13 +446,11 @@ int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
>  			bytes = i->count;
>  		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
>  			size_t len = min(bytes, p->iov_len - skip);
> -			int err;
>  
>  			if (unlikely(!len))
>  				continue;
> -			err = fault_in_pages_readable(p->iov_base + skip, len);
> -			if (unlikely(err))
> -				return err;
> +			if (fault_in_readable(p->iov_base + skip, len))
> +				return -EFAULT;

... and the same, except that here we want failure only if nothing had already
been faulted in.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
