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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F48C433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:49 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D736611F0
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D736611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFEQ0S081056;
	Mon, 12 Apr 2021 15:20:47 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 37u3ymc1yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Apr 2021 15:20:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFFQc7185365;
	Mon, 12 Apr 2021 15:20:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37unsr1yqj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 12 Apr 2021 15:20:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lVyMn-0003Rc-Fd; Mon, 12 Apr 2021 08:20:45 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ritesh.list@gmail.com>) id 1lRqzR-0000ng-Mu
	for ocfs2-devel@oss.oracle.com; Wed, 31 Mar 2021 23:39:37 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1316RbV5177558
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 06:39:37 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 37n2asbpqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 06:39:37 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1316YUZk026086
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 06:39:37 GMT
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) by userp2040.oracle.com with ESMTP id 37n2a6pdk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 06:39:36 +0000
Received: by mail-pj1-f46.google.com with SMTP id
	k23-20020a17090a5917b02901043e35ad4aso2543876pji.3
	for <ocfs2-devel@oss.oracle.com>; Wed, 31 Mar 2021 23:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Cdhn3hlT1LofiWiq9NSsZXRFtnuTmpkFOIZBKIG5BiA=;
	b=WWFS5XbS8VNT9NCkTJlCAG56iExb6l92fo//H3b3jVkL+8SPDzKyu31MVjYMW1+qPQ
	VHQj5kEXV0jTXr4n9CCgRytYHwk+mGfCN+OrCoC+drpelAgPJQ6ceFmP3EYmWrS8dvx/
	mruXQUX5QByyi32SpZ8AWdDiwcD2aDAkxWZ5miPJqphRprzAoiznnHJdWCpJVWH2VcAQ
	r8zx3So/6yE5Tn7qsp1AF7cElby/MczNy9+E3yfAv0A1KeM9NueRMAq+1WX6ebUQFpSt
	hkNWoK3vedfRRLRtxsxyccVJfiMLDvl2XLuxH8ltlzYO4uQzZdX4UvSa1fs0ygwboEOS
	2YNw==
X-Gm-Message-State: AOAM5336AZRxjBZ5SueIcNMt4XQrCVcN/Qa7cv7NHoQtwxd+TcPLJxqE
	n0YODH1yhf6M3i1dXU7oIZA=
X-Google-Smtp-Source: ABdhPJxV7qnJmiKTK7vMsVhFFpLWa9nVg5l0P/yHHXGvs45jJWGW4/3YJNYe6mcpuHqq0YLrqeBnjw==
X-Received: by 2002:a17:90a:990a:: with SMTP id
	b10mr7368818pjp.178.1617259175255; 
	Wed, 31 Mar 2021 23:39:35 -0700 (PDT)
Received: from localhost ([122.182.250.63]) by smtp.gmail.com with ESMTPSA id
	w26sm4326195pfj.58.2021.03.31.23.39.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 31 Mar 2021 23:39:34 -0700 (PDT)
Date: Thu, 1 Apr 2021 12:09:32 +0530
From: Ritesh Harjani <ritesh.list@gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210401063932.tro7a4hhy25zdmho@riteshh-domain>
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
	<20210319015237.993880-6-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319015237.993880-6-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 209.85.216.46
X-ServerName: mail-pj1-f46.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=250
	impostorscore=0
	suspectscore=0 lowpriorityscore=0 adultscore=0 priorityscore=341
	malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2103310000 definitions=main-2104010046
X-Spam: Clean
X-Mailman-Approved-At: Mon, 12 Apr 2021 08:20:43 -0700
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 05/10] fsdax: Replace mmap entry in
	case of CoW
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
X-Proofpoint-GUID: xwuDRctuld6A3SoEczaP-YdCC-4kS3NZ
X-Proofpoint-ORIG-GUID: xwuDRctuld6A3SoEczaP-YdCC-4kS3NZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120100

On 21/03/19 09:52AM, Shiyang Ruan wrote:
> We replace the existing entry to the newly allocated one in case of CoW.
> Also, we mark the entry as PAGECACHE_TAG_TOWRITE so writeback marks this
> entry as writeprotected.  This helps us snapshots so new write
> pagefaults after snapshots trigger a CoW.
>

Please correct me here. So the flow is like this.
1. In case of CoW or a reflinked file, on an mmaped file if write is attempted,
   Then in DAX fault handler code, ->iomap_begin() on a given filesystem will
   populate iomap and srcmap. srcmap being from where the read needs to be
   attempted from and iomap on where the new write should go to.
2. So the dax_insert_entry() code as part of the fault handling will take care
   of removing the old entry and inserting the new pfn entry to xas and mark
   it with PAGECACHE_TAG_TOWRITE so that dax writeback can mark the entry as
   write protected.
Is my above understanding correct?

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 181aad97136a..cfe513eb111e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -722,6 +722,9 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
>  	return 0;
>  }
>
> +#define DAX_IF_DIRTY		(1 << 0)
> +#define DAX_IF_COW		(1 << 1)
> +
>
small comment expalining this means DAX insert flags used in dax_insert_entry()

>
>  /*
>   * By this point grab_mapping_entry() has ensured that we have a locked entry
>   * of the appropriate size so we don't have to worry about downgrading PMDs to
> @@ -729,16 +732,19 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
>   * already in the tree, we will skip the insertion and just dirty the PMD as
>   * appropriate.
>   */
> -static void *dax_insert_entry(struct xa_state *xas,
> -		struct address_space *mapping, struct vm_fault *vmf,
> -		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
> +static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
> +		void *entry, pfn_t pfn, unsigned long flags,
> +		unsigned int insert_flags)
>  {
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>  	void *new_entry = dax_make_entry(pfn, flags);
> +	bool dirty = insert_flags & DAX_IF_DIRTY;
> +	bool cow = insert_flags & DAX_IF_COW;
>
>  	if (dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>
> -	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
> +	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
>  		unsigned long index = xas->xa_index;
>  		/* we are replacing a zero page with block mapping */
>  		if (dax_is_pmd_entry(entry))
> @@ -750,7 +756,7 @@ static void *dax_insert_entry(struct xa_state *xas,
>
>  	xas_reset(xas);
>  	xas_lock_irq(xas);
> -	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
> +	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
>  		void *old;
>
>  		dax_disassociate_entry(entry, mapping, false);
> @@ -774,6 +780,9 @@ static void *dax_insert_entry(struct xa_state *xas,
>  	if (dirty)
>  		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
>
> +	if (cow)
> +		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
> +
>  	xas_unlock_irq(xas);
>  	return entry;
>  }
> @@ -1098,8 +1107,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
>  	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
>  	vm_fault_t ret;
>
> -	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_ZERO_PAGE, false);
> +	*entry = dax_insert_entry(xas, vmf, *entry, pfn, DAX_ZERO_PAGE, 0);
>
>  	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
>  	trace_dax_load_hole(inode, vmf, ret);
> @@ -1126,8 +1134,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  		goto fallback;
>
>  	pfn = page_to_pfn_t(zero_page);
> -	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_PMD | DAX_ZERO_PAGE, false);
> +	*entry = dax_insert_entry(xas, vmf, *entry, pfn,
> +				  DAX_PMD | DAX_ZERO_PAGE, 0);
>
>  	if (arch_needs_pgtable_deposit()) {
>  		pgtable = pte_alloc_one(vma->vm_mm);
> @@ -1431,6 +1439,7 @@ static vm_fault_t dax_fault_actor(struct vm_fault *vmf, pfn_t *pfnp,
>  	loff_t pos = (loff_t)xas->xa_offset << PAGE_SHIFT;
>  	bool write = vmf->flags & FAULT_FLAG_WRITE;
>  	bool sync = dax_fault_is_synchronous(flags, vmf->vma, iomap);
> +	unsigned int insert_flags = 0;
>  	int err = 0;
>  	pfn_t pfn;
>  	void *kaddr;
> @@ -1453,8 +1462,14 @@ static vm_fault_t dax_fault_actor(struct vm_fault *vmf, pfn_t *pfnp,
>  	if (err)
>  		return dax_fault_return(err);
>
> -	entry = dax_insert_entry(xas, mapping, vmf, entry, pfn, 0,
> -				 write && !sync);
> +	if (write) {
> +		if (!sync)
> +			insert_flags |= DAX_IF_DIRTY;
> +		if (iomap->flags & IOMAP_F_SHARED)
> +			insert_flags |= DAX_IF_COW;
> +	}
> +
> +	entry = dax_insert_entry(xas, vmf, entry, pfn, 0, insert_flags);
>
>  	if (write && srcmap->addr != iomap->addr) {
>  		err = dax_iomap_cow_copy(pos, size, size, srcmap, kaddr, false);
>

Rest looks good to me. Please feel free to add
Reviewed-by: Ritesh Harjani <riteshh@gmail.com>

sorry about changing my email in between of this code review.
I am planning to use above gmail id as primary account for all upstream work
from now.

> --
> 2.30.1
>
>
>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
