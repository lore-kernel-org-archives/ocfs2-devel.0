Return-Path: <SRS0=iO0D=PV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F266DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 02:58:15 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E08960524
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 02:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E08960524
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A21DGx1021932;
	Tue, 2 Nov 2021 02:58:15 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c290gw21a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Nov 2021 02:58:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A22ua0s118842;
	Tue, 2 Nov 2021 02:58:13 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c1khstyqj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Nov 2021 02:58:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mhk04-0000c1-5K; Mon, 01 Nov 2021 19:58:12 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mhk00-0000ba-CJ
	for ocfs2-devel@oss.oracle.com; Mon, 01 Nov 2021 19:58:08 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A22tb9X116632
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 02:58:08 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3c0v3d2f29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 02:58:07 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A213AW0011919
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 02:58:07 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c28p35djy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 02:58:06 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R911e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0Uufedsf_1635821881; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Uufedsf_1635821881) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 02 Nov 2021 10:58:01 +0800
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <20211025150008.29002-1-jack@suse.cz>
	<20211025151332.11301-2-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <5668bcf5-388c-1870-520f-d999e066ec7a@linux.alibaba.com>
Date: Tue, 2 Nov 2021 10:58:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025151332.11301-2-jack@suse.cz>
Content-Language: en-US
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	suspectscore=0
	clxscore=173 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0
	mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0
	lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111020013
	domainage_hfrom=8237
X-Spam: Clean
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: Do not zero pages beyond i_size
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020013
X-Proofpoint-GUID: qtOZjaI3E-2uTmJc-z2sX4zWgWCg26Xw
X-Proofpoint-ORIG-GUID: qtOZjaI3E-2uTmJc-z2sX4zWgWCg26Xw



On 10/25/21 11:13 PM, Jan Kara wrote:
> ocfs2_zero_range_for_truncate() can try to zero pages beyond current
> inode size despite the fact that underlying blocks should be already
> zeroed out and writeback will skip writing such pages anyway. Avoid the
> pointless work.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 5d9ae17bd443..ff5ff0e7de44 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6921,13 +6921,12 @@ static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
>  }
>  
>  /*
> - * Zero the area past i_size but still within an allocated
> - * cluster. This avoids exposing nonzero data on subsequent file
> - * extends.
> + * Zero partial cluster for a hole punch or truncate. This avoids exposing
> + * nonzero data on subsequent file extends.
>   *
>   * We need to call this before i_size is updated on the inode because
>   * otherwise block_write_full_page() will skip writeout of pages past
> - * i_size. The new_i_size parameter is passed for this reason.
> + * i_size.
>   */
>  int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  				  u64 range_start, u64 range_end)
> @@ -6945,6 +6944,15 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)))
>  		return 0;
>  
> +	/*
> +	 * Avoid zeroing pages fully beyond current i_size. It is pointless as
> +	 * underlying blocks of those pages should be already zeroed out and
> +	 * page writeback will skip them anyway.
> +	 */
> +	range_end = min_t(u64, range_end, i_size_read(inode));
> +	if (range_start >= range_end)
> +		return 0;
> +
>  	pages = kcalloc(ocfs2_pages_per_cluster(sb),
>  			sizeof(struct page *), GFP_NOFS);
>  	if (pages == NULL) {
> @@ -6953,9 +6961,6 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
>  		goto out;
>  	}
>  
> -	if (range_start == range_end)
> -		goto out;
> -
>  	ret = ocfs2_extent_map_get_blocks(inode,
>  					  range_start >> sb->s_blocksize_bits,
>  					  &phys, NULL, &ext_flags);
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
