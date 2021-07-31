Return-Path: <SRS0=QHXK=MX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E28C4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 31 Jul 2021 14:01:00 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 489DF60295
	for <ocfs2-devel@archiver.kernel.org>; Sat, 31 Jul 2021 14:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 489DF60295
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16VDvWXL020757;
	Sat, 31 Jul 2021 14:00:59 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a4vxcggsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 31 Jul 2021 14:00:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16VDt9Oi139357;
	Sat, 31 Jul 2021 14:00:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a4umtu6cn-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 31 Jul 2021 14:00:57 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m9pUq-0001kk-0V; Sat, 31 Jul 2021 06:57:48 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1m9pUQ-0001jU-42
	for ocfs2-devel@oss.oracle.com; Sat, 31 Jul 2021 06:57:22 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16VDtAlL139494
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 13:57:21 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3a4umtu25m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 13:57:21 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16VDvBrw015997
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 13:57:20 GMT
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a4x7vuxcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 13:57:19 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UhXKjCz_1627739833; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UhXKjCz_1627739833) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 31 Jul 2021 21:57:14 +0800
To: Tuo Li <islituo@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20210731075659.73505-1-islituo@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <607936a1-a21d-7d2f-7a89-2abeb4c5b1d4@linux.alibaba.com>
Date: Sat, 31 Jul 2021 21:57:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210731075659.73505-1-islituo@gmail.com>
Content-Language: en-US
X-Source-IP: 115.124.30.133
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	mlxscore=0 adultscore=0
	spamscore=0 clxscore=209 lowpriorityscore=0 impostorscore=0
	suspectscore=0
	mlxlogscore=999 priorityscore=118 bulkscore=0 phishscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
	definitions=main-2107310077 domainage_hfrom=8143
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107310077
Cc: TOTE Robot <oslab@tsinghua.edu.cn>, baijiaju1990@gmail.com,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: quota_local: fix possible
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107310077
X-Proofpoint-GUID: 7__e5ItPWe5mqqkMLolJpMWTwbLNbJSS
X-Proofpoint-ORIG-GUID: 7__e5ItPWe5mqqkMLolJpMWTwbLNbJSS

Thanks for the efforts.
For the issue you mentioned, I'd like just initialized
oinfo->dqi_gqinode as NULL before calling ocfs2_global_read_info().
But it seems still have other issues here such as dqi_gqlock.
We need take care all those initialized in ocfs2_global_read_info()
carefully.

Thanks,
Joseph

On 7/31/21 3:56 PM, Tuo Li wrote:
> A memory block is allocated through kmalloc(), and its return value is
> assigned to the pointer oinfo. If the return value of
> ocfs2_global_read_info() at line 709 is less than zero,
> oinfo->dqi_gqinode may be not initialized. However, it is accessed at
> line 775:
>   iput(oinfo->dqi_gqinode);
> 
> To fix this possible uninitialized-variable access, replace kmalloc()
> with kzalloc() when allocating memory for oinfo.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
>  fs/ocfs2/quota_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index b1a8b046f4c2..4c1219e08b49 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -693,7 +693,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>  
>  	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
>  	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
> -	oinfo = kmalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
> +	oinfo = kzalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
>  	if (!oinfo) {
>  		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
>  			       " info.");
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
