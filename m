Return-Path: <SRS0=wAx7=IV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC7EC433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:58:53 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0EA37619D0
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EA37619D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NFtMSD153278;
	Tue, 23 Mar 2021 15:58:51 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 37d90mfksu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Mar 2021 15:58:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NFsjVl085889;
	Tue, 23 Mar 2021 15:58:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37dtyxmkrv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 23 Mar 2021 15:58:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lOjQe-0004fE-R9; Tue, 23 Mar 2021 08:58:48 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <riteshh@linux.ibm.com>) id 1lOjQb-0004ef-4k
	for ocfs2-devel@oss.oracle.com; Tue, 23 Mar 2021 08:58:45 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12NFu984179896
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 15:58:44 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 37dtts4f2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 15:58:44 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12NFrTfx030968
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 15:58:44 GMT
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by userp2040.oracle.com with ESMTP id 37d7nurdt8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 15:58:44 +0000
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	12NFnq9s031728; Tue, 23 Mar 2021 11:58:31 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 37fkafrcd2-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 23 Mar 2021 11:58:31 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id
	12NFkrYQ030831; Tue, 23 Mar 2021 15:48:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04ams.nl.ibm.com with ESMTP id 37d99rbggh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 23 Mar 2021 15:48:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
	[9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 12NFlxMV36569572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 23 Mar 2021 15:47:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7216DAE04D;
	Tue, 23 Mar 2021 15:48:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C44B0AE045;
	Tue, 23 Mar 2021 15:48:14 +0000 (GMT)
Received: from [9.199.34.65] (unknown [9.199.34.65])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 23 Mar 2021 15:48:14 +0000 (GMT)
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
	<20210319015237.993880-3-ruansy.fnst@fujitsu.com>
From: Ritesh Harjani <riteshh@linux.ibm.com>
Message-ID: <d4daf840-f407-d746-b3e4-35753eb511b3@linux.ibm.com>
Date: Tue, 23 Mar 2021 21:18:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210319015237.993880-3-ruansy.fnst@fujitsu.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369, 18.0.761
	definitions=2021-03-23_07:2021-03-22,
	2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	lowpriorityscore=0 mlxscore=0
	bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
	suspectscore=0
	phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103230114
X-PDR: PASS
X-Source-IP: 148.163.158.5
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	phishscore=0 adultscore=0 impostorscore=0 clxscore=50 mlxscore=0
	mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=278
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103230116
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 02/10] fsdax: Factor helper:
	dax_fault_actor()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230117



On 3/19/21 7:22 AM, Shiyang Ruan wrote:
> The core logic in the two dax page fault functions is similar. So, move
> the logic into a common helper function. Also, to facilitate the
> addition of new features, such as CoW, switch-case is no longer used to
> handle different iomap types.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   fs/dax.c | 291 +++++++++++++++++++++++++++----------------------------
>   1 file changed, 145 insertions(+), 146 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 7031e4302b13..33ddad0f3091 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1053,6 +1053,66 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
>   	return ret;
>   }
>   
> +#ifdef CONFIG_FS_DAX_PMD
> +static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> +		struct iomap *iomap, void **entry)
> +{
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> +	unsigned long pmd_addr = vmf->address & PMD_MASK;
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct inode *inode = mapping->host;
> +	pgtable_t pgtable = NULL;
> +	struct page *zero_page;
> +	spinlock_t *ptl;
> +	pmd_t pmd_entry;
> +	pfn_t pfn;
> +
> +	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
> +
> +	if (unlikely(!zero_page))
> +		goto fallback;
> +
> +	pfn = page_to_pfn_t(zero_page);
> +	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> +			DAX_PMD | DAX_ZERO_PAGE, false);
> +
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pte_alloc_one(vma->vm_mm);
> +		if (!pgtable)
> +			return VM_FAULT_OOM;
> +	}
> +
> +	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
> +	if (!pmd_none(*(vmf->pmd))) {
> +		spin_unlock(ptl);
> +		goto fallback;
> +	}
> +
> +	if (pgtable) {
> +		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
> +		mm_inc_nr_ptes(vma->vm_mm);
> +	}
> +	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
> +	pmd_entry = pmd_mkhuge(pmd_entry);
> +	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
> +	spin_unlock(ptl);
> +	trace_dax_pmd_load_hole(inode, vmf, zero_page, *entry);
> +	return VM_FAULT_NOPAGE;
> +
> +fallback:
> +	if (pgtable)
> +		pte_free(vma->vm_mm, pgtable);
> +	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, *entry);
> +	return VM_FAULT_FALLBACK;
> +}
> +#else
> +static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> +		struct iomap *iomap, void **entry)
> +{
> +	return VM_FAULT_FALLBACK;
> +}
> +#endif /* CONFIG_FS_DAX_PMD */
> +
>   s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>   {
>   	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
> @@ -1289,6 +1349,61 @@ static int dax_fault_cow_page(struct vm_fault *vmf, struct iomap *iomap,
>   	return 0;
>   }
>   
> +/**
> + * dax_fault_actor - Common actor to handle pfn insertion in PTE/PMD fault.
> + * @vmf:	vm fault instance
> + * @pfnp:	pfn to be returned
> + * @xas:	the dax mapping tree of a file
> + * @entry:	an unlocked dax entry to be inserted
> + * @pmd:	distinguish whether it is a pmd fault
> + * @flags:	iomap flags
> + * @iomap:	from iomap_begin()
> + * @srcmap:	from iomap_begin(), not equal to iomap if it is a CoW
> + */
> +static vm_fault_t dax_fault_actor(struct vm_fault *vmf, pfn_t *pfnp,
> +		struct xa_state *xas, void *entry, bool pmd, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> +	size_t size = pmd ? PMD_SIZE : PAGE_SIZE;
> +	loff_t pos = (loff_t)xas->xa_offset << PAGE_SHIFT;

shouldn't we use xa_index here for pos ?
(loff_t)xas->xa_index << PAGE_SHIFT;

> +	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +	bool sync = dax_fault_is_synchronous(flags, vmf->vma, iomap);
> +	int err = 0;
> +	pfn_t pfn;
> +
> +	/* if we are reading UNWRITTEN and HOLE, return a hole. */
> +	if (!write &&
> +	    (iomap->type == IOMAP_UNWRITTEN || iomap->type == IOMAP_HOLE)) {
> +		if (!pmd)
> +			return dax_load_hole(xas, mapping, &entry, vmf);
> +		else
> +			return dax_pmd_load_hole(xas, vmf, iomap, &entry);
> +	}
> +
> +	if (iomap->type != IOMAP_MAPPED) {
> +		WARN_ON_ONCE(1);
> +		return VM_FAULT_SIGBUS;
> +	}

So now in case if mapping is not mapped, we always cause
VM_FAULT_SIGBUG. But earlier we were only doing WARN_ON_ONCE(1).
Can you pls help answer why the change in behavior?




> +
> +	err = dax_iomap_pfn(iomap, pos, size, &pfn);
> +	if (err)
> +		return dax_fault_return(err);

Same case here as well. This could return SIGBUS while earlier I am not 
sure why were we only returning FALLBACK?


> +
> +	entry = dax_insert_entry(xas, mapping, vmf, entry, pfn, 0,
> +				 write && !sync);

In dax_insert_entry() we are passing 0 as flags.
We should be passing DAX_PMD/DAX_PTE no?


> +
> +	if (sync)
> +		return dax_fault_synchronous_pfnp(pfnp, pfn);
> +


/* handle PMD case here */
> +	if (pmd)
> +		return vmf_insert_pfn_pmd(vmf, pfn, write);

/* handle PTE case here */
> +	if (write)
> +		return vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
> +	else
> +		return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
> +}

It is easy to miss the return from if(pmd) case while reading.
A comment like above could be helpful for code review.


> +
>   static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>   			       int *iomap_errp, const struct iomap_ops *ops)
>   {
> @@ -1296,17 +1411,14 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>   	struct address_space *mapping = vma->vm_file->f_mapping;
>   	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
>   	struct inode *inode = mapping->host;
> -	unsigned long vaddr = vmf->address;
>   	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
>   	struct iomap iomap = { .type = IOMAP_HOLE };
>   	struct iomap srcmap = { .type = IOMAP_HOLE };
>   	unsigned flags = IOMAP_FAULT;
>   	int error, major = 0;
>   	bool write = vmf->flags & FAULT_FLAG_WRITE;
> -	bool sync;
>   	vm_fault_t ret = 0;
>   	void *entry;
> -	pfn_t pfn;
>   
>   	trace_dax_pte_fault(inode, vmf, ret);
>   	/*
> @@ -1352,8 +1464,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>   		goto unlock_entry;
>   	}
>   	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
> -		error = -EIO;	/* fs corruption? */
> -		goto error_finish_iomap;
> +		ret = VM_FAULT_SIGBUS;	/* fs corruption? */
> +		goto finish_iomap;
>   	}
>   
>   	if (vmf->cow_page) {
> @@ -1363,49 +1475,19 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>   		goto finish_iomap;
>   	}
>   
> -	sync = dax_fault_is_synchronous(flags, vma, &iomap);
> -
> -	switch (iomap.type) {
> -	case IOMAP_MAPPED:
> -		if (iomap.flags & IOMAP_F_NEW) {
> -			count_vm_event(PGMAJFAULT);
> -			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> -			major = VM_FAULT_MAJOR;
> -		}
> -		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
> -		if (error < 0)
> -			goto error_finish_iomap;
> -
> -		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						 0, write && !sync);
> -
> -		if (sync) {
> -			ret = dax_fault_synchronous_pfnp(pfnp, pfn);
> -			goto finish_iomap;
> -		}
> -		trace_dax_insert_mapping(inode, vmf, entry);
> -		if (write)
> -			ret = vmf_insert_mixed_mkwrite(vma, vaddr, pfn);
> -		else
> -			ret = vmf_insert_mixed(vma, vaddr, pfn);
> -
> +	ret = dax_fault_actor(vmf, pfnp, &xas, entry, false, flags,
> +			      &iomap, &srcmap);
> +	if (ret == VM_FAULT_SIGBUS)
>   		goto finish_iomap;
> -	case IOMAP_UNWRITTEN:
> -	case IOMAP_HOLE:
> -		if (!write) {
> -			ret = dax_load_hole(&xas, mapping, &entry, vmf);
> -			goto finish_iomap;
> -		}
> -		fallthrough;
> -	default:
> -		WARN_ON_ONCE(1);
> -		error = -EIO;
> -		break;
> +
> +	/* read/write MAPPED, CoW UNWRITTEN */
> +	if (iomap.flags & IOMAP_F_NEW) {
> +		count_vm_event(PGMAJFAULT);
> +		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> +		major = VM_FAULT_MAJOR;
>   	}

It is much better if above accounting is also done in dax_fault_actor()
function itself. Then at the end of this function we need to just do
"return ret"  instead of "return ret | major"


>   
> - error_finish_iomap:
> -	ret = dax_fault_return(error);
> - finish_iomap:
> +finish_iomap:
>   	if (ops->iomap_end) {
>   		int copied = PAGE_SIZE;
>   
> @@ -1419,66 +1501,14 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>   		 */
>   		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
>   	}
> - unlock_entry:
> +unlock_entry:
>   	dax_unlock_entry(&xas, entry);
> - out:
> +out:
>   	trace_dax_pte_fault_done(inode, vmf, ret);
>   	return ret | major;
>   }


-ritesh

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
