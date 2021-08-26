Return-Path: <SRS0=tkcu=NR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3CEC432BE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 08:23:32 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 37DFC61037
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 08:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 37DFC61037
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17Q7c7eF006537;
	Thu, 26 Aug 2021 08:23:31 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap1r5gjcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Aug 2021 08:23:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q8BYDw079856;
	Thu, 26 Aug 2021 08:23:30 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb8yk585-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 26 Aug 2021 08:23:29 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJAfY-0005yl-VZ; Thu, 26 Aug 2021 01:23:28 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mJAfT-0005yK-LE
	for ocfs2-devel@oss.oracle.com; Thu, 26 Aug 2021 01:23:23 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17Q8BVJj079598
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 08:23:23 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3akb8yk54a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 08:23:22 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17Q7kUnl031209
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 08:23:21 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ap6urra4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 08:23:21 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0Um2Jt1D_1629966194; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Um2Jt1D_1629966194) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 26 Aug 2021 16:23:14 +0800
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20210826061038.22295-1-ghe@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <b3f498eb-7de5-8a7f-0f52-01c1e2caa5d8@linux.alibaba.com>
Date: Thu, 26 Aug 2021 16:23:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826061038.22295-1-ghe@suse.com>
Content-Language: en-US
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	clxscore=277
	malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
	priorityscore=0
	impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108260049 domainage_hfrom=8169
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108260049
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: ocfs2_downconvert_lock failure
	results in deadlock
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260049
X-Proofpoint-GUID: 2mosAf07rKPV_BT9IfKwWw2qMNlhnmNC
X-Proofpoint-ORIG-GUID: 2mosAf07rKPV_BT9IfKwWw2qMNlhnmNC



On 8/26/21 2:10 PM, Gang He wrote:
> Usually, ocfs2_downconvert_lock() function always downconverts
> dlm lock to the expected level for satisfy dlm bast requests

s/for/to

> from the other nodes.
> But there is a rare situation. When dlm lock conversion is being
> canceled, ocfs2_downconvert_lock() function will return -EBUSY.
> You need to be aware that ocfs2_cancel_convert() function is
> asynchronous in fsdlm implementation.
> If we does not requeue this lockres entry, ocfs2 downconvert
> thread no longer handles this dlm lock bast request. Then, the
> other nodes will not get the dlm lock again, the current node's
> process will be blocked when acquire this dlm lock again.
> 
> Signed-off-by: Gang He <ghe@suse.com>
> ---
>  fs/ocfs2/dlmglue.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 48fd369c29a4..c454c218fbfe 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3671,13 +3671,11 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
>  			     OCFS2_LOCK_ID_MAX_LEN - 1);
>  	lockres_clear_pending(lockres, generation, osb);
>  	if (ret) {
> -		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
> +		if (ret != -EBUSY)
> +			ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);

Do we have to treat EBUSY as a normal case?

>  		ocfs2_recover_from_dlm_error(lockres, 1);
> -		goto bail;
>  	}
>  
> -	ret = 0;
> -bail:
>  	return ret;
>  }
>  
> @@ -3912,6 +3910,13 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
>  				     gen);
> +	/* ocfs2_cancel_convert() is in progress, try again later */
> +	if (ret == -EBUSY) {
> +		ctl->requeue = 1;
> +		mlog(ML_BASTS, "lockres %s, ReQ: Downconvert busy\n",
> +		     lockres->l_name);
> +		ret = 0;

Ditto. If EBUSY is not a normal case, I'd like just requeue it but not
change it to normal return code.
You know ML_BASTS is always switched off in production environment.

Thanks,
Joseph

> +	}
>  
>  leave:
>  	if (ret)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
