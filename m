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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F7DC433ED
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:23:57 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 70B656134F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70B656134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFEQuL081043;
	Mon, 12 Apr 2021 15:23:56 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 37u3ymc2ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Apr 2021 15:23:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CFGJIM157035;
	Mon, 12 Apr 2021 15:23:55 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37unxvhgnp-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 12 Apr 2021 15:23:55 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lVyMn-0003S5-Iu; Mon, 12 Apr 2021 08:20:45 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ritesh.list@gmail.com>) id 1lRr4q-0001NF-18
	for ocfs2-devel@oss.oracle.com; Wed, 31 Mar 2021 23:45:12 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1316iuZG074740
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 06:45:11 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 37n2aauacj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 06:45:11 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1316Yjo3011176
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Apr 2021 06:45:11 GMT
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
	[209.85.215.174]) by userp2030.oracle.com with ESMTP id 37n2a5p4sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Apr 2021 06:45:10 +0000
Received: by mail-pg1-f174.google.com with SMTP id v10so916257pgs.12
	for <ocfs2-devel@oss.oracle.com>; Wed, 31 Mar 2021 23:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=cqVKb6CBj74jNn4PteYvhc8gg791d45MOhfp+Rlng1g=;
	b=Ut7KN/ZZInmKq5eaU0XNx7ZK7bBT+FAw2pGaCqAqW0XDsThnfuESO1g0fjjDAI9IPE
	2zBzhHhu+2+ew+bekhck0S5OPFRQrUIWqC60CYA7Tyo36HD/0mfNECJ3Ey7r1Eh3U2X8
	7zh+x4NdTh70oP5MwBbdOMk5OyG4LWoaEYfzfq54BAbYh/dv8AWEo6TWjOcXGGx4TIzk
	oUN8KBJ3WcViE1p2M3N7cLB32M8KmG4ClIlZwN4Coj9qErk3TiMHzRGi3FevTdlK3QYh
	9Gb8UQ/JPCnklUXuEKi+L88NG8up6kUEimF3jMWwJuBN2N+YvAO4k4Ti1lTCNvDFDETM
	63bw==
X-Gm-Message-State: AOAM532pOvPRiz7p5ygOIMMOtlkYwxkVU+wdznI5pxhpI21Z+xkIi/hf
	ccZojX7e9CrHurrFnflTeBk=
X-Google-Smtp-Source: ABdhPJxtKqGP3au9ZiwwVN50hiRw8YRBjgdFTyLntXV/t7UtoBMLPEn/8gzMRbVDkZtH1agb/7VUfw==
X-Received: by 2002:a62:e404:0:b029:1f1:5cea:afbd with SMTP id
	r4-20020a62e4040000b02901f15ceaafbdmr6303168pfh.5.1617259509397;
	Wed, 31 Mar 2021 23:45:09 -0700 (PDT)
Received: from localhost ([122.182.250.63]) by smtp.gmail.com with ESMTPSA id
	ms21sm4387389pjb.5.2021.03.31.23.45.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 31 Mar 2021 23:45:09 -0700 (PDT)
Date: Thu, 1 Apr 2021 12:15:06 +0530
From: Ritesh Harjani <ritesh.list@gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Message-ID: <20210401064506.47pz6u2gegp6s2ky@riteshh-domain>
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
	<20210319015237.993880-7-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319015237.993880-7-ruansy.fnst@fujitsu.com>
X-PDR: PASS
X-Source-IP: 209.85.215.174
X-ServerName: mail-pg1-f174.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 bulkscore=0
	priorityscore=339 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
	clxscore=186 impostorscore=0 adultscore=0 suspectscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2103310000 definitions=main-2104010046
X-Spam: Clean
X-Mailman-Approved-At: Mon, 12 Apr 2021 08:20:43 -0700
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 06/10] fsdax: Add dax_iomap_cow_copy()
 for dax_iomap_zero
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120100
X-Proofpoint-GUID: 7ZzgTzWlg4cUyTedcSk0jiDGSCf232Mz
X-Proofpoint-ORIG-GUID: 7ZzgTzWlg4cUyTedcSk0jiDGSCf232Mz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120100

On 21/03/19 09:52AM, Shiyang Ruan wrote:
> Punch hole on a reflinked file needs dax_copy_edge() too.  Otherwise,
> data in not aligned area will be not correct.  So, add the srcmap to
> dax_iomap_zero() and replace memset() as dax_copy_edge().
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  fs/dax.c               | 9 +++++++--
>  fs/iomap/buffered-io.c | 2 +-
>  include/linux/dax.h    | 3 ++-
>  3 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index cfe513eb111e..348297b38f76 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1174,7 +1174,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  }
>  #endif /* CONFIG_FS_DAX_PMD */
>
> -s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
> +s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap,
> +		struct iomap *srcmap)

Do we know why does dax_iomap_zero() operates on PAGE_SIZE range?
IIUC, dax_zero_page_range() can take nr_pages as a parameter. But we still
always use one page at a time. Why is that?

>  {
>  	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
>  	pgoff_t pgoff;
> @@ -1204,7 +1205,11 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  	}
>
>  	if (!page_aligned) {
> -		memset(kaddr + offset, 0, size);
> +		if (iomap->addr != srcmap->addr)
> +			dax_iomap_cow_copy(offset, size, PAGE_SIZE, srcmap,
> +					   kaddr, true);
> +		else
> +			memset(kaddr + offset, 0, size);
>  		dax_flush(iomap->dax_dev, kaddr + offset, size);
>  	}
>  	dax_read_unlock(id);
>

Maybe the above could be simplified to this?

	if (page_aligned) {
		rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
	} else {
		rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
		if (iomap->addr != srcmap->addr)
			dax_iomap_cow_copy(offset, size, PAGE_SIZE, srcmap,
					   kaddr, true);
		else
			memset(kaddr + offset, 0, size);
		dax_flush(iomap->dax_dev, kaddr + offset, size);
	}

	dax_read_unlock(id);
	return rc < 0 ? rc : size;

Other than that looks good.
Feel free to add.
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
