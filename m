Return-Path: <SRS0=KptY=KF=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E4CC433ED
	for <ocfs2-devel@archiver.kernel.org>; Mon, 10 May 2021 11:33:43 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13B30610CA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 10 May 2021 11:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13B30610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14ABOKaM017901;
	Mon, 10 May 2021 11:33:42 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 38e285a5js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 May 2021 11:33:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14ABWv2B118057;
	Mon, 10 May 2021 11:33:41 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38e4ds30gj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 10 May 2021 11:33:40 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lg4AN-0002aH-MD; Mon, 10 May 2021 04:33:39 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lg49x-0002ZY-88
	for ocfs2-devel@oss.oracle.com; Mon, 10 May 2021 04:33:13 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14ABWv1F118005
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 11:33:12 GMT
Received: from oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 38e4ds2ype-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 11:33:12 +0000
Received: from userp2030.oracle.com (userp2030.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 14ABOVuD035275
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 11:33:12 GMT
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45])
	by userp2030.oracle.com with ESMTP id 38ey83m6hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 11:33:11 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UYPgHwI_1620646384; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UYPgHwI_1620646384) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 10 May 2021 19:33:05 +0800
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, mark@fasheh.com,
        akpm <akpm@linux-foundation.org>
References: <1620643062-124920-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <d23cd1ee-0607-6254-621d-85e2981e24d2@linux.alibaba.com>
Date: Mon, 10 May 2021 19:33:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1620643062-124920-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.45
X-ServerName: out30-45.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9979
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 mlxscore=0
	phishscore=0 clxscore=172 priorityscore=70 bulkscore=0 suspectscore=0
	mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105100083
X-Spam: Clean
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Reomve err less than zero check
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9979 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100084
X-Proofpoint-GUID: RrkOHK1K5YIiWgq9wDjJNMC_4UmeCzt0
X-Proofpoint-ORIG-GUID: RrkOHK1K5YIiWgq9wDjJNMC_4UmeCzt0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9979 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1034 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105100083



On 5/10/21 6:37 PM, Jiapeng Chong wrote:
> Because enum dlm_status starts from 0, the check for err < 0 is always
> false.
> 
> Clean up the following coccicheck warning:
> 
> fs/ocfs2/dlm/dlmdebug.c:222 dlm_errname() warn: unsigned 'err' is never
> less than zero.
> 
> fs/ocfs2/dlm/dlmdebug.c:214 dlm_errmsg() warn: unsigned 'err' is never
> less than zero.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> Changes in v2:
>   -Update commit log.
> 
>  fs/ocfs2/dlm/dlmdebug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index d442cf5..817914d 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -211,7 +211,7 @@ void dlm_print_one_lock(struct dlm_lock *lockid)
>  
>  const char *dlm_errmsg(enum dlm_status err)
>  {
> -	if (err >= DLM_MAXSTATS || err < 0)
> +	if (err >= DLM_MAXSTATS)
>  		return dlm_errmsgs[DLM_MAXSTATS];
>  	return dlm_errmsgs[err];
>  }
> @@ -219,7 +219,7 @@ const char *dlm_errmsg(enum dlm_status err)
>  
>  const char *dlm_errname(enum dlm_status err)
>  {
> -	if (err >= DLM_MAXSTATS || err < 0)
> +	if (err >= DLM_MAXSTATS)
>  		return dlm_errnames[DLM_MAXSTATS];
>  	return dlm_errnames[err];
>  }
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
