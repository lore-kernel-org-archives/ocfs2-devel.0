Return-Path: <SRS0=QTdx=HG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF004C433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Feb 2021 05:14:30 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 297DA64F53
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Feb 2021 05:14:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 297DA64F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1145ETPU105541;
	Thu, 4 Feb 2021 05:14:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 36cxvr65tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Feb 2021 05:14:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1145AIql049874;
	Thu, 4 Feb 2021 05:12:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7um71q-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 04 Feb 2021 05:12:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l7WwN-00027H-H6; Wed, 03 Feb 2021 21:12:27 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1l7WwL-000270-4a
	for ocfs2-devel@oss.oracle.com; Wed, 03 Feb 2021 21:12:25 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11459ao9092798
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Feb 2021 05:12:25 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36dh1rxk6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Feb 2021 05:12:24 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1144rFgR044973
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Feb 2021 05:12:23 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by userp2030.oracle.com with ESMTP id 36fu3dpxnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Feb 2021 05:12:23 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R641e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UNpakAn_1612415537; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UNpakAn_1612415537) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 04 Feb 2021 13:12:17 +0800
To: Yang Li <yang.lee@linux.alibaba.com>
References: <1612408323-23579-1-git-send-email-yang.lee@linux.alibaba.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <cea953c5-79e7-8bd3-13ca-8ee4f25ff03f@linux.alibaba.com>
Date: Thu, 4 Feb 2021 13:12:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1612408323-23579-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	lowpriorityscore=0
	bulkscore=0 malwarescore=0 priorityscore=108 adultscore=0 clxscore=130
	suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102040029
X-Spam: Clean
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Remove unneeded return variable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040030
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1034
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040031

NAK.
This was discussed before, please refer:
https://oss.oracle.com/pipermail/ocfs2-devel/2020-April/014969.html

Thanks,
Joseph

On 2/4/21 11:12 AM, Yang Li wrote:
> This patch removes unneeded return variables, using only
> '0' instead.
> It fixes the following warning detected by coccinelle:
> ./fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: "o2dlm_flags".
> Return "0" on line 84
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  fs/ocfs2/stack_o2cb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index dbf8b57..2da9633 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -66,8 +66,6 @@ static inline int mode_to_o2dlm(int mode)
>  	}
>  static int flags_to_o2dlm(u32 flags)
>  {
> -	int o2dlm_flags = 0;
> -
>  	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
>  	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
>  	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
> @@ -81,7 +79,7 @@ static int flags_to_o2dlm(u32 flags)
>  	/* map_flag() should have cleared every flag passed in */
>  	BUG_ON(flags != 0);
>  
> -	return o2dlm_flags;
> +	return 0;
>  }
>  #undef map_flag
>  
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
