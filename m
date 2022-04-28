Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0191CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 11:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5lZD2yBrRpjupBBWBEbWq5wZci5no3CzWDXFCJFg3D0=;
 b=cUKIpiTmkH7VkaJ+XQjWOLcxHUzGXZ3SZgjajwhoyIIiZCK38lsO2WWk1rWIdmR7thWOvDFe53C6
   rt9X6Z/1HqJatVEQjMp5qScJCIQcaoT8k9XfaivL5xL8wKCFOSXB+OWBCZFEYksSlXeTsyfXmrIO
   GfkrgP+szHtE8NdDq8sQW0MC2INPoA/Ea8fJkPRnMSmx/UeOCnI3rpZQxR34+P8qWalJ5fyBb62+
   QzZY6NO523xWWkuJJfyKKsN9t/RlMjbZe8plhQbtWbT0yVvp6S405zYKlByneDXEwVYYad/JWPy4
   YF4cE7+DE+b6hM4SxAVem50oxx5X5c0dqdk7KQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5lZD2yBrRpjupBBWBEbWq5wZci5no3CzWDXFCJFg3D0=;
 b=afZK+42oUWRVKUci7FvfgUAbYt4O1x8GuAZmz9VFXNtMxl4KKmXMlGaz4gHQXEVFJAKJCRsv4Fsc
   XG/UP5DHX9Re3WNGcdpvCOhZ1J4KiLL8O4tgVmWU9DAhGLlUgm+1uWkDvi34ZftFDQcV9W+MCKFR
   pnaYQ8F6hELjXOOGuz9ck8q5c8BudHf2OoKwpzB7lHhFLXJ3FKemYLdwUbh9ia65FLN+aEml5Zmb
   c5LZ3ZfXeVVzHgJQR5IiK4Z3y+RjYpH741nHwVt4ULYFyza7HWAJDh5ce76fcNvK1vEuzxVuDCcT
   77cvFhrboxafF5XDgeQq9EPySKwzwGAiK8u4PQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB100LKERXYGW70@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 11:29:58 +0000 (GMT)
Message-id: <f40976c8-2ac1-9ec3-d4ab-ddad2bdcd7bf@linux.alibaba.com>
Date: Thu, 28 Apr 2022 19:29:43 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-3-heming.zhao@suse.com>
In-reply-to: <20220424130952.2436-3-heming.zhao@suse.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10330
 signatures=694622
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 spamscore=0 adultscore=0 clxscore=132 phishscore=0 mlxlogscore=999
 priorityscore=90 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280070 domainage_hfrom=8414
Subject: Re: [Ocfs2-devel] [PATCH v3 2/5] ocfs2: change return type of
	ocfs2_resmap_init
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VBaQiN-_1651145383;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: Rxq13s4_SLhgm3tF6UscJ9n37bbfoyDA
X-Proofpoint-ORIG-GUID: Rxq13s4_SLhgm3tF6UscJ9n37bbfoyDA
Reporting-Meta:
 AAH3diOHwjW0zixudmc46tUthj3bDRU1WezrbHoCC6AWLPzRVHaoBwD1QNlK4MSu
 +qPp2lrWknbnH6mfnIvbh7ZeTxKQyTjrywwp2JmlAadhDXv2ASDVsiOBEUze7Rg7
 A4C1jAXubl/3GeoZN6LmkNYB4wqjqog8CQbUW5NfycgTVGzoY4WYa/5Uvyb6OabC
 G5SqKjFo+oWVhm0vloeOhdRAmYWlBLRXrLF3GEVjI3iWYR5/NYP8+LM/fS7ACJkn
 ONrq1B6F4HE+TIOrz32OErmSzqENAo9CQmk7aJnnmut8mfb9Qf60RbzMQZEMCbPZ
 slzoe3RU8CNE9rBL5JwpzNAPPpX2W8dZZU+Nbp9EX73MQZ780/GIL/BTmr0KWvLH
 wrKj2wjqlMYSMlWbBq8fYVrnRzzLPgDk0THVNaahHR1tvcTG7dOGC4Wc2SyxStBr
 F2rpVxTj01LbEj/daKzD5x5Wji2t9KJfWIXIyFRX0HUgB8NmzDlZ/vqYa5d3V6DQ
 ZdzvC5vl/lha02yCIdSQrNOQFd5MO28nZe8mH+eLORPd



On 4/24/22 9:09 PM, Heming Zhao wrote:
> Since ocfs2_resmap_init() always return 0, change it to void.
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/reservations.c | 4 +---
>  fs/ocfs2/reservations.h | 9 ++-------
>  fs/ocfs2/super.c        | 6 +-----
>  3 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index 769e466887b0..a9d1296d736d 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
>  	resv->r_flags |= flags;
>  }
>  
> -int ocfs2_resmap_init(struct ocfs2_super *osb,
> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>  		      struct ocfs2_reservation_map *resmap)
>  {
>  	memset(resmap, 0, sizeof(*resmap));
> @@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
>  	resmap->m_reservations = RB_ROOT;
>  	/* m_bitmap_len is initialized to zero by the above memset. */
>  	INIT_LIST_HEAD(&resmap->m_lru);
> -
> -	return 0;
>  }
>  
>  static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
> diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
> index 677c50663595..ec8101ef5717 100644
> --- a/fs/ocfs2/reservations.h
> +++ b/fs/ocfs2/reservations.h
> @@ -73,15 +73,10 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
>  
>  /**
>   * ocfs2_resmap_init() - Initialize fields of a reservations bitmap
> + * @osb: struct ocfs2_super to be saved in resmap
>   * @resmap: struct ocfs2_reservation_map to initialize
> - * @obj: unused for now
> - * @ops: unused for now
> - * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
> - *
> - * Only possible return value other than '0' is -ENOMEM for failure to
> - * allocation mirror bitmap.
>   */
> -int ocfs2_resmap_init(struct ocfs2_super *osb,
> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>  		      struct ocfs2_reservation_map *resmap);
>  
>  /**
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 311433c69a3f..8014c690ef72 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2110,11 +2110,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  
>  	init_waitqueue_head(&osb->osb_mount_event);
>  
> -	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
> -	if (status) {
> -		mlog_errno(status);
> -		goto bail;
> -	}
> +	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
>  
>  	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
>  	if (!osb->vol_label) {

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
