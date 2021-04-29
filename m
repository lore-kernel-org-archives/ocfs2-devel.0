Return-Path: <SRS0=g/kM=J2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED89C433B4
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 17:14:50 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 525B361447
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Apr 2021 17:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 525B361447
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TH5pCC084944;
	Thu, 29 Apr 2021 17:14:49 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 385ahbw5ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Apr 2021 17:14:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TH6ihS143376;
	Thu, 29 Apr 2021 17:14:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3wk40f-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 29 Apr 2021 17:14:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lcAFN-0006gC-Vd; Thu, 29 Apr 2021 10:14:41 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1lcAFK-0006fo-NA
	for ocfs2-devel@oss.oracle.com; Thu, 29 Apr 2021 10:14:38 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13TH6jcB143720
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 17:14:38 GMT
Received: from oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 384w3wk3xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 17:14:38 +0000
Received: from userp2030.oracle.com (userp2030.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 13TH3DDr007033
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 17:14:37 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by userp2030.oracle.com with ESMTP id 387x7qbt45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 17:14:37 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-21-k4Esr1GMNZmGtSNYPn97yw-1; Thu, 29 Apr 2021 13:14:33 -0400
X-MC-Unique: k4Esr1GMNZmGtSNYPn97yw-1
Received: by mail-wm1-f70.google.com with SMTP id
	y184-20020a1ce1c10000b0290143299f39d7so42689wmg.4
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Apr 2021 10:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=8RXzvV9OayhG64BmNGxjD390UiscULVbN0Giy/F/zR4=;
	b=dly2fc+nsMzc4TVA1VxhSVDYIGoM2gDcokIzSdMmrsKH9c8C+vWmOaPJqtrxv9vSLN
	c9IxyV7My094Z5Y39tn9SSNR8mCHTm9wfayuSOZtWf9DHkYJGkp7TfzbOAgU3sBTqd2y
	mIhFW4zBWjrDjQ52q739NaEQZ8MR91m/ZmWK7gcqEPpFFnKvthxsUIip+KXYN58fOOdZ
	zPbh+dwvRdXQld1IWw3IL1231SXNtL2lboltrctEeSOIgTQ0JidbBzEAYWsiBnTjOfzl
	P3bivKSX/mOyf6/K90RsaSPsB3OhPpelG9LeF3YXjQGR3N3cNIcn4IVlkTmY6Ul0XIuW
	ssTA==
X-Gm-Message-State: AOAM533+o9G+JfQwEV3pwRGJ9U1BGm1uEntED7mADKNOpD9lUD+1sm4I
	J7jSiC231sL0RC4nayKiuujZM+SV+h//DpyX6FP144+LRI7vdDvYr//xZZFkOVWCg/RqDtbrfYN
	mKB4TWb0xUZJy1+uNdBEMt5RQ5i3+S+ehRCIGiQ==
X-Received: by 2002:a7b:c5c8:: with SMTP id n8mr1303762wmk.2.1619716471704;
	Thu, 29 Apr 2021 10:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqqJNwW6qO+gOOYbgUVgcP4w2CGtX5ilJ2ey5tGpv23Te/nOWasO76frpbdhzHgMiUs34r0vc0+rJcpHDH1co=
X-Received: by 2002:a7b:c5c8:: with SMTP id n8mr1303722wmk.2.1619716471400;
	Thu, 29 Apr 2021 10:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
In-Reply-To: <20210426220552.45413-1-junxiao.bi@oracle.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 29 Apr 2021 19:14:20 +0200
Message-ID: <CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:13.110.208.0/21
	ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 ip4:148.139.2.2 ip4:148.139.3.2
	ip4:149.72.0.0/16 ip4:149.96.1.26 ip4:149.96.13.2 ip4:149.96.132.2
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-PDR: PASS
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:13.110.208.0/21
	ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 ip4:148.139.2.2 ip4:148.139.3.2
	ip4:149.72.0.0/16 ip4:149.96.1.26 ip4:149.96.13.2 ip4:149.96.132.2
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2104060000 definitions=main-2104290106
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH 1/3] fs/buffer.c: add new
	api to allow eof writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290107
X-Proofpoint-GUID: yp-sRhE2qm9wCXS1oWwfk-4RoCEREqnO
X-Proofpoint-ORIG-GUID: yp-sRhE2qm9wCXS1oWwfk-4RoCEREqnO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290107

Junxiao,

On Tue, Apr 27, 2021 at 4:44 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
> When doing truncate/fallocate for some filesytem like ocfs2, it
> will zero some pages that are out of inode size and then later
> update the inode size, so it needs this api to writeback eof
> pages.

is this in reaction to Jan's "[PATCH 0/12 v4] fs: Hole punch vs page
cache filling races" patch set [*]? It doesn't look like the kind of
patch Christoph would be happy with.

Thanks,
Andreas

[*] https://lore.kernel.org/linux-fsdevel/20210423171010.12-1-jack@suse.cz/

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/buffer.c                 | 14 +++++++++++---
>  include/linux/buffer_head.h |  3 +++
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 0cb7ffd4977c..802f0bacdbde 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1709,9 +1709,9 @@ static struct buffer_head *create_page_buffers(struct page *page, struct inode *
>   * WB_SYNC_ALL, the writes are posted using REQ_SYNC; this
>   * causes the writes to be flagged as synchronous writes.
>   */
> -int __block_write_full_page(struct inode *inode, struct page *page,
> +int __block_write_full_page_eof(struct inode *inode, struct page *page,
>                         get_block_t *get_block, struct writeback_control *wbc,
> -                       bh_end_io_t *handler)
> +                       bh_end_io_t *handler, bool eof_write)
>  {
>         int err;
>         sector_t block;
> @@ -1746,7 +1746,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>          * handle any aliases from the underlying blockdev's mapping.
>          */
>         do {
> -               if (block > last_block) {
> +               if (block > last_block && !eof_write) {
>                         /*
>                          * mapped buffers outside i_size will occur, because
>                          * this page can be outside i_size when there is a
> @@ -1871,6 +1871,14 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>         unlock_page(page);
>         goto done;
>  }
> +EXPORT_SYMBOL(__block_write_full_page_eof);
> +
> +int __block_write_full_page(struct inode *inode, struct page *page,
> +                       get_block_t *get_block, struct writeback_control *wbc,
> +                       bh_end_io_t *handler)
> +{
> +       return __block_write_full_page_eof(inode, page, get_block, wbc, handler, false);
> +}
>  EXPORT_SYMBOL(__block_write_full_page);
>
>  /*
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 6b47f94378c5..5da15a1ba15c 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -221,6 +221,9 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
>  int __block_write_full_page(struct inode *inode, struct page *page,
>                         get_block_t *get_block, struct writeback_control *wbc,
>                         bh_end_io_t *handler);
> +int __block_write_full_page_eof(struct inode *inode, struct page *page,
> +                       get_block_t *get_block, struct writeback_control *wbc,
> +                       bh_end_io_t *handler, bool eof_write);
>  int block_read_full_page(struct page*, get_block_t*);
>  int block_is_partially_uptodate(struct page *page, unsigned long from,
>                                 unsigned long count);
> --
> 2.24.3 (Apple Git-128)
>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
