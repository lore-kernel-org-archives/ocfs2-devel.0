Return-Path: <SRS0=Mr1z=JJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A74C43461
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:49 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D29E6128C
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D29E6128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFEVkB081106;
	Mon, 12 Apr 2021 15:20:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 37u3ymc200-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Apr 2021 15:20:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFFR1i185469;
	Mon, 12 Apr 2021 15:20:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37unsr1yqq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 12 Apr 2021 15:20:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lVyMn-0003T5-Nk; Mon, 12 Apr 2021 08:20:45 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ritesh.list@gmail.com>) id 1lRvET-0007F1-1F
	for ocfs2-devel@oss.oracle.com; Thu, 01 Apr 2021 04:11:25 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	131BAhNp191552
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 11:11:24 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 37n2pac0dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 11:11:24 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	131B4WVt048914
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 11:11:24 GMT
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) by userp2040.oracle.com with ESMTP id 37n2a6tg52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 11:11:24 +0000
Received: by mail-pj1-f46.google.com with SMTP id
	j6-20020a17090adc86b02900cbfe6f2c96so847416pjv.1
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 04:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=f3T62p65u2S83DXPwAJqrEpWMg9bqfngCOlwnISjfa0=;
	b=abLc+HD5N7m1dpEMmsY7peCnhhMW2ilX+4/BFVEsTlAepS//BieG6tz17S79eUoJoG
	r5jyvheJj6vJFWtQodoEKQW7movi2RveMEjkum/L/TCFfAKhHWlnZYElekhqosAZB43l
	V0U11zizGBBSUA7KLqCDAYFzYrJ119gPUn7jQ1Am+32WdFpZ9+JlkFdQR8fc4K4Fcojq
	qC1r9i1MpE29E72Itmj9Co80p1wIdGHU63LdJT7E47xmKVm6Xwyvoz5VDeyL7cnKH5Sk
	mzdz7G/dwSVsm+aOTYu/lAP6Bg3tDHHYWWTxFlT+suIrne4CpBdtMtIrE3BzLeSNTzWZ
	8ryg==
X-Gm-Message-State: AOAM530uz0p8QAycs3GWiZPdhM3ssmmjjxZUI0K5WuSc1H8tDlU8+uKW
	O20Ai/v9zPkqQgEEaHb/M08=
X-Google-Smtp-Source: ABdhPJwd87RNzh+BfrCBf8eX/5dIR9xk4EAMKPeLjoBbOazcoZ79gljc2I3DoR3sYnn2r/fomTvxIg==
X-Received: by 2002:a17:90b:38f:: with SMTP id
	ga15mr8213179pjb.149.1617275482546; 
	Thu, 01 Apr 2021 04:11:22 -0700 (PDT)
Received: from localhost ([122.182.250.63]) by smtp.gmail.com with ESMTPSA id
	y15sm6499629pgi.31.2021.04.01.04.11.21
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 01 Apr 2021 04:11:22 -0700 (PDT)
Date: Thu, 1 Apr 2021 16:41:20 +0530
From: Ritesh Harjani <ritesh.list@gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210401111120.2ukog26aoyvyysyz@riteshh-domain>
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
	<20210319015237.993880-9-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319015237.993880-9-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 209.85.216.46
X-ServerName: mail-pj1-f46.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=249
	impostorscore=0
	suspectscore=0 lowpriorityscore=0 adultscore=0 priorityscore=335
	malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2103310000 definitions=main-2104010077
X-Spam: Clean
X-Mailman-Approved-At: Mon, 12 Apr 2021 08:20:43 -0700
Cc: Ritesh Harjani <ritesh.list@gmail.com>, jack@suse.cz,
        darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 08/10] fsdax: Dedup file range to use a
 compare function
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120100
X-Proofpoint-GUID: p5mSwyT0_W0DGO7XTVyAvkYFDqqxZWuM
X-Proofpoint-ORIG-GUID: p5mSwyT0_W0DGO7XTVyAvkYFDqqxZWuM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120100

On 21/03/19 09:52AM, Shiyang Ruan wrote:
> With dax we cannot deal with readpage() etc. So, we create a dax
> comparison funciton which is similar with
> vfs_dedupe_file_range_compare().
> And introduce dax_remap_file_range_prep() for filesystem use.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c             | 56 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/remap_range.c     | 45 ++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_reflink.c |  9 +++++--
>  include/linux/dax.h  |  4 ++++
>  include/linux/fs.h   | 15 ++++++++----
>  5 files changed, 115 insertions(+), 14 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 348297b38f76..76f81f1d76ec 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1833,3 +1833,59 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
>  	return dax_insert_pfn_mkwrite(vmf, pfn, order);
>  }
>  EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
> +
> +static loff_t dax_range_compare_actor(struct inode *ino1, loff_t pos1,
> +		struct inode *ino2, loff_t pos2, loff_t len, void *data,
> +		struct iomap *smap, struct iomap *dmap)
> +{
> +	void *saddr, *daddr;
> +	bool *same = data;
> +	int ret;
> +
> +	if (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE) {
> +		*same = true;
> +		return len;
> +	}
> +
> +	if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
> +		*same = false;
> +		return 0;
> +	}
> +
> +	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
> +				      &saddr, NULL);

shouldn't it take len as the second argument?

> +	if (ret < 0)
> +		return -EIO;
> +
> +	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
> +				      &daddr, NULL);

ditto.
> +	if (ret < 0)
> +		return -EIO;
> +
> +	*same = !memcmp(saddr, daddr, len);
> +	return len;
> +}
> +
> +int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
> +		struct inode *dest, loff_t destoff, loff_t len, bool *is_same,
> +		const struct iomap_ops *ops)
> +{
> +	int id, ret = 0;
> +
> +	id = dax_read_lock();
> +	while (len) {
> +		ret = iomap_apply2(src, srcoff, dest, destoff, len, 0, ops,
> +				   is_same, dax_range_compare_actor);
> +		if (ret < 0 || !*is_same)
> +			goto out;
> +
> +		len -= ret;
> +		srcoff += ret;
> +		destoff += ret;
> +	}
> +	ret = 0;
> +out:
> +	dax_read_unlock(id);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dax_dedupe_file_range_compare);
> diff --git a/fs/remap_range.c b/fs/remap_range.c
> index 77dba3a49e65..9079390edaf3 100644
> --- a/fs/remap_range.c
> +++ b/fs/remap_range.c
> @@ -14,6 +14,7 @@
>  #include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/fs.h>
> +#include <linux/dax.h>
>  #include "internal.h"
>
>  #include <linux/uaccess.h>
> @@ -199,9 +200,9 @@ static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
>   * Compare extents of two files to see if they are the same.
>   * Caller must have locked both inodes to prevent write races.
>   */
> -static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
> -					 struct inode *dest, loff_t destoff,
> -					 loff_t len, bool *is_same)
> +int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
> +				  struct inode *dest, loff_t destoff,
> +				  loff_t len, bool *is_same)
>  {
>  	loff_t src_poff;
>  	loff_t dest_poff;
> @@ -280,6 +281,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  out_error:
>  	return error;
>  }
> +EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
>
>  /*
>   * Check that the two inodes are eligible for cloning, the ranges make
> @@ -289,9 +291,11 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>   * If there's an error, then the usual negative error code is returned.
>   * Otherwise returns 0 with *len set to the request length.
>   */
> -int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> -				  struct file *file_out, loff_t pos_out,
> -				  loff_t *len, unsigned int remap_flags)
> +static int
> +__generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				loff_t *len, unsigned int remap_flags,
> +				const struct iomap_ops *ops)
>  {
>  	struct inode *inode_in = file_inode(file_in);
>  	struct inode *inode_out = file_inode(file_out);
> @@ -351,8 +355,15 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  	if (remap_flags & REMAP_FILE_DEDUP) {
>  		bool		is_same = false;
>
> -		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
> -				inode_out, pos_out, *len, &is_same);
> +		if (!IS_DAX(inode_in) && !IS_DAX(inode_out))
> +			ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
> +					inode_out, pos_out, *len, &is_same);
> +		else if (IS_DAX(inode_in) && IS_DAX(inode_out) && ops)
> +			ret = dax_dedupe_file_range_compare(inode_in, pos_in,
> +					inode_out, pos_out, *len, &is_same,
> +					ops);
> +		else
> +			return -EINVAL;
>  		if (ret)
>  			return ret;
>  		if (!is_same)

should we consider to check !is_same check b4?
you should maybe relook at this error handling side of code.
we still return len from actor function but is_same is set to false.
So we are essentially returning ret (positive value), instead should be
returning -EBADE because of !memcmp

> @@ -370,6 +381,24 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>
>  	return ret;
>  }
> +
> +int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> +			      struct file *file_out, loff_t pos_out,
> +			      loff_t *len, unsigned int remap_flags,
> +			      const struct iomap_ops *ops)
> +{
> +	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
> +					       pos_out, len, remap_flags, ops);
> +}
> +EXPORT_SYMBOL(dax_remap_file_range_prep);
> +
> +int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> +				  struct file *file_out, loff_t pos_out,
> +				  loff_t *len, unsigned int remap_flags)
> +{
> +	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
> +					       pos_out, len, remap_flags, NULL);
> +}
>  EXPORT_SYMBOL(generic_remap_file_range_prep);
>
>  loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 6fa05fb78189..f5b3a3da36b7 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1308,8 +1308,13 @@ xfs_reflink_remap_prep(
>  	if (IS_DAX(inode_in) || IS_DAX(inode_out))
>  		goto out_unlock;
>
> -	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
> -			len, remap_flags);
> +	if (IS_DAX(inode_in))

if (!IS_DAX(inode_in)) no?

> +		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
> +						    pos_out, len, remap_flags);
> +	else
> +		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
> +						pos_out, len, remap_flags,
> +						&xfs_read_iomap_ops);
>  	if (ret || *len == 0)
>  		goto out_unlock;
>
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 3275e01ed33d..32e1c34349f2 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -239,6 +239,10 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  				      pgoff_t index);
>  s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap,
>  		struct iomap *srcmap);
> +int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
> +				  struct inode *dest, loff_t destoff,
> +				  loff_t len, bool *is_same,
> +				  const struct iomap_ops *ops);
>  static inline bool dax_mapping(struct address_space *mapping)
>  {
>  	return mapping->host && IS_DAX(mapping->host);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index fd47deea7c17..2e6ec5bdf82a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -68,6 +68,7 @@ struct fsverity_info;
>  struct fsverity_operations;
>  struct fs_context;
>  struct fs_parameter_spec;
> +struct iomap_ops;
>
>  extern void __init inode_init(void);
>  extern void __init inode_init_early(void);
> @@ -1910,13 +1911,19 @@ extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
>  extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
>  extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
>  				   loff_t, size_t, unsigned int);
> +typedef int (*compare_range_t)(struct inode *src, loff_t srcpos,
> +			       struct inode *dest, loff_t destpos,
> +			       loff_t len, bool *is_same);

Is this used anywhere?

>  extern ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
>  				       struct file *file_out, loff_t pos_out,
>  				       size_t len, unsigned int flags);
> -extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> -					 struct file *file_out, loff_t pos_out,
> -					 loff_t *count,
> -					 unsigned int remap_flags);
> +int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> +				  struct file *file_out, loff_t pos_out,
> +				  loff_t *count, unsigned int remap_flags);
> +int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> +			      struct file *file_out, loff_t pos_out,
> +			      loff_t *len, unsigned int remap_flags,
> +			      const struct iomap_ops *ops);
>  extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>  				  struct file *file_out, loff_t pos_out,
>  				  loff_t len, unsigned int remap_flags);
> --
> 2.30.1
>
>
>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
