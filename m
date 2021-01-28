Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C25C433E0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:28:21 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1CB5B64DEC
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CB5B64DEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SGA0dt019240;
	Thu, 28 Jan 2021 16:28:20 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 368b7r50ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 16:28:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SGAElN132666;
	Thu, 28 Jan 2021 16:28:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wr0jcyd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 16:28:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5A6X-00080s-3j; Thu, 28 Jan 2021 08:25:09 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <rjwysocki@gmail.com>) id 1l54Qx-00052T-Gb
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 02:21:51 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SAGLnh178095
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 10:21:51 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 368wr04tab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 10:21:51 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10SA4GYp020513
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 10:21:50 GMT
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com
	[209.85.210.41]) by userp2040.oracle.com with ESMTP id 36btath1t6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 10:21:50 +0000
Received: by mail-ot1-f41.google.com with SMTP id i20so4676798otl.7
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 02:21:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=HDfQ7EgSz4He6IVrUzqy89nGy356H19n/4Ap6Knawyw=;
	b=AxH/iTsOUizpZ6bAzrB22pL3Dxs8zaMV7xq3C4MguzJItjmGNii2jK2btiB9PDy9DL
	9UAsSKkDiY5NeD+0mz3SRqXg7llIjsaHVNNQPV7rjC0DYj3J7WLtdps3ALJnfUK9228s
	CggojisZHPbrubSH+Ln+BwXgLRdZFGVq0J2nvlLzc9C0op+HEg+1IB5Fmytg9GGMyE9f
	6cncLAJ/Liujecm3/S2HqwxIFRhBbxzA442lEb0ERHPHRB21OcieLbggAJwu6zTX2gRA
	NGHtxjuq9O+QSxHf8nKLJS81zZGMxggELwrIeeXm7l1uV/jm1qc0CNmypKJFvqg3Vp7p
	pPgA==
X-Gm-Message-State: AOAM532uVbuBCr6QWLRwIqd/sXqbsq3AK/Zz/DZ4uJuZIhXppynkF/m8
	4DtfrQMv+7KwmcC3QcWa2HxJEHqM3rB4+QlsVic=
X-Google-Smtp-Source: ABdhPJwJviHVEMHN6dwg9pHl9sFzPeOTWi/Tyw7MUMRzUkqGbWVHXybuLc31QSYFbmu849bxozre+7WWIBRJddZRpNc=
X-Received: by 2002:a05:6830:2313:: with SMTP id
	u19mr11117098ote.321.1611829309173; 
	Thu, 28 Jan 2021 02:21:49 -0800 (PST)
MIME-Version: 1.0
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 28 Jan 2021 11:21:36 +0100
Message-ID: <CAJZ5v0h01e4LgV0c5FxLorcc6iFW2LVzC=hJcd7LNAJ6D0E8jg@mail.gmail.com>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
X-PDR: PASS
X-Source-IP: 209.85.210.41
X-ServerName: mail-ot1-f41.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	impostorscore=0
	malwarescore=0 adultscore=0 phishscore=0 clxscore=225 bulkscore=0
	spamscore=0 priorityscore=141 suspectscore=0 mlxlogscore=768
	lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280050
X-Spam: Clean
X-Mailman-Approved-At: Thu, 28 Jan 2021 08:25:07 -0800
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        djwong@kernel.org, linux-nvme <linux-nvme@lists.infradead.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Linux Memory Management List <linux-mm@kvack.org>, dm-devel@redhat.com,
        target-devel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Alasdair Kergon <agk@redhat.com>, drbd-dev@lists.linbit.com,
        naohiro.aota@wdc.com, linux-nilfs@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, osandov@fb.com,
        Eric Biggers <ebiggers@kernel.org>, xen-devel@lists.xenproject.org,
        ngupta@vflare.org, Len Brown <len.brown@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-fscrypt@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, jefflexu@linux.alibaba.com,
        jaegeuk@kernel.org, konishi.ryusuke@gmail.com,
        Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        damien.lemoal@wdc.com, Ted Ts'o <tytso@mit.edu>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>, jth@kernel.org,
        asml.silence@gmail.com, ocfs2-devel@oss.oracle.com,
        roger.pau@citrix.com
Subject: Re: [Ocfs2-devel] [RFC PATCH 29/34] power/swap: use bio_new in
	hib_submit_io
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280081
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280081

On Thu, Jan 28, 2021 at 8:21 AM Chaitanya Kulkarni
<chaitanya.kulkarni@wdc.com> wrote:
>

Please explain in the changelog why making this change is a good idea.

> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  kernel/power/swap.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index c73f2e295167..e92e36c053a6 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -271,13 +271,12 @@ static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
>                 struct hib_bio_batch *hb)
>  {
>         struct page *page = virt_to_page(addr);
> +       sector_t sect = page_off * (PAGE_SIZE >> 9);
>         struct bio *bio;
>         int error = 0;
>
> -       bio = bio_alloc(GFP_NOIO | __GFP_HIGH, 1);
> -       bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
> -       bio_set_dev(bio, hib_resume_bdev);
> -       bio_set_op_attrs(bio, op, op_flags);
> +       bio = bio_new(hib_resume_bdev, sect, op, op_flags, 1,
> +                     GFP_NOIO | __GFP_HIGH);
>
>         if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
>                 pr_err("Adding page to bio failed at %llu\n",
> --
> 2.22.1
>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
