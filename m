Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBECC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Apr 2022 09:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QaZ9FYbcACwiKTeYhLTuyEVRzBlUq1HFKJC2Y0YLcWA=;
 b=fKhF3YkFl1URP2JpZTatdJX+PfKlb2jUtgy02kP7jlvcK7xrNLuqpG1o/U7eRU3CETW92elW0glh
   8ii72ATCUT6ErJrzyCMBOq1MKnd9BHt4TszvDqGCMfv4FDsCOkdYcDG1eoUvhDCMqv1LF9bKUSm7
   /hejPSjtkiHhn61gUc6HZdkl8U3IgYuMk/pGao4QeETC+6yKt5V9qFRgk6erAh9dMoOKLkUybhDc
   RsEDWSxA7nK8OGwtUXKW8e2Q5/rSMKiAnAgYpTDeIYma77wPDGfB9uPiRDA/jOn/lYYKhj9Kraw3
   yfifsq+BhrnUG4yYNfjkuJ/4KLCbGFAfzjU6+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QaZ9FYbcACwiKTeYhLTuyEVRzBlUq1HFKJC2Y0YLcWA=;
 b=KZHY5hkBXZ7jghobyUiD/mu4SPR9LL2SD0Pi2c/4GMY0+HhC8kXsHNBZPGtV4CFNT+u1HtzvQkvj
   lT7EzULNS+cOoQy87948d97bYMYkqYm/ZzS8xiAXx5lXbqrSaMMhVPhc0MMyIXbBTPma+h7BLvFW
   IGruplZEtPMPkVUpqC9N4QZB2VzipljJWUygzsxMNTUToE9QW0YvywXyBa70r73EkuLOUuKm9PbG
   tWP4LJyeSaeJxf+P3/QFDHMN+5EdOZxfHs1tFZV5weDPJawQBTQk3kEiRnVRZzZgpz6e01mVUtYP
   p5UFTgW8ofEgOG0Q8C1F2l5BtLwV1Mfqlz2/EA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA600EJQ5ADSR30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 11 Apr 2022 09:35:01 +0000 (GMT)
Message-id: <d299dcf2-d160-9db0-acdf-201fe7be8089@linux.alibaba.com>
Date: Sat, 9 Apr 2022 21:14:14 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-3-heming.zhao@suse.com>
In-reply-to: <20220408103012.1419-3-heming.zhao@suse.com>
X-Source-IP: 115.124.30.42
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 impostorscore=0 clxscore=9 bulkscore=0 mlxlogscore=999 priorityscore=30
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090087 domainage_hfrom=8395
Subject: Re: [Ocfs2-devel] [PATCH v1 2/5] ocfs2: change return type of
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9aO.UW_1649510054;
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: v3kfM2I4v3AeJDo9oDJ25UfxHGUa5Siq
X-Proofpoint-GUID: v3kfM2I4v3AeJDo9oDJ25UfxHGUa5Siq
Reporting-Meta:
 AAFWMRea436EVcIe6w4fPNqswjUG2OgTThLchzMrX9mxNGMtHdbdYhQ76xK/9EU+
 DN60VIHffgohBKnr5uNxfaBmRR0QIfHBDAk7oErRGMGJXY3TTqsr2M9NUynO4j2u
 f6p8qa2JT4XW3idus0Nh7exMWrMqRnRKQ66jeY16GdOK3QDvVs0aNIW+DPNZxWZC
 nKtvGw9kYdD9u4/2UiznmKPklRyjDrp7QXcGIz1Es2qPSEFCdRKtu1V+Z0ZZBY1K
 Mkw0kIbza4wDggBMeEGGE3UlJF85UOpd93HpSdD3mRMC/3N7QPKW3qSaaKvcpzQC
 DoQ4a1eryScKkAhlwdlwBzEKkBKPrxDDUG85NWnKb9J9dlGtnQ+QEp/bPptJ26dV
 NOzM0sbCKQtmGuAfAm9MG7AJEeeHjV/ojHZTlUQHsIFYhYNdyQC4ua4IzdXGYhTW
 d2LyhfM2AN2xuujxKWSxFG5HMZWZbhSp6Va48GE0+3VgaGwBvlPAUFpfjIr0PePq
 7AZxfIOr4LJTLPBnVpN6VAv2s9zYrNWIlxBuFYOWTgzX



On 4/8/22 6:30 PM, Heming Zhao wrote:
> For rewrite error handling of ocfs2_initialize_super, change this
> function return type from int to void.
> 
Since ocfs2_resmap_init() always return 0, change it to void.

> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/reservations.c | 4 +---
>  fs/ocfs2/reservations.h | 5 ++---
>  fs/ocfs2/super.c        | 6 +-----
>  3 files changed, 4 insertions(+), 11 deletions(-)
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
> index 677c50663595..532d42eb6db7 100644
> --- a/fs/ocfs2/reservations.h
> +++ b/fs/ocfs2/reservations.h
> @@ -78,10 +78,9 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
>   * @ops: unused for now
>   * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
>   *
> - * Only possible return value other than '0' is -ENOMEM for failure to
> - * allocation mirror bitmap.
> + * This function does initialize resmap job.
>   */
This comments is meaningless, so just remove it looks better.

Thanks,
Joseph

> -int ocfs2_resmap_init(struct ocfs2_super *osb,
> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>  		      struct ocfs2_reservation_map *resmap);
>  
>  /**
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 8391592817f8..f91c5510bc7e 100644
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
