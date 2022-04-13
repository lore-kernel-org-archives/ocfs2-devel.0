Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D90FC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 10:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8/v6VA+SMeYXE65eXd7rnC81DvtQzjibhY1abr29eAo=;
 b=0pJ2S9z525SR04UHN3hvb05ETDvKrCTtVyfa8ZY4TBIfy83CSVT854M0LIZyvlAqQp/zHzncCEdj
   yIRi2YERoFd7WxJdk0XB2DOypDoqpew09ktfGt3cMv2KhCKIAqLk3UJAGax4eMzYMISG4W24u/WO
   uoBfipJlp+uNORwSSPzeui8ByfLF4a3XU/AILsfNjOZ2atkZ/OmGcZn0TlQ6mXV7LV/nNz0Jn+Ue
   fg/hg5vB4oPd3lOWFoUZeg5oE5apjZHFAuqM81EHemBG6qceWLmA0TnlT3pUfBinQnoQxo3mRH5c
   KBibgZsNjTHkeyiYaMioovNAXP6GfxbT2Al65g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8/v6VA+SMeYXE65eXd7rnC81DvtQzjibhY1abr29eAo=;
 b=gd8vgF9CkDsKd04YOuUzftKDCWBtkjmEM+Snc+/xnqbaNh/tNJHJdLvcFmOZN2+gjj1Ix5iihLki
   QtiVTgJnLJJFW1YR5/YuaN9KFkGt0bK+376izFNROULbeGoFHJ2719EbKd9s8XKJL4lW0y2BTeSU
   AefPa75du4ImcNPvZrloToi02f3RpTGUjEkOCPIXrzTvsKN6PsahqAAyYPpORTlJzIY7C3VSwMQH
   OzxsAmfHsEwLdYcOHfG3sqeql2q2D1men4Jrwe53yGTFGnBWQ53sLDLoOcaICNC3ZZ4jCi7jh+fp
   XmnLcpDyj2ubtoUIY2kndp6ff/L7bKrcAOoiNQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA9007I2YDW8B90@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 10:56:20 +0000 (GMT)
Message-id: <edd8fd67-b0ea-0afc-efc5-62564fbfc4e7@linux.alibaba.com>
Date: Wed, 13 Apr 2022 18:56:03 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-3-heming.zhao@suse.com>
In-reply-to: <20220413082957.28774-3-heming.zhao@suse.com>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=0 mlxscore=0 mlxlogscore=999 clxscore=46 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130061 domainage_hfrom=8399
Subject: Re: [Ocfs2-devel] [PATCH v2 2/5] ocfs2: change return type of
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9zbQ.F_1649847363;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: e3cmNwJtqfvjnsbbw5VE3A_Kp813_gh3
X-Proofpoint-ORIG-GUID: e3cmNwJtqfvjnsbbw5VE3A_Kp813_gh3
Reporting-Meta:
 AAGDrFCUnI65DO9jlE8a7qFVuuvkL3D/kerlEaiHmm9IYE6Fm/Q60Mfn9RoHkGMM
 xNNKlIDKKtFHz1D/URqpJ1sDbi/EguWBSmxJx08ayhQ3sJjCOIw/Wz7tnEfHc2pe
 sdTR+wiSWGDwG1agDtP8boqBKALJ5XARnXQ2Y84t2Loe373Yy0shMZSm0zer8hyi
 hukQ4LLBX48NyUt+HtMmmEnNb4aHTbZJwzSrZUrfYsjdnZgTWBmfyo+dhbMoDmC+
 ehs17E4MddsrxT4nCKS2IQ1ErvIdBqRMwbDnEk7iuMgEsoVZPSM9rxh4NY+lmMBp
 zPZ/j14SZkKQ2NZ6FQlpiufzltdO4EkSkC9fJFXEUArE3i5UC8ks3kBFwDMKmd0H
 rkhm33HWKrh6IZlLZ1YrEUEozyxAePIuMPYNYWTmMxjmr84LTzEccitIGBWic3/j
 8JM6gPcpxRzWurOJUGVvsac7az9hqwVNv42qIRAYfJ7oGgxpTYCPS4eBRmUh7v+D
 S5/m/x1RWW6Mbo4pXgafWojej/0Ah4QKRgrFda0h+4gq



On 4/13/22 4:29 PM, Heming Zhao wrote:
> Since ocfs2_resmap_init() always return 0, change it to void.
> 
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
> index babec2c9d638..7076125f5b46 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2111,11 +2111,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
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
