Return-Path: <SRS0=+Vjt=JW=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E794C433B4
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Apr 2021 06:21:12 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A55B5613C5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 25 Apr 2021 06:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A55B5613C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13P6F3Sj146904;
	Sun, 25 Apr 2021 06:21:09 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 384b9n12vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 25 Apr 2021 06:21:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13P6GEGx038901;
	Sun, 25 Apr 2021 06:21:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3q6hc3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 25 Apr 2021 06:21:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1laY8h-0002ji-LI; Sat, 24 Apr 2021 23:21:07 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1laY8d-0002jH-QO
	for ocfs2-devel@oss.oracle.com; Sat, 24 Apr 2021 23:21:03 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13P6GRms131500
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 06:21:03 GMT
Received: from oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 3848eu1edp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 06:21:03 +0000
Received: from userp2030.oracle.com (userp2030.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 13P6DtkQ009292
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 06:21:02 GMT
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56])
	by userp2030.oracle.com with ESMTP id 384vweneaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 06:21:02 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UWeubQZ_1619331642; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UWeubQZ_1619331642) by smtp.aliyun-inc.com(127.0.0.1);
	Sun, 25 Apr 2021 14:20:42 +0800
To: Wan Jiabing <wanjiabing@vivo.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
References: <20210425025702.13628-1-wanjiabing@vivo.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <d48872a7-753d-9c6e-c69b-4ea4c5c8efaa@linux.alibaba.com>
Date: Sun, 25 Apr 2021 14:20:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210425025702.13628-1-wanjiabing@vivo.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.56
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	spamscore=0 adultscore=0
	phishscore=0 priorityscore=0 impostorscore=0 bulkscore=0
	mlxlogscore=999
	suspectscore=0 clxscore=192 mlxscore=0 lowpriorityscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
	definitions=main-2104250048
X-Spam: Clean
Cc: kael_w@yeah.net
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Remove repeated uptodate check for
	buffer
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104250049
X-Proofpoint-ORIG-GUID: Fxxxn1J6PhFNrbXV8u3-YCsZ5JXE5ynM
X-Proofpoint-GUID: Fxxxn1J6PhFNrbXV8u3-YCsZ5JXE5ynM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1034 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104250049



On 4/25/21 10:57 AM, Wan Jiabing wrote:
> In commit 60f91826ca62 ("buffer: Avoid setting buffer bits that are
> already set"), function set_buffer_##name was added a test_bit() to
> check buffer, which is the same as function buffer_##name.
> The !buffer_uptodate(bh) here is a repeated check. Remove it.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index ad20403b383f..bd039fdbb27e 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -634,8 +634,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
>  		}
>  
>  		if (PageUptodate(page)) {
> -			if (!buffer_uptodate(bh))
> -				set_buffer_uptodate(bh);
> +			set_buffer_uptodate(bh);
>  		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
>  			   !buffer_new(bh) &&
>  			   ocfs2_should_read_blk(inode, page, block_start) &&
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
