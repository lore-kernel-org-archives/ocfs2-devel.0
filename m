Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86ACCECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZNk6F1rQgczXAZDezbn1wdBmUFrASEV1lNhHW0ZU9R8=;
 b=kGBnKywviwMyKWgFNixqWWzSgaRfO9LWUERGCwOPWMy4j3jJK6Q/KgNiLZNBUDlDAkApph4+FJSN
   5UsJouu7MI2VClLT77mBvavhqfV3Yb647bV4kaXQKNqDE5ICJ/igfT0dkpvOUL0bNHabsRO0eJVc
   UmHXxPAgiW76gMPPhj51PVzCbPWGCgdOJ4pDFATYyisArNHNWmFH2UjVcVUPJtaB/3mFpojwoDib
   KBW6d9vqHZSHqQyxxiz7WfxiH5bzFKlhslltjdoKrvmg08Xl66dPTMSBgU2eLWOAIIB6CsK2Klul
   7qXEvywUoadXRmojM/Hq6w9EnXMjE2RO72R7ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZNk6F1rQgczXAZDezbn1wdBmUFrASEV1lNhHW0ZU9R8=;
 b=ARYkH0K6sgkvHXS8uxfJVqHuCFNUSU+jbfUxFDiazXR9TNP2vjntSPiXu0lwz2mRT/cTHbw7x0fO
   R775ewtHlSR9cOxTU5qnGHvHCAdDARcL7eXkjDmt5+q6ZV2kiF6grFdMzbhUlt/tlumBC9h3kLX3
   1WaD+4TALRggA1XggqXEc3g2YwYfy8bAjbkUSE6mOvLpcCdLXB+zhCLxVQnhzjj9cIMnM1BcAJKt
   c5WSWzDaKYvUbZ7jYt0hLX4Rd1sTrEtfn7z/0Vz0CfVtTK5MciLFWKiNuxhBmYRIiOziIIKS6HXQ
   JhtmA2K5m7WwGvTyDKQ+C22BoMGvt2Gn+HCFmw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00LR8QQ28RD0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 14:25:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1662387017;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/aM9Hz/CxTU/5IZIiOb0wSytjLDU1CYz4f/uZlzEYfY=;
 b=DWMkfrcF6TXu6/Ga4TEMt2umip22pqj4/bqxBlvC9WHYv14QQSeZZ2kEqizDkMg19WmCQk
 VqxRLy635HldwyCLaOwQPK0amJ98YR4o6tBIX4NrvbpPCOybiknGunPW7GPnGNQtATeY4/
 +R1xGwrixlxc0WkiOuw2wQhU4OPcgbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=/aM9Hz/CxTU/5IZIiOb0wSytjLDU1CYz4f/uZlzEYfY=;
 b=sYLyzBtBRm/HZiUUkjYQu/0r7SdwN6pd+p36qvRDJHYcTYI+8979473durrQkjJtjA
 6+t7+sKNO5mfJ37PFk8BFx0aQhQvcuOnLI5Dp7PYd74i6u2E6W0dfLR0PyrpVgJfIJ36
 I6iBCVaebz9v2nZ8DDy/0r7CS+ZHKkFg35NLdr0cHKQAciVNye8VvfYsK2J6343gDxAC
 4SDJ8agdubm0yHccXQFVBbYlB2kesZgBnw+LZr9c5D1hSK1WiJbeACWMS0aw0eaKt2j9
 wy/EEIFQ6MrCfM56Cc4W7JGEEVx4nq7llHIClNmGnbSSqARCV21nP6JZ9jLmT+xcEUb5 DQrg==
X-Gm-Message-State: ACgBeo1SvDxeIL1JtCmG/tHZ4A4tuZi56sDWFCNuP5caFGPIrmfW9Teo
 n3wV2lmFWxg53BlGkPIKuHN5llHWkAKKiqiYaKgMlgpuys2GQCcKmqvjXlR07lXM+mPbfW+dK1c
 s/H3Lg11C0VeWCWu8N5gr0zUQitehqYgzPM3BGg==
X-Received: by 2002:a65:6e49:0:b0:429:cae6:aac6 with SMTP id
 be9-20020a656e49000000b00429cae6aac6mr41418488pgb.268.1662387013100; Mon,
 05 Sep 2022 07:10:13 -0700 (PDT)
X-Received: by 2002:a65:6e49:0:b0:429:cae6:aac6 with SMTP id
 be9-20020a656e49000000b00429cae6aac6mr41418453pgb.268.1662387012811; Mon,
 05 Sep 2022 07:10:12 -0700 (PDT)
MIME-version: 1.0
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-5-yi.zhang@huawei.com>
In-reply-to: <20220901133505.2510834-5-yi.zhang@huawei.com>
Date: Mon, 5 Sep 2022 16:10:01 +0200
Message-id: <CAHc6FU4XqSxUr3CS8zxu=Fh_kHytJbzezim0ie_cxdioW5R=FA@mail.gmail.com>
To: Zhang Yi <yi.zhang@huawei.com>
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10461
 signatures=596816
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 04/14] gfs2: replace ll_rw_block()
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
From: Andreas Gruenbacher via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andreas Gruenbacher <agruenba@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: JfwrXsLAMGOUc9u3H92WzA-1
X-Google-Smtp-Source:
 AA6agR6Mbj0cnXfyvltZuZyI75OnAiCy5kv581MclsxMj6AKJtQBQIL0bE5MAfuVXEL2TcdEimwBiyT3tt6LHh8ASBA=
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: -NEPQy5OTiDUF1uiUgxN90g0dWCJ4BN0
X-Proofpoint-ORIG-GUID: -NEPQy5OTiDUF1uiUgxN90g0dWCJ4BN0
Reporting-Meta:
 AAH+iuSixXFerSToffs8jMGSG/Y1Zx0r+X/kUOd1bqDtbV7Z49S6eDtKy4BOIOdk
 iu1zzyeQ7ur00Lx2L9so+cT4gKsoJ3xuKcukYbymOXzeR4kXP+YPjOlDR7uXwTHR
 vpsACaY/CyOHuUOFoUoj/BU04tutIMziSwy7Qb9Jc3alfP3AflMztzLErCDuRA+H
 NDKJ6PXgS5ZxtlUNn0UwF2VjExxedqWQuI1AiO0VGo2l7mU7c9UwrcPQ5DTyLV80
 4gJkn1gqTjIrBuNnErNUSiUDCiER+cv/7PyG2041uMsQBASr2fyJiJ6ooXFQI9Q5
 lkYy6Q9f/oSvM7XYuabwofM7IkcWbqWaqpaSHsS8tqBudB6kMhRZTdCgOgpfEMPt
 868aJWdKfWAPUEs49nnpk0RRAS6yTN6g4G1z+GLiW89u4ICzFokAouGQXFlYrW/b
 yM3zASR2O8uBxPFk/RtqU3YS1+DmHQReqCHYCgXKp9Ak2cooQw+NOj41ErOA40Iz
 TXQwPOXqwbhy0hqrqXyBYNhBkH6cI2W1M2cB6nW7vopp

On Thu, Sep 1, 2022 at 3:24 PM Zhang Yi <yi.zhang@huawei.com> wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that always submitting read IO if the buffer has been locked,
> so stop using it. We also switch to new bh_readahead() helper for the
> readahead path.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/gfs2/meta_io.c | 7 ++-----
>  fs/gfs2/quota.c   | 8 ++------
>  2 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
> index 7e70e0ba5a6c..6ed728aae9a5 100644
> --- a/fs/gfs2/meta_io.c
> +++ b/fs/gfs2/meta_io.c
> @@ -525,8 +525,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
>
>         if (buffer_uptodate(first_bh))
>                 goto out;
> -       if (!buffer_locked(first_bh))
> -               ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &first_bh);
> +       bh_read_nowait(first_bh, REQ_META | REQ_PRIO);
>
>         dblock++;
>         extlen--;
> @@ -534,9 +533,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
>         while (extlen) {
>                 bh = gfs2_getbuf(gl, dblock, CREATE);
>
> -               if (!buffer_uptodate(bh) && !buffer_locked(bh))
> -                       ll_rw_block(REQ_OP_READ | REQ_RAHEAD | REQ_META |
> -                                   REQ_PRIO, 1, &bh);
> +               bh_readahead(bh, REQ_RAHEAD | REQ_META | REQ_PRIO);
>                 brelse(bh);
>                 dblock++;
>                 extlen--;
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index f201eaf59d0d..1ed17226d9ed 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -745,12 +745,8 @@ static int gfs2_write_buf_to_page(struct gfs2_inode *ip, unsigned long index,
>                 }
>                 if (PageUptodate(page))
>                         set_buffer_uptodate(bh);
> -               if (!buffer_uptodate(bh)) {
> -                       ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &bh);
> -                       wait_on_buffer(bh);
> -                       if (!buffer_uptodate(bh))
> -                               goto unlock_out;
> -               }
> +               if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
> +                       goto unlock_out;
>                 if (gfs2_is_jdata(ip))
>                         gfs2_trans_add_data(ip->i_gl, bh);
>                 else
> --
> 2.31.1
>

Thanks for this fix; looking good.

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
