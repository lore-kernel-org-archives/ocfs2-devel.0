Return-Path: <SRS0=eIKw=IB=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D962C433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:28:23 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C954664EDC
	for <ocfs2-devel@archiver.kernel.org>; Wed,  3 Mar 2021 09:28:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C954664EDC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239OXRO074999;
	Wed, 3 Mar 2021 09:28:21 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 3726v785eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Mar 2021 09:28:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1239PHmn099820;
	Wed, 3 Mar 2021 09:28:20 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000y6ecx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 03 Mar 2021 09:28:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lHNnn-0007GA-Js; Wed, 03 Mar 2021 01:28:19 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63) (envelope-from <hch@lst.de>)
	id 1lHNni-0007Fi-6v
	for ocfs2-devel@oss.oracle.com; Wed, 03 Mar 2021 01:28:14 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239PIlG099987
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:28:13 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 37000y6e8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:28:13 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1239DXDH024096
	for <ocfs2-devel@oss.oracle.com>; Wed, 3 Mar 2021 09:28:13 GMT
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by userp2030.oracle.com with ESMTP id 36yc4jfvtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 03 Mar 2021 09:28:13 +0000
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A87668BEB; Wed,  3 Mar 2021 10:28:08 +0100 (CET)
Date: Wed, 3 Mar 2021 10:28:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210303092808.GC12784@lst.de>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<20210226002030.653855-3-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210226002030.653855-3-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-PDR: PASS
X-Source-IP: 213.95.11.211
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0
	mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0
	lowpriorityscore=0 clxscore=194 spamscore=0 mlxscore=0 phishscore=0
	priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103030071
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 02/10] fsdax: Factor helper:
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9911 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030072

On Fri, Feb 26, 2021 at 08:20:22AM +0800, Shiyang Ruan wrote:
> The core logic in the two dax page fault functions is similar. So, move
> the logic into a common helper function. Also, to facilitate the
> addition of new features, such as CoW, switch-case is no longer used to
> handle different iomap types.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c | 211 ++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 117 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 7031e4302b13..9dea1572868e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1289,6 +1289,93 @@ static int dax_fault_cow_page(struct vm_fault *vmf, struct iomap *iomap,
>  	return 0;
>  }
>  
> +static vm_fault_t dax_fault_insert_pfn(struct vm_fault *vmf, pfn_t pfn,
> +		bool pmd, bool write)
> +{
> +	vm_fault_t ret;
> +
> +	if (!pmd) {
> +		struct vm_area_struct *vma = vmf->vma;
> +		unsigned long address = vmf->address;
> +
> +		if (write)
> +			ret = vmf_insert_mixed_mkwrite(vma, address, pfn);
> +		else
> +			ret = vmf_insert_mixed(vma, address, pfn);
> +	} else
> +		ret = vmf_insert_pfn_pmd(vmf, pfn, write);

What about simplifying this a little bit more, something like:

	if (pmd)
		return vmf_insert_pfn_pmd(vmf, pfn, write);

	if (write)
		return vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);

also given that this only has a single user, why not keep open coding
it in the caller?

> +#ifdef CONFIG_FS_DAX_PMD
> +static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> +		struct iomap *iomap, void **entry);
> +#else
> +static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> +		struct iomap *iomap, void **entry)
> +{
> +	return VM_FAULT_FALLBACK;
> +}
> +#endif

Can we try to avoid the forward declaration?  Also is there a reason
dax_pmd_load_hole does not compile for the !CONFIG_FS_DAX_PMD case?
If it compiles fine we can just rely on IS_ENABLED() based dead code
elimination entirely.

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

Nit: I'd use a switch statement here for a clarity:

	switch (iomap->type) {
	case IOMAP_MAPPED:
		break;
	case IOMAP_UNWRITTEN:
	case IOMAP_HOLE:
		if (!write) {
			if (!pmd)
				return dax_load_hole(xas, mapping, &entry, vmf);
			return dax_pmd_load_hole(xas, vmf, iomap, &entry);
		}
		break;
	default:
		WARN_ON_ONCE(1);
		return VM_FAULT_SIGBUS;
	}


> +	err = dax_iomap_pfn(iomap, pos, size, &pfn);
> +	if (err)
> +		goto error_fault;
> +
> +	entry = dax_insert_entry(xas, mapping, vmf, entry, pfn, 0,
> +				 write && !sync);
> +
> +	if (sync)
> +		return dax_fault_synchronous_pfnp(pfnp, pfn);
> +
> +	ret = dax_fault_insert_pfn(vmf, pfn, pmd, write);
> +
> +error_fault:
> +	if (err)
> +		ret = dax_fault_return(err);
> +
> +	return ret;

It seems like the only place that sets err is the dax_iomap_pfn case
above.  So I'd move the dax_fault_return there, which then allows a direct
return for everyone else, including the open coded version of
dax_fault_insert_pfn.

I really like where this is going!

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
