Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39AAC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  1 Dec 2021 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MmcEUXdGhrJkn5uLwwijfRnopEYMlenfxippXbFVR8M=;
 b=m61Dc87FqarvGWVXxn2B9IvNJ/DVRHnjEBI7WXoItRVaojCxzRNhSAnKGuQPZ9Xqiv+pGW3jqeMl
   mFAWQNs9lA7B3voYlf2LlD+OiNeIGm/ybZ/zzWatX+Yz3nyU9wYJ+iAZbnzVD3ixDhZlTudBn3Ua
   BcuZEcP9Im1v4mVneKmV+zVLdMXkYHbIBA8rKLItOL+xkee6qqCh5UDqfHXbSSnYC1TCLLVlwhFs
   yeZArlGPokbTaXdGnaRvmXT1Usr0MaYkrSqgNZ3sDcimpD1XgmF1fMTQIyIj2UrC235GSDudnCJW
   fqcgXo56CtoLAwNECAd9CfxWc8Fx3dKUhqjvCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MmcEUXdGhrJkn5uLwwijfRnopEYMlenfxippXbFVR8M=;
 b=RJGul/6J81AbYDGT0gWyF98nCk4qUIGYPRzhUCpoS/JhWzNoHbc59tAIzz8MAfyeydgnWCFYI6PA
   wPhr1YGk/aP0VzhKGtGTpx8K9DCczn7Gip1swlcxzit8E7DObzG9cpBHuvREszpNzYFoWD1kcmXC
   l3nJaoQeVAlWd8UX5OmewF0ZWM1/iQMNQb+wn+rKlYOS9TFFMsp3bnbWPk62Bj2sUAjjuIzRgPk/
   WKbBj0r7u0393v4jCJ8cULFjHlI195GCoZTmTqOzdUgFOmp6omkwzHVLdN2uIRXTuoZ/HR5p9les
   hd4ag8Eubr9aUeGQo4EGKomm2rY6KkQ0HAIdhA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211111 64bit (built Nov 11
 2021))
 with ESMTP id <0R3F007TA0257100@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 01 Dec 2021 02:25:17 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <92d4d393-9734-9f7e-4440-20429bdac14f@linux.alibaba.com>
Date: Wed, 1 Dec 2021 10:24:58 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Wengang Wang <wen.gang.wang@oracle.com>, ryan.ding@oracle.com,
 Junxiao Bi <junxiao.bi@oracle.com>
References: <20211130104043.GB5827@kili>
In-reply-to: <20211130104043.GB5827@kili>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=126 phishscore=0 suspectscore=0
 clxscore=217 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010012 domainage_hfrom=8266
Cc: Sunil Mushran <sunil.mushran@oracle.com>, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix uninitialized variable in
 ocfs2_dio_wr_get_block()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R261e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
 TI=SMTPD_---0UywMFvQ_1638325498;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 3r_gDgg094zppbe_qoxSBenxo0tFaO8y
X-Proofpoint-GUID: 3r_gDgg094zppbe_qoxSBenxo0tFaO8y
Reporting-Meta:
 AAFofAS7nuN0xD/p0xGAzyhVoceDsGJjooEy2+/CeRPAXuD6kouxibSQ8lg2DKhn
 YRaeWKrZ6zDMZn4lx9C8/7TFYirtkvJx69ih/kIgC3dpJmtVZ9S/sa6mFpG0nvX3
 3VEwpIqe/WmSclo9coH3OZcRGOu3zBD2CX9QzqhWZhdgwJ3sbv6+H9Fdp6ivAXL1
 i5EQzg9PsM8nZ4mGRXyz7h/Vmv8hEjm8Kab05d5yQJA9Y2aA5L6YaoXcMCD8yZAP
 oJVShKDguBLIPJeFlD2fhOvjF8VUCgTC9Cuw904zKf/q9hY7B4SJiwtCHjDsmhPb
 CFoqWDkVZWR0a22WAHS4XPcNSNcsB+aH512D+v4junF79K5HYVqntBgtbmD19Gth
 OhpKPAB+1xvHjDW1RYiidaVdUBIv1VpFcQtlf1LHBuhev2seVaMIHsqRncN86Ijc
 zMzusivnT40C+V7/PopdkFD89Hm130KwMkG+ivJwpgfrHJKlW6CN0J2UJGrk/x5b
 tIbhHIfwPxF9ak0H4XSK1id6DoSwX2ZIjZljYS82vA==



On 11/30/21 6:40 PM, Dan Carpenter wrote:
> The callers assume that "*fsdata" is set on the success path, but
> that's not necessarily true on this path.
> 

In ocfs2_page_mkwrite(), since in this case no target page locked, it
will finally return VM_FAULT_NOPAGE (better VM_FAULT_RETRY?) and throw 
to handle_mm_fault(). So no problem as comments described.

But things seems changed since append direct io path started to use
write_[begin/end]. In this path, the target page is expected as NULL.
This needs more discussion.

Thanks,
Joseph

> Fixes: 5cffff9e2986 ("ocfs2: Fix ocfs2_page_mkwrite()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Please review this one EXTRA CAREFULLY.  It's from static analysis and
> the truth is I'm not 100% sure it's correct.  I'm also not sure that
> it's a complete fix.
> 
> Especially, please review how this is called from ocfs2_write_begin()
> to make sure that this doesn't break anything.
> 
> 
>  fs/ocfs2/aops.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 68d11c295dd3..a74a370f16f0 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1813,6 +1813,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  	if (ret == -EAGAIN) {
>  		BUG_ON(wc->w_target_page);
>  		ret = 0;
> +		*fsdata = wc;
>  		goto out_quota;
>  	}
>  
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
