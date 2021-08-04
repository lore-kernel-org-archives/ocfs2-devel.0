Return-Path: <SRS0=OBPb=M3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE500C4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed,  4 Aug 2021 03:30:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6C08760F38
	for <ocfs2-devel@archiver.kernel.org>; Wed,  4 Aug 2021 03:30:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6C08760F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1743HvcH015669;
	Wed, 4 Aug 2021 03:30:10 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntn8bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Aug 2021 03:30:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1743LShP055878;
	Wed, 4 Aug 2021 03:30:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a4un0tte2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 04 Aug 2021 03:30:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mB7YZ-00008m-3y; Tue, 03 Aug 2021 20:26:59 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mB7YW-00008V-QE
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 20:26:56 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1743K9R5173331
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 03:26:56 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3a78d5vdba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 03:26:56 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1743I64b017412
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 03:26:55 GMT
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a77t96gsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 03:26:55 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R541e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UhvqXdx_1628047610; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UhvqXdx_1628047610) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 04 Aug 2021 11:26:50 +0800
To: Tuo Li <islituo@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20210804031832.57154-1-islituo@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <d19dd958-93f6-bc42-b419-c60571de9b70@linux.alibaba.com>
Date: Wed, 4 Aug 2021 11:26:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804031832.57154-1-islituo@gmail.com>
Content-Language: en-US
X-Source-IP: 115.124.30.42
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	phishscore=0 suspectscore=0
	lowpriorityscore=0 impostorscore=0 spamscore=0 adultscore=0
	priorityscore=210 mlxlogscore=999 bulkscore=0 malwarescore=0
	clxscore=291
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108040018 domainage_hfrom=8147
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108040018
Cc: TOTE Robot <oslab@tsinghua.edu.cn>, baijiaju1990@gmail.com,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3] ocfs2: quota_local: fix possible
 uninitialized-variable access in ocfs2_local_read_info()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040018
X-Proofpoint-ORIG-GUID: y3-PxusDCGxQ1TKpRMFbPbDIQlkSLg87
X-Proofpoint-GUID: y3-PxusDCGxQ1TKpRMFbPbDIQlkSLg87



On 8/4/21 11:18 AM, Tuo Li wrote:
> A memory block is allocated through kmalloc(), and its return value is
> assigned to the pointer oinfo. However, oinfo->dqi_gqinode is not
> initialized but it is accessed in:
>   iput(oinfo->dqi_gqinode);
> 
> To fix this possible uninitialized-variable access, assign NULL to
> oinfo->dqi_gqinode, and add ocfs2_qinfo_lock_res_init()
> behind the assignment in ocfs2_local_read_info(). Remove
> ocfs2_qinfo_lock_res_init() in ocfs2_global_read_info().
> 

Or we can simplify the above description to:
"To fix the possible uninitialized-variable access, initialize
dqi_gqinode and dqi_gqlock first before calling
ocfs2_global_read_info()."

> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v3:
> * Update description.
> * Assign NULL to oinfo->dqi_gqinode, and add ocfs2_qinfo_lock_res_init()
> behind the assignment in ocfs2_local_read_info(). Remove
> ocfs2_qinfo_lock_res_init() in ocfs2_global_read_info()
>   Thank Joseph Qi for helpful advice.
> v2:
> * Replace kzalloc() with NULL assignment to oinfo->dqi_gqinode.
>   Thank Joseph Qi for helpful advice.
> ---
>  fs/ocfs2/quota_global.c | 1 -
>  fs/ocfs2/quota_local.c  | 2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index eda83487c9ec..f033de733adb 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -357,7 +357,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>  	}
>  	oinfo->dqi_gi.dqi_sb = sb;
>  	oinfo->dqi_gi.dqi_type = type;
> -	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
>  	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
>  	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
>  	oinfo->dqi_gqi_bh = NULL;
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index b1a8b046f4c2..0e4b16d4c037 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -702,6 +702,8 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>  	info->dqi_priv = oinfo;
>  	oinfo->dqi_type = type;
>  	INIT_LIST_HEAD(&oinfo->dqi_chunk);
> +	oinfo->dqi_gqinode = NULL;
> +	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
>  	oinfo->dqi_rec = NULL;
>  	oinfo->dqi_lqi_bh = NULL;
>  	oinfo->dqi_libh = NULL;
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
