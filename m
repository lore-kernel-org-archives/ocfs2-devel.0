Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D9DC43334
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Jul 2022 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sVpmmzDQgZudV0CXV27KjnYLpWXrU+No3oCni9li3Z0=;
 b=J7imGxfMfLAOThNfYhhOgV4laX8w6yZKSR6dg3INZIGukJ7UToZc2GNb8LkF3HIW8uXZUyAebWJD
   gN9dILj+Sn1IDhrEJG0P2SJgCERn/iqnVsxril1d5LCjV0YTTMuMz8V21I7Ce5OVo/RpPpuxjESh
   ouqn956HhCoFCWswf8+6uYITTnKjRxFBEQ8m7N+TdrTag+3K5RQZi87GJ5yJMdieby9SeDeRyabl
   Ga5VURH47Ndevw0FWHWCqcqB9BtSPzjfcounamOhMsOkzNnkKJq30LbAEbN2W416WJ2eJESRvuuZ
   cNTqPxemW0tB0koIuO6ENRCGjHan+Lhz8e7euA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sVpmmzDQgZudV0CXV27KjnYLpWXrU+No3oCni9li3Z0=;
 b=TquYQmyvOTzlE8S4edE3vDjX0sB6C2PP6lIJ0hTGnyLsaIV2hr/uC/jlLqFLKEu5/LmxM0kx+szI
   VseESSMnR/eEvXNCFTW5ztfzSt8e9dvhhI6ZjbbJyOQB57VbYvPpIU2meE4SoqMEnItKJ/DI2jQV
   KvwOPWRwEyEPIqldOiN/HIWbdq2Nwj+n3iGbrcPQQT8mXeQyu9KzmphqJu0gnFtVCBkDCe6UBmnd
   Xwv1NkGpVr9itHolJUqH3GghjBnJO6ULnjfCkvgbQI73b3J0q3fACGICMYuHJv4ER1pXroeMM4a+
   nF540bF80YZQmMt5tut40Dp9jV4ot0KDtxDo/w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFE00H35F06JRC0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 22 Jul 2022 01:33:42 +0000 (GMT)
Message-id: <9e8b39ec-bfda-2e60-2626-f55ec95bd268@linux.alibaba.com>
Date: Fri, 22 Jul 2022 09:33:22 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 akpm@linux-foundation.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
 <4d4a6786e8ad522bfad6d2401b7f6634f8af0e5d.1658436259.git.christophe.jaillet@wanadoo.fr>
In-reply-to:
 <4d4a6786e8ad522bfad6d2401b7f6634f8af0e5d.1658436259.git.christophe.jaillet@wanadoo.fr>
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10415
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=30 spamscore=0 adultscore=0 clxscore=46 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220004 domainage_hfrom=8499
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 3/3] ocfs2: Fix a typo in a comment
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VK2qCxt_1658453602;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: -OeFk71M2PFb8-aqjI-X2G5J4pX8ZCpR
X-Proofpoint-ORIG-GUID: -OeFk71M2PFb8-aqjI-X2G5J4pX8ZCpR
Reporting-Meta:
 AAEc6djJi4XY4xrczZzGII9JzdcUxiSiQUGfv6I9EXeCBpxGzOTdwqSFBZNB23qE
 OSLOtY+2R6dQPxh17E+Et8qbQZIUUzn/OJyRIcUZptXYk8aGS0933yIk42RkOWeB
 kvc1F04KiTM6y01WbQYUb1myw1iwmdAP03HoIOX/8TBIrKetwME3djVAzqZUXEre
 c1zzwnhaUMfUYjA+Q+yCmW8zDAJs11dqjFGhVWMr4snRvdXpCyPGmdV0zKIs7lxV
 ji7QQVhxxyQLFoiB47uiTug27BqVySY1K99JQ/r4o7Hq1gyw+z7SZElkLFqRxwP6
 4Qyh2lxSrlNZwO/PrKVMS14jwZOXqKJo7i7P8VvhnmaMnXpzqbVGOQQ0KVMd6tBW
 +WZm14aTCxO4mgrzmzclmMRIDaYGF92EikI8OnfnUHZ+bMfzUFkv9Trqu28jPtxf
 7SaaP3h2jhX246PZSnv7ooSBpooAZDbnyr0kRw402NgwEImUtr029yzajxOVlkVR
 DNBH8VfgDyIAadG0Pa9T/eNWePVFLkerb6+IGht/5Vx1



On 7/22/22 4:49 AM, Christophe JAILLET wrote:
> s/heartbaet/heartbeat
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v1 -> v2
> - this patch is new in the serie
> ---
>  fs/ocfs2/heartbeat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
> index dd29d60af154..22da768e65b7 100644
> --- a/fs/ocfs2/heartbeat.c
> +++ b/fs/ocfs2/heartbeat.c
> @@ -2,7 +2,7 @@
>  /*
>   * heartbeat.c
>   *
> - * Register ourselves with the heartbaet service, keep our node maps
> + * Register ourselves with the heartbeat service, keep our node maps
>   * up to date, and fire off recovery when needed.
>   *
>   * Copyright (C) 2002, 2004 Oracle.  All rights reserved.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
