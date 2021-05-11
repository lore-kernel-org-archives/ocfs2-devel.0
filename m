Return-Path: <SRS0=6hlh=KG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AF2C433B4
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 12:55:11 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A24786191C
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 12:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A24786191C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BCnnqA117722;
	Tue, 11 May 2021 12:55:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 38dg5beprc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 May 2021 12:55:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BCpbC1156715;
	Tue, 11 May 2021 12:55:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38dfrx7k4p-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 11 May 2021 12:55:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lgRuk-0007pd-JT; Tue, 11 May 2021 05:55:06 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lgRug-0007pD-Ox
	for ocfs2-devel@oss.oracle.com; Tue, 11 May 2021 05:55:02 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14BCo0G3108110
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:55:02 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 38fh3wpmwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:55:02 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 14BCsShE043132
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:55:01 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by userp2040.oracle.com with ESMTP id 38evq0wxnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:55:00 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UYYCUtP_1620737693; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UYYCUtP_1620737693) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 11 May 2021 20:54:54 +0800
To: Dan Carpenter <dan.carpenter@oracle.com>, Mark Fasheh <mark@fasheh.com>
References: <YJovRPdOiaU6I+JK@mwanda>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <bd7ddc22-11c4-3e88-120a-d68f153f573d@linux.alibaba.com>
Date: Tue, 11 May 2021 20:54:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YJovRPdOiaU6I+JK@mwanda>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	suspectscore=0
	mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0
	impostorscore=0 phishscore=0 clxscore=286 priorityscore=70 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105110098
X-Spam: Clean
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix snprintf() checking
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110098
X-Proofpoint-GUID: _b0Hy8XvNdf2iq0_nS72Zakd7mSpyIr0
X-Proofpoint-ORIG-GUID: _b0Hy8XvNdf2iq0_nS72Zakd7mSpyIr0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1034 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110098



On 5/11/21 3:16 PM, Dan Carpenter wrote:
> The snprintf() function returns the number of bytes which would have
> been printed if the buffer was large enough.  In other words it can
> return ">= remain" but this code assumes it returns "== remain".
> 
> The run time impact of this bug is not very severe.  The next iteration
> through the loop would trigger a WARN() when we pass a negative limit
> to snprintf().  We would then return success instead of -E2BIG.
> 
> The kernel implementation of snprintf() will never return negatives so
> there is no need to check and I have deleted that dead code.
> 
> Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good. But the last 2 sections are introduced by:
74ae4e104dfc ocfs2: Create stack glue sysfs files.

With 'Fixes' tag updated,
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/filecheck.c | 6 +-----
>  fs/ocfs2/stackglue.c | 8 ++------
>  2 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
> index 90b8d300c1ee..de56e6231af8 100644
> --- a/fs/ocfs2/filecheck.c
> +++ b/fs/ocfs2/filecheck.c
> @@ -326,11 +326,7 @@ static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
>  		ret = snprintf(buf + total, remain, "%lu\t\t%u\t%s\n",
>  			       p->fe_ino, p->fe_done,
>  			       ocfs2_filecheck_error(p->fe_status));
> -		if (ret < 0) {
> -			total = ret;
> -			break;
> -		}
> -		if (ret == remain) {
> +		if (ret >= remain) {
>  			/* snprintf() didn't fit */
>  			total = -E2BIG;
>  			break;
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index d50e8b8dfea4..16f1bfc407f2 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -500,11 +500,7 @@ static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
>  	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
>  		ret = snprintf(buf, remain, "%s\n",
>  			       p->sp_name);
> -		if (ret < 0) {
> -			total = ret;
> -			break;
> -		}
> -		if (ret == remain) {
> +		if (ret >= remain) {
>  			/* snprintf() didn't fit */
>  			total = -E2BIG;
>  			break;
> @@ -531,7 +527,7 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
>  	if (active_stack) {
>  		ret = snprintf(buf, PAGE_SIZE, "%s\n",
>  			       active_stack->sp_name);
> -		if (ret == PAGE_SIZE)
> +		if (ret >= PAGE_SIZE)
>  			ret = -E2BIG;
>  	}
>  	spin_unlock(&ocfs2_stack_lock);
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
