Return-Path: <SRS0=xZbm=HE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B460C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 12:08:46 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B184D64DB2
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 12:08:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B184D64DB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112C416b051850;
	Tue, 2 Feb 2021 12:08:44 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 36cvyatmkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Feb 2021 12:08:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112C0BwF075159;
	Tue, 2 Feb 2021 12:08:43 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7rc9td-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Feb 2021 12:08:43 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6uU6-0006XM-8h; Tue, 02 Feb 2021 04:08:42 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1l6uU2-0006Wv-A4
	for ocfs2-devel@oss.oracle.com; Tue, 02 Feb 2021 04:08:38 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	112C0wVj167113
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Feb 2021 12:08:38 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 36dhby59es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Feb 2021 12:08:37 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	112C2ntf043957
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Feb 2021 12:08:36 GMT
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by userp2030.oracle.com with ESMTP id 36dutah5x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Feb 2021 12:08:36 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=11; SR=0;
	TI=SMTPD_---0UNgkalg_1612267708; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UNgkalg_1612267708) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 02 Feb 2021 20:08:29 +0800
To: Dan Carpenter <dan.carpenter@oracle.com>, Mark Fasheh <mark@fasheh.com>
References: <YBk4M6HUG8jB/jc7@mwanda>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <56634c6b-1c68-83dc-e372-09fd4bda3c7d@linux.alibaba.com>
Date: Tue, 2 Feb 2021 20:08:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YBk4M6HUG8jB/jc7@mwanda>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.133
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
	lowpriorityscore=0 clxscore=141 malwarescore=0 spamscore=0
	priorityscore=157 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102020083
X-Spam: Clean
Cc: Jens Axboe <axboe@kernel.dk>, Takashi Iwai <tiwai@suse.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Jiri Slaby <jirislaby@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Fix a use after free on error
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020083
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1034 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020083



On 2/2/21 7:32 PM, Dan Carpenter wrote:
> The error handling in this function frees "reg" but it is still on the
> "o2hb_all_regions" list so it will lead to a use after freew.  Joseph Qi
> points out that we need to clear the bit in the "o2hb_region_bitmap" as
> well
> 
> Fixes: 1cf257f51191 ("ocfs2: fix memory leak")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2: The first version didn't clear the bit.
> 
>  fs/ocfs2/cluster/heartbeat.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 0179a73a3fa2..12a7590601dd 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -2042,7 +2042,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  			o2hb_nego_timeout_handler,
>  			reg, NULL, &reg->hr_handler_list);
>  	if (ret)
> -		goto free;
> +		goto remove_item;
>  
>  	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
>  			sizeof(struct o2hb_nego_msg),
> @@ -2057,6 +2057,12 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  
>  unregister_handler:
>  	o2net_unregister_handler_list(&reg->hr_handler_list);
> +remove_item:
> +	spin_lock(&o2hb_live_lock);
> +	list_del(&reg->hr_all_item);
> +	if (o2hb_global_heartbeat_active())
> +		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
> +	spin_unlock(&o2hb_live_lock);
>  free:
>  	kfree(reg);
>  	return ERR_PTR(ret);
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
