Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C27C433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:50:45 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F000264DF9
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:50:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F000264DF9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SGhxT1101239;
	Thu, 28 Jan 2021 16:50:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 368b7r55r9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 16:50:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SGjslP117290;
	Thu, 28 Jan 2021 16:50:42 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wjub45s-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 16:50:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5AVF-0000Sg-1z; Thu, 28 Jan 2021 08:50:41 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <willy@infradead.org>) id 1l5ASc-0000Ge-AI
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 08:47:58 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SGies7001914
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 16:47:58 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 368wq1xjrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 16:47:58 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SGiMYZ005086
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 16:47:57 GMT
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by userp2030.oracle.com with ESMTP id 36c0pa8efp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 16:47:55 +0000
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1l5ARp-008hlF-CH; Thu, 28 Jan 2021 16:47:23 +0000
Date: Thu, 28 Jan 2021 16:47:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Message-ID: <20210128164709.GZ308988@casper.infradead.org>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
	<DM6PR04MB4972DA86892CF4531440064F86BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DM6PR04MB4972DA86892CF4531440064F86BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
X-PDR: PASS
X-Source-IP: 90.155.50.34
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	adultscore=0
	priorityscore=178 clxscore=333 mlxlogscore=999 malwarescore=0
	lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280082
X-Spam: Clean
X-Mailman-Approved-At: Thu, 28 Jan 2021 08:50:40 -0800
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "alex.shi@linux.alibaba.com" <alex.shi@linux.alibaba.com>,
        "osandov@fb.com" <osandov@fb.com>, "agk@redhat.com" <agk@redhat.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>,
        "jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Naohiro Aota <Naohiro.Aota@wdc.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
        "jth@kernel.org" <jth@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: [Ocfs2-devel] [RFC PATCH 02/34] block: introduce and use bio_new
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280082
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1034 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280082


FYI your email is completely unreadable to those not using html.
I can't tell what you wrote and what Damien wrote.

On Thu, Jan 28, 2021 at 08:33:10AM +0000, Chaitanya Kulkarni wrote:
> On 1/27/21 11:21 PM, Damien Le Moal wrote:
> 
> On 2021/01/28 16:12, Chaitanya Kulkarni wrote:
> 
> 
> Introduce bio_new() helper and use it in blk-lib.c to allocate and
> initialize various non-optional or semi-optional members of the bio
> along with bio allocation done with bio_alloc(). Here we also calmp the
> max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com><mailto:chaitanya.kulkarni@wdc.com>
> ---
>  block/blk-lib.c     |  6 +-----
>  include/linux/bio.h | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index fb486a0bdb58..ec29415f00dd 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>                         sector_t sect, unsigned op, unsigned opf,
>                         unsigned int nr_pages, gfp_t gfp)
>  {
> -       struct bio *new = bio_alloc(gfp, nr_pages);
> +       struct bio *new = bio_new(bdev, sect, op, opf, gfp, nr_pages);
> 
>         if (bio) {
>                 bio_chain(bio, new);
>                 submit_bio(bio);
>         }
> 
> -       new->bi_iter.bi_sector = sect;
> -       bio_set_dev(new, bdev);
> -       bio_set_op_attrs(new, op, opf);
> -
>         return new;
>  }
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c74857cf1252..2a09ba100546 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
>         if (!is_sync_kiocb(kiocb))
>                 bio->bi_opf |= REQ_NOWAIT;
>  }
> +/**
> + * bio_new -   allcate and initialize new bio
> + * @bdev:      blockdev to issue discard for
> + * @sector:    start sector
> + * @op:                REQ_OP_XXX from enum req_opf
> + * @op_flags:  REQ_XXX from enum req_flag_bits
> + * @max_bvecs: maximum bvec to be allocated for this bio
> + * @gfp_mask:  memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *    Allocates, initializes common members, and returns a new bio.
> + */
> +static inline struct bio *bio_new(struct block_device *bdev, sector_t sector,
> +                                 unsigned int op, unsigned int op_flags,
> +                                 unsigned int max_bvecs, gfp_t gfp_mask)
> +{
> +       unsigned nr_bvec = clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);
> +       struct bio *bio = bio_alloc(gfp_mask, nr_bvec);
> 
> 
> I think that depending on the gfp_mask passed, bio can be NULL. So this should
> be checked.
> 
> 
> true, I'll add that check.
> 
> 
> 
> 
> +
> +       bio_set_dev(bio, bdev);
> +       bio->bi_iter.bi_sector = sector;
> +       bio_set_op_attrs(bio, op, op_flags);
> 
> 
> This function is obsolete. Open code this.
> 
> 
> true, will do.
> 
> 
> 
> 
> +
> +       return bio;
> +}
> 
>  #endif /* __LINUX_BIO_H */
> 
> 
> 
> Thanks for the comments Damien.

> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
