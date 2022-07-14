Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591C1C43334
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jul 2022 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SHzV23MRe64viIdKc8ttXKuGTvNpH2aD9E33u1F3+Js=;
 b=S0NX88MX7YJr8Tcgv6wO/pfPcVD+RsRnzMwzUWS6WdZV8r5zB9eN4lM0dPrYz9mFE950Eqjsazb7
   WnZ3csiHY1Rzt5RT/I5tpLM/76lI1eP8f1ars4cQZHieBIhiz87IAzUU1kiJrkZiUsAHpwppClNA
   0c/kymH4uZi5Tna+pfqN62MODi4+ZcZQXOjmMLoK+5cXHkw79VsJp/i7bJFdQvkcVsCANAOCRCrK
   5pou+6kQp5e3j+rzh/NXqMAUJMulsjDiUdG6QmLylJnZHDoAfvoEPRXW16qOz6njWedIdrAr4xQB
   oTh8/BFXdgbEgQTY2dA7wUf97yun+r29Cvspig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SHzV23MRe64viIdKc8ttXKuGTvNpH2aD9E33u1F3+Js=;
 b=C7g7Xg0EoPQwTV4LY3efnKOLqba4QrqEvAoMbbX8szWp2h81WNQ/Qw1Qdu9xpwN0FtDVgc20YrkK
   GdSp15SCI4M/B3uiJjpuIHKVbxn+aRNBzt8rSp5UJb2gE1XvsSI70Pl+TSFqDNzscYhz1RfMxRtZ
   WRq2evsrNYYigvQ2DoywHf4eC8ZgYHPb6Xxn8mBzbNduUmewl891nvh5aCTMS364OMlmM9tou8fi
   Tqhx4uN98qVF0ARbiPZDiF0HT7InU0SOOWIAubQ4jFbmCUwszjMZXCMQZtjrAhZB4iHotXvyxaLc
   eMULjjlaJA7LiaeyGIy6VJDDXIrYBplqMebcCg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF0004LMR48F020@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Jul 2022 16:28:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=kernel-dk.20210112.gappssmtp.com; s=20210112;
 h=from:to:cc:in-reply-to:references:subject:message-id:date
 :mime-version:content-transfer-encoding;
 bh=51FMChkJehx7pHQ73T1R4wuQ3K5opuWy1ShYWSXgcLc=;
 b=2bg3ecZuRFVjrx0xZziz+wHecVVGRtdcCdgSMS92KHHiTPhlz0piUC25EoCFkiNcXD
 ZrtVuuscGJ3ZnZfBTgChXQnCFyfUBrhPX5e8M/zFNjSoVGmOABMfhOMMc1VXJeZde9yF
 rkhBC/zlk12GZPYcdOE70ojApWUfJrQ4v8wfHrqZpA5XAHgkgkqr0BJRHbcyKTV9uRWM
 yZunbnmee68SYkDf5V4/Nt2oZmzcf/IUmstH+wxkeEimDPJbvqE9p7Zx5YNXRPqCEw54
 Z8ZJSqV8x7AwD/xypaV8GyHoC46hA1ZkCv7+2DReyqjnduqQHonXixJQXYq22vERL21P m8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=51FMChkJehx7pHQ73T1R4wuQ3K5opuWy1ShYWSXgcLc=;
 b=OnbYHj7Mf82z7TNULw1xO8FSbGUCI/GPp5geGo71QxHNPNDKojs9W2KEtKj3HeLbI7
 TbDsG8vFw7tkR5zH5OTSf1oRM6nB5Hk3JPvveVH2dXJu5HGdU/RQpwLkKowOufyO/dl1
 O+dIJ0X6KTS+Xc1P+ZNFd3RjWOFqsqxqshBRSoO9cLMvQF373l1Ce1aqPZWURt+fxKFd
 g+ISWkJx3+Wrl5jNxE8wB9lMkE2Ni2ej8oWGfHzfUZ0sf0abXORfXiRWkHXa7qx9NYYd
 9lQnclFYHXkhd3D/UMH+nzl28CrIp/dUykBdF7oFEXiPqTcDXZJJDoMVSWpemOC5z+05 j6eg==
X-Gm-Message-State: AJIora8n5fZHDi2elNTtpp+Q8m4Agf8GoeRInG8zP4J/lkAhRux8sjwl
 n0+ECgzUcvtajC78H0weTKusyQ==
X-Received: by 2002:a17:90b:3c4f:b0:1f0:b59f:8b86 with SMTP id
 pm15-20020a17090b3c4f00b001f0b59f8b86mr5752596pjb.225.1657816119680; Thu,
 14 Jul 2022 09:28:39 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
Message-id: <165781611803.623079.18294279066897804471.b4-ty@kernel.dk>
Date: Thu, 14 Jul 2022 10:28:38 -0600
MIME-version: 1.0
X-Source-IP: 209.85.214.180
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10408
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=222 mlxlogscore=640
 spamscore=0 priorityscore=30 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140071
Cc: linux-raid@vger.kernel.org, tytso@mit.edu, song@kernel.org,
 linux-block@vger.kernel.org, christoph.boehmwalder@linbit.com,
 adilger.kernel@dilger.ca, jack@suse.com, haris.iqbal@ionos.com,
 linux-ext4@vger.kernel.org, jinpu.wang@ionos.com, ocfs2-devel@oss.oracle.com,
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
From: Jens Axboe via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jens Axboe <axboe@kernel.dk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AGRyM1sNF6svcWGxSuUx8Ka7ezTADczi0FQJjbOAHkM55oW99hTvyuSUoBOHMICbkM3Ftbz1hcJ25g==
X-ServerName: mail-pl1-f180.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: obTnvNUdyPsiw7pBD6HQilNYdamNsVou
X-Proofpoint-GUID: obTnvNUdyPsiw7pBD6HQilNYdamNsVou
Reporting-Meta:
 AAEHEsM+axKJoK04k4motZ1aA9hMY9FPqUvkQa6thjzbfYVSeaQ4SjWmmCCry2ET
 L7n61smoZ+a+m/o9LjaAlMFpO6ot4SJzNXfNvqA8zppMaaj2nN0CHrI+YyIF4dT7
 5MFLVbKuYBs4Qo0MuR9Xrg/5ZXKJydCwfsY4NDuoLdNmIXd4uyuZv87bmjI6Yms1
 B4GpYbTjB4P8qJDJRWVyDZZ74g+sRCvuZOIzFy1wujsu+ZB4Pzvvc1UGkoIG7/I4
 mMyPrXgJAG1FwwxOwJvxxQnVbkYQUKxi8Wq8wmT+qalqsHAPz7UNmgFOvJLiGxUB
 LYyPeENbs3NO7qnvGOrq7fQzHZSCvYJE/suV+gljB2lR3m8tDkhI/8+CXT+0elOY
 lK4B7QIdKLDjUBzvvkQZBqkSZd4IYihZTSgq+PA8TTVkdj0DnUmGhCC2IDW4ZH6f
 Of7ZleaxxOGzZN8Wj5y51pRnqn0/lznwP6Pny1lo4sOdrqy+L2rRe2m+1zkBG8CP
 Stkv78973s8NUfpJdLMezPwB3wia2jq8mwIDR9jHRdI=

On Wed, 13 Jul 2022 07:53:08 +0200, Christoph Hellwig wrote:
> this series removes the final uses and the implementation of the bdevname()
> function.
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
> 
> [...]

Applied, thanks!

[1/9] block: stop using bdevname in bdev_write_inode
      commit: 5bf83e9a14ddae994d783dee96b91bf46f04839c
[2/9] block: stop using bdevname in __blkdev_issue_discard
      commit: 02ff3dd20f512cf811ae8028c44fdb212b5f2bf7
[3/9] drbd: stop using bdevname in drbd_report_io_error
      commit: 1b70ccecaed4c3c50239e8409156fb447f965554
[4/9] pktcdvd: stop using bdevname in pkt_seq_show
      commit: fa070a3b50a17506a230e72bd48dba89e7bb5fea
[5/9] pktcdvd: stop using bdevname in pkt_new_dev
      commit: beecf70ee84363e92f3bf783b74da5f26e765d8d
[6/9] rnbd-srv: remove the name field from struct rnbd_dev
      commit: 6e880cf59932a14bca128fc8e8faae0554932942
[7/9] ocfs2/cluster: remove the hr_dev_name field from struct o2hb_region
      commit: 4664954c9421ce326bb5c84f175902b03f17237e
[8/9] ext4: only initialize mmp_bdevname once
      commit: c5b045b9838972cc4c4985a32fa5d35ecf2ab15a
[9/9] block: remove bdevname
      commit: 900d156bac2bc474cf7c7bee4efbc6c83ec5ae58

Best regards,
-- 
Jens Axboe



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
