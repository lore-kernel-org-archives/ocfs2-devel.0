Return-Path: <SRS0=T5gl=PH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D176FC4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:51:13 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7833961154
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:51:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7833961154
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JFIinb002884;
	Tue, 19 Oct 2021 15:51:12 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsrefbd1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 15:51:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFjWuK163612;
	Tue, 19 Oct 2021 15:51:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gskxpm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 19 Oct 2021 15:51:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mcrOP-0008Sx-Uv; Tue, 19 Oct 2021 08:51:09 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1mcrOO-0008SN-So
	for ocfs2-devel@oss.oracle.com; Tue, 19 Oct 2021 08:51:08 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFkm6G035338
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:08 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bqmsf0xmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:08 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19JFmn0p017130
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:08 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bsgx6kn48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:07 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id E548D610C7;
	Tue, 19 Oct 2021 15:51:05 +0000 (UTC)
Date: Tue, 19 Oct 2021 08:51:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <20211019155105.GA24248@magnolia>
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<20211019134204.3382645-15-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211019134204.3382645-15-agruenba@redhat.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 14/17] iomap: Add done_before argument
	to iomap_dio_rw
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190094
X-Proofpoint-GUID: 4ElwSj_vMxrv55H7sNEZuBPpr3YqLJJH
X-Proofpoint-ORIG-GUID: 4ElwSj_vMxrv55H7sNEZuBPpr3YqLJJH

On Tue, Oct 19, 2021 at 03:42:01PM +0200, Andreas Gruenbacher wrote:
> Add a done_before argument to iomap_dio_rw that indicates how much of
> the request has already been transferred.  When the request succeeds, we
> report that done_before additional bytes were tranferred.  This is
> useful for finishing a request asynchronously when part of the request
> has already been completed synchronously.
> 
> We'll use that to allow iomap_dio_rw to be used with page faults
> disabled: when a page fault occurs while submitting a request, we
> synchronously complete the part of the request that has already been
> submitted.  The caller can then take care of the page fault and call
> iomap_dio_rw again for the rest of the request, passing in the number of
> bytes already tranferred.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/btrfs/file.c       |  5 +++--
>  fs/erofs/data.c       |  2 +-
>  fs/ext4/file.c        |  5 +++--
>  fs/gfs2/file.c        |  4 ++--
>  fs/iomap/direct-io.c  | 11 ++++++++---
>  fs/xfs/xfs_file.c     |  6 +++---
>  fs/zonefs/super.c     |  4 ++--
>  include/linux/iomap.h |  4 ++--
>  8 files changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f37211d3bb69..9d41b28c67ba 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1957,7 +1957,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	}
>  
>  	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
> -			     0);
> +			     0, 0);
>  
>  	btrfs_inode_unlock(inode, ilock_flags);
>  
> @@ -3658,7 +3658,8 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
>  		return 0;
>  
>  	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
> -	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops, 0);
> +	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
> +			   0, 0);
>  	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>  	return ret;
>  }
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 9db829715652..16a41d0db55a 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -287,7 +287,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  
>  		if (!err)
>  			return iomap_dio_rw(iocb, to, &erofs_iomap_ops,
> -					    NULL, 0);
> +					    NULL, 0, 0);
>  		if (err < 0)
>  			return err;
>  	}
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index ac0e11bbb445..b25c1f8f7c4f 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -74,7 +74,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		return generic_file_read_iter(iocb, to);
>  	}
>  
> -	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0);
> +	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, 0);
>  	inode_unlock_shared(inode);
>  
>  	file_accessed(iocb->ki_filp);
> @@ -566,7 +566,8 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	if (ilock_shared)
>  		iomap_ops = &ext4_iomap_overwrite_ops;
>  	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
> -			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0);
> +			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0,
> +			   0);
>  	if (ret == -ENOTBLK)
>  		ret = 0;
>  
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index b07b9c2d0446..ae06defcf369 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -822,7 +822,7 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
>  	if (ret)
>  		goto out_uninit;
>  
> -	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0);
> +	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
>  	gfs2_glock_dq(gh);
>  out_uninit:
>  	gfs2_holder_uninit(gh);
> @@ -856,7 +856,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
>  	if (offset + len > i_size_read(&ip->i_inode))
>  		goto out;
>  
> -	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0);
> +	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
>  	if (ret == -ENOTBLK)
>  		ret = 0;
>  out:
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index a434fb7887b2..fdf68339bc8b 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -31,6 +31,7 @@ struct iomap_dio {
>  	atomic_t		ref;
>  	unsigned		flags;
>  	int			error;
> +	size_t			done_before;

I have basically the same comment as last time[1]:

"So, now that I actually understand the reason why the count of
previously transferred bytes has to be passed into the iomap_dio, I
would like this field to have a comment so that stupid maintainers like
me don't forget the subtleties again:

        /*
	 * For asynchronous IO, we have one chance to call the iocb
	 * completion method with the results of the directio operation.
	 * If this operation is a resubmission after a previous partial
	 * completion (e.g. page fault), we need to know about that
	 * progress so that we can report both the results of the prior
	 * completion and the result of the resubmission to the iocb
	 * submitter.
         */
        size_t                  done_before;

With that added, I think I can live with this enough to:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

[1] https://lore.kernel.org/linux-fsdevel/20210903185351.GD9892@magnolia/

>  	bool			wait_for_completion;
>  
>  	union {
> @@ -124,6 +125,9 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  	if (ret > 0 && (dio->flags & IOMAP_DIO_NEED_SYNC))
>  		ret = generic_write_sync(iocb, ret);
>  
> +	if (ret > 0)
> +		ret += dio->done_before;
> +
>  	kfree(dio);
>  
>  	return ret;
> @@ -456,7 +460,7 @@ static loff_t iomap_dio_iter(const struct iomap_iter *iter,
>  struct iomap_dio *
>  __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> -		unsigned int dio_flags)
> +		unsigned int dio_flags, size_t done_before)
>  {
>  	struct address_space *mapping = iocb->ki_filp->f_mapping;
>  	struct inode *inode = file_inode(iocb->ki_filp);
> @@ -486,6 +490,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	dio->dops = dops;
>  	dio->error = 0;
>  	dio->flags = 0;
> +	dio->done_before = done_before;
>  
>  	dio->submit.iter = iter;
>  	dio->submit.waiter = current;
> @@ -652,11 +657,11 @@ EXPORT_SYMBOL_GPL(__iomap_dio_rw);
>  ssize_t
>  iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> -		unsigned int dio_flags)
> +		unsigned int dio_flags, size_t done_before)
>  {
>  	struct iomap_dio *dio;
>  
> -	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags);
> +	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, done_before);
>  	if (IS_ERR_OR_NULL(dio))
>  		return PTR_ERR_OR_ZERO(dio);
>  	return iomap_dio_complete(dio);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7aa943edfc02..240eb932c014 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -259,7 +259,7 @@ xfs_file_dio_read(
>  	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
>  	if (ret)
>  		return ret;
> -	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0);
> +	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, 0);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
>  	return ret;
> @@ -569,7 +569,7 @@ xfs_file_dio_write_aligned(
>  	}
>  	trace_xfs_file_direct_write(iocb, from);
>  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> -			   &xfs_dio_write_ops, 0);
> +			   &xfs_dio_write_ops, 0, 0);
>  out_unlock:
>  	if (iolock)
>  		xfs_iunlock(ip, iolock);
> @@ -647,7 +647,7 @@ xfs_file_dio_write_unaligned(
>  
>  	trace_xfs_file_direct_write(iocb, from);
>  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> -			   &xfs_dio_write_ops, flags);
> +			   &xfs_dio_write_ops, flags, 0);
>  
>  	/*
>  	 * Retry unaligned I/O with exclusive blocking semantics if the DIO
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index ddc346a9df9b..6122c38ab44d 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -852,7 +852,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
>  		ret = zonefs_file_dio_append(iocb, from);
>  	else
>  		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
> -				   &zonefs_write_dio_ops, 0);
> +				   &zonefs_write_dio_ops, 0, 0);
>  	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
>  	    (ret > 0 || ret == -EIOCBQUEUED)) {
>  		if (ret > 0)
> @@ -987,7 +987,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		}
>  		file_accessed(iocb->ki_filp);
>  		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
> -				   &zonefs_read_dio_ops, 0);
> +				   &zonefs_read_dio_ops, 0, 0);
>  	} else {
>  		ret = generic_file_read_iter(iocb, to);
>  		if (ret == -EIO)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 2a213b0d1e1f..829f2325ecba 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -339,10 +339,10 @@ struct iomap_dio_ops {
>  
>  ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> -		unsigned int dio_flags);
> +		unsigned int dio_flags, size_t done_before);
>  struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
> -		unsigned int dio_flags);
> +		unsigned int dio_flags, size_t done_before);
>  ssize_t iomap_dio_complete(struct iomap_dio *dio);
>  int iomap_dio_iopoll(struct kiocb *kiocb, bool spin);
>  
> -- 
> 2.26.3
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
