Return-Path: <SRS0=Eigy=NV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C35C432BE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 30 Aug 2021 11:05:50 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FEFC61107
	for <ocfs2-devel@archiver.kernel.org>; Mon, 30 Aug 2021 11:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4FEFC61107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17UB2ppk014970;
	Mon, 30 Aug 2021 11:05:49 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3arbymh7j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Aug 2021 11:05:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17UB5m0D029121;
	Mon, 30 Aug 2021 11:05:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aqxwr7xue-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 30 Aug 2021 11:05:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mKf6l-0005N0-I1; Mon, 30 Aug 2021 04:05:43 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mKf6g-0005MZ-2a
	for ocfs2-devel@oss.oracle.com; Mon, 30 Aug 2021 04:05:38 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17UB5aV1154873
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 11:05:37 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3aqcy2n8ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 11:05:36 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17U9GuKO016311
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 11:05:22 GMT
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by mx0b-00069f01.pphosted.com with ESMTP id 3arvjd8yyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 11:05:22 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R771e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0Umb.v-4_1630321514; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Umb.v-4_1630321514) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 30 Aug 2021 19:05:15 +0800
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20210830044621.12544-1-ghe@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <471dd2b4-fb62-3f4a-dbf3-cbf2340aed6f@linux.alibaba.com>
Date: Mon, 30 Aug 2021 19:05:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830044621.12544-1-ghe@suse.com>
Content-Language: en-US
X-Source-IP: 115.124.30.132
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=263
	priorityscore=203
	bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
	lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0
	mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108300081 domainage_hfrom=8173
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0
	phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108300081
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: ocfs2_downconvert_lock failure
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300081
X-Proofpoint-ORIG-GUID: EECW6m-Ic-usfqkzTQ9-qoBRKA3gMKzr
X-Proofpoint-GUID: EECW6m-Ic-usfqkzTQ9-qoBRKA3gMKzr



On 8/30/21 12:46 PM, Gang He wrote:
> Usually, ocfs2_downconvert_lock() function always downconverts
> dlm lock to the expected level for satisfy dlm bast requests
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

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2: keep error print in ocfs2_downconvert_lock function, add more detailed
> comments in code, add msleep to avoid repeated attempts. 
> ---
>  fs/ocfs2/dlmglue.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 48fd369c29a4..f8f561850470 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -16,6 +16,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/time.h>
> +#include <linux/delay.h>
>  #include <linux/quotaops.h>
>  #include <linux/sched/signal.h>
>  
> @@ -3912,6 +3913,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
>  				     gen);
> +	/* The dlm lock convert is being cancelled in background,
> +	 * ocfs2_cancel_convert() is asynchronous in fs/dlm,
> +	 * requeue it, try again later.
> +	 */
> +	if (ret == -EBUSY) {
> +		ctl->requeue = 1;
> +		mlog(ML_BASTS, "lockres %s, ReQ: Downconvert busy\n",
> +		     lockres->l_name);
> +		ret = 0;
> +		msleep(20);
> +	}
>  
>  leave:
>  	if (ret)
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
