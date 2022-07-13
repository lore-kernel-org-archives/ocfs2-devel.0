Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8DBCCA481
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jul 2022 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pi/AQf8g9kmMRRtjHX9n14lNyJbOfKELXRrKhGtYWY0=;
 b=wKGD1G/8Sm8Xo4l36ukh8HrYLDRg05z080z2SzTE7xQf3wd9t7x6rJa1ZNNwbqY6gbrZS5ZedkOP
   phogIXGUv7HpCg1hnfMKQmB97UUabxI71j8AGprOtA+T00QgiOCYGEPlLGoDCZ/MTlT6NAefXLno
   GqrKt6FFkHhcag47qdgBVhkS5j+Be2A2+hibSa1zKCPpdTTqABTfcWFXjDLcTgDEmvmZDQ+YwUX1
   SUT0FTKRBCxnZuy24dvwUtXFFfGJNUG1J6xRNbhRpl1mSffv/hQhTiYLVHPvlV4LSVdUx7s+4iY7
   KKB/g8NFRmX7sGdDvssHJns7WC+eewqHsMQXkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pi/AQf8g9kmMRRtjHX9n14lNyJbOfKELXRrKhGtYWY0=;
 b=Ow+KFGy5G2jVXhVsaT980ibWgAUbA2TjWY+RcOGoMg0hL6rwpLZgfS39yFj/+pe9Yc+IBm6l/jda
   EQJzt/Xpa3ie9+EmjPFpXARP4q8UV0UkSwFSh7ZwRmq6crA9fmv5tDiRKhKQ4KTlDSpm7tQCRo5z
   tQajNtCt6y9hOQuSrIiul5wZVcWZVvs8E+KqLA592tOSblNjD2ZfSBht5rWFMcuB0bZZ3dq4iyoK
   ATdFniKfZRGhL0VjAn54CvnDeMLMFBM+A3A88x5GA/iRuQS11yJaIhsc9spPWF82KZzbmxKPGnRq
   e6ZxJc8J025TCIC6NnDC2uLjY36Tp8w0xIV8cw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0REY00HROSL8TTC0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Jul 2022 15:05:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1657724708;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3UthFAv3XYV85llf1wlYTZ00AmCnaMVjVxb5nRXSeSw=;
 b=SwqlHRDxgN7Jzn2rO6klx+TGxsb5kYnOmvpEnxIg442V/TJzgxweZNo1LA6Ou5tZZYxHC6
 t41LQy7I8A6ZbJwe+P2NX8LDtAf1Zc5eL+wOkIHnF2nXws/Mlsw50FBKcAPRTIpieoP3zd
 kHWda9H3XDl8OidcG3UyH52gQDD9QPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1657724708;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3UthFAv3XYV85llf1wlYTZ00AmCnaMVjVxb5nRXSeSw=;
 b=WYu1r+884kvySXmy1H9WTd4t806hphyxPIyqSBY+c85qDWJ77/AiWD6xWQ3IX8zhNjROLV
 1s/OrNwCvZyDTfBQ==
Date: Wed, 13 Jul 2022 17:05:07 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220713150507.6bvq4bidmirs2mql@quack3>
References: <20220713055317.1888500-1-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10407
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=70
 clxscore=163 mlxscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=353 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130061
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org,
 Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jan Kara <jack@suse.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: Re: [Ocfs2-devel] remove bdevname
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: YSefSLTYnaURZfxEy3NHFdu-KYw3_U6a
X-Proofpoint-ORIG-GUID: YSefSLTYnaURZfxEy3NHFdu-KYw3_U6a
Reporting-Meta:
 AAG8mLc5vZiZQhAdc4J7deLDewAHV47bvAGNXuqn5434/DtUnQcCruZSSSCVyBVu
 GNUx4OAzktRH7LvEcVFxmcmjdSsDrVOiizGVUnRYW6VdBCUCdj3I9XUiHEGng5fm
 IGK5znpSjknUSao5rF05UfHt9QYP32cA+gZyiUv8jQZ88slmd3M+cigh91g65aPb
 txEljbGO9JfDRs7daTTNUJHbsfyohKpW7oLabIpqpQDJY0+4Uhtl5+PzvqTspbAD
 8cH/Ru554W5OKbern4d/vUZoSkuHaYAaMPhqz+F2AwreJGU24GR9Q082NYo8FuN4
 36+EtBV+UKp28iBddDV/dsYxJgTqcCWU6a0DEHvObH3GWKOoQyEq1+m8yuYwrqNG
 Tz6Gf4AFWCoS2tqc9FvzF6GHX3nWZf7oXcKuCLdTJIuvueVzMfn01Wtuw9OmJdEZ
 gDnGXXrF0QckB1VDHr5QwqBbELJrxn2HM3YWPx37A/PJAYizm/AnWtD6wAyob5iP
 +wrd10JMaYYcuuMmxAJUCto7TBE5p19mM1cEDtvdNCE=

On Wed 13-07-22 07:53:08, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the final uses and the implementation of the bdevname()
> function.

All patches look good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Diffstat:
>  block/bdev.c                        |   10 ++---
>  block/blk-lib.c                     |    6 +--
>  block/genhd.c                       |   23 ------------
>  drivers/block/drbd/drbd_req.c       |    6 +--
>  drivers/block/pktcdvd.c             |   10 +----
>  drivers/block/rnbd/rnbd-srv-dev.c   |    1 
>  drivers/block/rnbd/rnbd-srv-dev.h   |    1 
>  drivers/block/rnbd/rnbd-srv-sysfs.c |    5 +-
>  drivers/block/rnbd/rnbd-srv.c       |    9 ++---
>  drivers/block/rnbd/rnbd-srv.h       |    3 -
>  drivers/md/md.c                     |    2 -
>  drivers/md/raid1.c                  |    2 -
>  drivers/md/raid10.c                 |    2 -
>  fs/ext4/mmp.c                       |    9 ++---
>  fs/jbd2/journal.c                   |    6 ++-
>  fs/ocfs2/cluster/heartbeat.c        |   64 ++++++++++++++++--------------------
>  include/linux/blkdev.h              |    1 
>  kernel/trace/blktrace.c             |    4 +-
>  18 files changed, 62 insertions(+), 102 deletions(-)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
