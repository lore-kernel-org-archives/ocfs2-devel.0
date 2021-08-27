Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78A6C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:29:03 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 695AD60F58
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 695AD60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESxb1019337;
	Mon, 13 Sep 2021 14:29:03 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1jkjava4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:29:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DED9I9133858;
	Mon, 13 Sep 2021 14:28:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b0hjtjvr0-1;
	Mon, 13 Sep 2021 14:28:48 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwx-0004bA-Ka; Mon, 13 Sep 2021 07:28:47 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <kari.argillander@gmail.com>) id 1mJiuB-0007hH-Oy
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 13:56:51 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RKtob9007355
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 20:56:51 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ajpm5bktb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 20:56:51 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RIk5iH015147
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 20:56:50 GMT
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
	[209.85.208.178])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq08un40a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 20:56:49 +0000
Received: by mail-lj1-f178.google.com with SMTP id w4so13593017ljh.13
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 13:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=D1T7WfWNcvzH9Rk51aqcudHNYK1tsZ5bySC0AdDjdzY=;
	b=VXYj1EQ2LRq4ztCCXc0lZFwhCZD/S+d7Lh6ZGHwUDHWYZ1gyev4h0878EeIhVzFyBR
	G4M1J0wk7RTN5Z3kJENEfxIFIuE6n+e4cg6cGmTccs+FQ+gANJDeu8RE/4tnHa6Ewq3L
	r27fpkEVHWzEBq7vmT11sx3FtxV/bD7L4JSVF4u54WmAbdZhlEclhJwuGqRENbzFGsnr
	ZjM87fXJod0TClxU68SwQNjkDIlNGLqraqIrEogkwbp+lOpIPvqPeTXdDJmoTsgPW59h
	n9qZlDzdALut4w7KyyVUwfhrU11P6pJJ9ZXljASvtMICzbCB+rIaEtjsHrhWu0ewAcCg
	CiVQ==
X-Gm-Message-State: AOAM530r7Yj/euIwL7gjnlK3r+vZevWCLLd0uhDKtc4AM6qrIL/dihkA
	V5t/+QMY5zWLBq5LX18Fe58=
X-Google-Smtp-Source: ABdhPJwCJ2OaAUF4gAyq/jrqfb/W8br/EFdiBn99hCJwKvuif4qcT7IwmOBkVG9J+AGjgGor/tS0Ow==
X-Received: by 2002:a2e:bc1a:: with SMTP id b26mr9289762ljf.218.1630097807229; 
	Fri, 27 Aug 2021 13:56:47 -0700 (PDT)
Received: from kari-VirtualBox (87-95-21-3.bb.dnainternet.fi. [87.95.21.3])
	by smtp.gmail.com with ESMTPSA id f9sm687906lfg.143.2021.08.27.13.56.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 27 Aug 2021 13:56:46 -0700 (PDT)
Date: Fri, 27 Aug 2021 23:56:44 +0300
From: Kari Argillander <kari.argillander@gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Message-ID: <20210827205644.lkihrypv27er5km3@kari-VirtualBox>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-5-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210827164926.1726765-5-agruenba@redhat.com>
X-Source-IP: 209.85.208.178
X-ServerName: mail-lj1-f178.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	adultscore=0 clxscore=318
	malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
	priorityscore=345 mlxscore=0 suspectscore=0 spamscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270123
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270123
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 04/19] iov_iter: Turn
 iov_iter_fault_in_readable into fault_in_iov_iter_readable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-GUID: Waog3eMZQUTbHX84Dov1DueM8c2YhaF4
X-Proofpoint-ORIG-GUID: Waog3eMZQUTbHX84Dov1DueM8c2YhaF4

On Fri, Aug 27, 2021 at 06:49:11PM +0200, Andreas Gruenbacher wrote:
> Turn iov_iter_fault_in_readable into a function that returns the number
> of bytes not faulted in (similar to copy_to_user) instead of returning a
> non-zero value when any of the requested pages couldn't be faulted in.
> This supports the existing users that require all pages to be faulted in
> as well as new users that are happy if any pages can be faulted in at
> all.
> 
> Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
> sure that this change doesn't silently break things.

At least this patch will break ntfs3 which is in next. It has been there
just couple weeks so I understand. I added Konstantin and ntfs3 list so
that we know what is going on. Can you please info if and when do we
need rebase.

We are in situation that ntfs3 might get in 5.15, but it is uncertain so
it would be best that we solve this. Just info is enough.

Argillander

> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/btrfs/file.c        |  2 +-
>  fs/f2fs/file.c         |  2 +-
>  fs/fuse/file.c         |  2 +-
>  fs/iomap/buffered-io.c |  2 +-
>  fs/ntfs/file.c         |  2 +-
>  include/linux/uio.h    |  2 +-
>  lib/iov_iter.c         | 33 +++++++++++++++++++++------------
>  mm/filemap.c           |  2 +-
>  8 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index ee34497500e1..281c77cfe91a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1698,7 +1698,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>  		 * Fault pages before locking them in prepare_pages
>  		 * to avoid recursive lock
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
> +		if (unlikely(fault_in_iov_iter_readable(i, write_bytes))) {
>  			ret = -EFAULT;
>  			break;
>  		}
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 6afd4562335f..b04b6c909a8b 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -4259,7 +4259,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		size_t target_size = 0;
>  		int err;
>  
> -		if (iov_iter_fault_in_readable(from, iov_iter_count(from)))
> +		if (fault_in_iov_iter_readable(from, iov_iter_count(from)))
>  			set_inode_flag(inode, FI_NO_PREALLOC);
>  
>  		if ((iocb->ki_flags & IOCB_NOWAIT)) {
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 97f860cfc195..da49ef71dab5 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1160,7 +1160,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
>  
>   again:
>  		err = -EFAULT;
> -		if (iov_iter_fault_in_readable(ii, bytes))
> +		if (fault_in_iov_iter_readable(ii, bytes))
>  			break;
>  
>  		err = -ENOMEM;
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 87ccb3438bec..7dc42dd3a724 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -749,7 +749,7 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		 * same page as we're writing to, without it being marked
>  		 * up-to-date.
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> +		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
>  			status = -EFAULT;
>  			break;
>  		}
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index ab4f3362466d..a43adeacd930 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -1829,7 +1829,7 @@ static ssize_t ntfs_perform_write(struct file *file, struct iov_iter *i,
>  		 * pages being swapped out between us bringing them into memory
>  		 * and doing the actual copying.
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> +		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
>  			status = -EFAULT;
>  			break;
>  		}
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 82c3c3e819e0..12d30246c2e9 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -119,7 +119,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
>  				  size_t bytes, struct iov_iter *i);
>  void iov_iter_advance(struct iov_iter *i, size_t bytes);
>  void iov_iter_revert(struct iov_iter *i, size_t bytes);
> -int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes);
> +size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
>  size_t iov_iter_single_seg_count(const struct iov_iter *i);
>  size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
>  			 struct iov_iter *i);
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 069cedd9d7b4..082ab155496d 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -430,33 +430,42 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
>  }
>  
>  /*
> + * fault_in_iov_iter_readable - fault in iov iterator for reading
> + * @i: iterator
> + * @size: maximum length
> + *
>   * Fault in one or more iovecs of the given iov_iter, to a maximum length of
> - * bytes.  For each iovec, fault in each page that constitutes the iovec.
> + * @size.  For each iovec, fault in each page that constitutes the iovec.
> + *
> + * Returns the number of bytes not faulted in (like copy_to_user() and
> + * copy_from_user()).
>   *
> - * Return 0 on success, or non-zero if the memory could not be accessed (i.e.
> - * because it is an invalid address).
> + * Always returns 0 for non-userspace iterators.
>   */
> -int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
> +size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
>  {
>  	if (iter_is_iovec(i)) {
> +		size_t count = min(size, iov_iter_count(i));
>  		const struct iovec *p;
>  		size_t skip;
>  
> -		if (bytes > i->count)
> -			bytes = i->count;
> -		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
> -			size_t len = min(bytes, p->iov_len - skip);
> +		size -= count;
> +		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
> +			size_t len = min(count, p->iov_len - skip);
> +			size_t ret;
>  
>  			if (unlikely(!len))
>  				continue;
> -			if (fault_in_readable(p->iov_base + skip, len))
> -				return -EFAULT;
> -			bytes -= len;
> +			ret = fault_in_readable(p->iov_base + skip, len);
> +			count -= len - ret;
> +			if (ret)
> +				break;
>  		}
> +		return count + size;
>  	}
>  	return 0;
>  }
> -EXPORT_SYMBOL(iov_iter_fault_in_readable);
> +EXPORT_SYMBOL(fault_in_iov_iter_readable);
>  
>  void iov_iter_init(struct iov_iter *i, unsigned int direction,
>  			const struct iovec *iov, unsigned long nr_segs,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4dec3bc7752e..83af8a534339 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3643,7 +3643,7 @@ ssize_t generic_perform_write(struct file *file,
>  		 * same page as we're writing to, without it being marked
>  		 * up-to-date.
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> +		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
>  			status = -EFAULT;
>  			break;
>  		}
> -- 
> 2.26.3
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
