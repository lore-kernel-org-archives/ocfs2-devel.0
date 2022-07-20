Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E22C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jul 2022 02:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v7iAqxXI0i46uW006INj6hKnmvWFeS5HJhopaEZ65YY=;
 b=IU7zzIZmIdxsVbuZEEZ2DVSJqXaclMvY2vRFCDnkZeELz2Grs8weeASCbAn3TnW8gJsAtHrvfC7j
   +PqywEpLmM4Ht5c2xrXT6SDfJijLLA9J2d2PFaYKZXK81g2JFBofryVsHWMF82bLa/+XQRndhs1D
   Vpgqy7X8ZKnVAC0N6vEcTk9DFGZzy+Cpii/+6OLDAns9KkcIKNfQkvOBDnOij/g2nXFTRb13jQYS
   i7BEEuXdVtzx9FHmaUxMV4dUkk198nROH0lSTFtptYRPMp3t+rH9rLaKXOemX6rwhcyisPNJ0DSd
   wD8PGkJQMy/ng8waVxr2DrEE/aEJDRIWNfrG5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=v7iAqxXI0i46uW006INj6hKnmvWFeS5HJhopaEZ65YY=;
 b=nS474GMwuQgq5Iy00V92PJF7koqctTA+a0MjSE0Dfgf6wVk9a1wl0gYpswwCSiwBLvhXdPapBczR
   qAW+k2ScHUVlVCY0zKmSTqmjWM8CPk6B7J0Qiy6WKnFfqdB7xPS4AMnWKI6mz6cvDmvjdtP5vwBG
   MDLPDz62HSX/Gp/8TVjh9Abs3yPUvlYePQ+cqBJWBVnbzjBrefYeezfhukNbIV7GD0jq5jmqPrhw
   hpd9mgRxWvC5fwmtonwM+qUmMGPYjp5P5qGPS//NCn9NWJhcjgI1xXrx2a9DyulWhFEEhl0xzZgl
   +auJRvoJwLCz8fER47OEcusfHRtEUyeCBApdIA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFA00JK9R6Z1A40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 20 Jul 2022 02:06:35 +0000 (GMT)
Message-id: <e6c41a71-7649-a182-bdcd-678803efd6cb@linux.alibaba.com>
Date: Wed, 20 Jul 2022 10:06:15 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <0a0d6e9bf9d10f67b7a0c1cdd6176cdd0ad2e1f6.1658224839.git.christophe.jaillet@wanadoo.fr>
In-reply-to:
 <0a0d6e9bf9d10f67b7a0c1cdd6176cdd0ad2e1f6.1658224839.git.christophe.jaillet@wanadoo.fr>
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10413
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=-3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200007 domainage_hfrom=8497
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/3] ocfs2: use the bitmap API to simplify
	code
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R381e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VJukRdZ_1658282775;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: G8QBZFGU9Vl0GfBoK9qjEhXW70nWql7D
X-Proofpoint-ORIG-GUID: G8QBZFGU9Vl0GfBoK9qjEhXW70nWql7D
Reporting-Meta:
 AAGCSjZ85Ye9T+Jn9Cna+IQ0uPQAHmTpooYcQ9ZYGShcZEgbshqTaT3ca5UG7jej
 hW6sYY8dyPhwvTAcMgkJ70T40X4uoGmeFxpmIjMIPDY3bQOWSVKmlJ3p8g6s4Sdt
 wO5XcTJlJcLiKyvj2/eHgW4UWdIJjYDYHukESa4ix8jcrk2ve/ssKdfFmGwweTn/
 vSax+yi1NVBQ8X+tTL+gkseNOyW/bFze0AcKQZeAKNLlIih27rpLL+xi07odl7K6
 g3LKpzzRcnMyUM3WskcKRRdFpJbyFnJUBbNBMpAvz0Rh4I6nZV5nUicxWbuXSa4d
 x6k5IJ58P+3uHY2QwM0VZYORUnc3eRkoju45VUEfn+OjG2Nvb6HtC80eGyNoS313
 R4Yq3kuCo2YGMvJolH68evsagetCX9UOaKwb/NyUBDxntM39l9glHF748DeaF2ae
 M2v9wLjy1qkGYy8UCgu9A/HjAt5rlLTHvGFH2toJsUPJGqakPJxXf541XYinuhyg
 ywrhqtN0wWfS65S6hdYfGa/Jvr7fOqCNtO1alpBj7y0=



On 7/19/22 6:05 PM, Christophe JAILLET wrote:
> Use bitmap_zero() instead of hand-writing it.
> It is less verbose.
> 
> While at it, add an explicit #include <linux/bitmap.h>.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/heartbeat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
> index 4863ad35c242..e243cd99e63f 100644
> --- a/fs/ocfs2/heartbeat.c
> +++ b/fs/ocfs2/heartbeat.c
> @@ -8,6 +8,7 @@
>   * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
>   */
>  
> +#include <linux/bitmap.h>
>  #include <linux/fs.h>
>  #include <linux/types.h>
>  #include <linux/highmem.h>
> @@ -29,8 +30,7 @@
>  static void ocfs2_node_map_init(struct ocfs2_node_map *map)
>  {
>  	map->num_nodes = OCFS2_NODE_MAP_MAX_NODES;
> -	memset(map->map, 0, BITS_TO_LONGS(OCFS2_NODE_MAP_MAX_NODES) *
> -	       sizeof(unsigned long));
> +	bitmap_zero(map->map, OCFS2_NODE_MAP_MAX_NODES);
>  }
>  
>  void ocfs2_init_node_maps(struct ocfs2_super *osb)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
