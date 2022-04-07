Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018C1C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OA4vCeCAu9jWgAxCLxeyRx1nZDaLEkunholpO+/+yBc=;
 b=uVE61vjjur7bGcfU2cWF363zT8PQ+7pGm3WoHTjbS7xM3Umpa7Es+2UI9aNKKV/pf86LUFKKkj4t
   UBmh1q5wx2cu592CJki8iFw8zS8XXCNYDv2kHXrNGKcxhWC8FVLYo3kKVQRkn1CPuoxxOyfY1nkY
   mOkQNoaGmRBEYnrVN9E5pAKoQa8YkgWb++czaOkRgIuaxJ42Ck+XG/xCkcVyNnOwoUPBBcfdnnap
   GaB2e+gik91kAo9bKuB5l1AS/2ejXqfu6tqyDxXZW+CCK6OKrI7KvU6fILBuLNkM2cjBPzy0uAI1
   u7nsVUaXy1VID+ei5mYjBbEcLYaD+MTU8XVRGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OA4vCeCAu9jWgAxCLxeyRx1nZDaLEkunholpO+/+yBc=;
 b=e7b8RSg2/6kx8Po15SwWTNKdE43iTcCbgQOHhjCdrKOiTfioiWM+RtxnjxXhSSQoxUv1SOxEbRJ9
   BuQXsOATnOKL26s6TECctvXz5R3WBCzkdyVbegobKfntSb/mdiRT4Ryh4SUsaQgrCC/5haIaHUau
   dVexYWQVVpOA+rZ31scEDO9Wldtg40t/Fag4ktLx2qxG7bLBeZ6qI0xzz3Y6iOZsV5ECMMnPo9ue
   KRECVP1oGlxT/hi0O3HMR2htGNZ5wOaVl8vZzEVCJt6SnX2RBbGc/S3OTlR5JRy0M5mUAlI6EEwS
   ipeKF8TJK+o55gIszDM+0kiYsuDEo+gp/2dJMg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Z001NO6WZWG20@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 15:26:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1649345205;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HY0WGnVyYhCp+LhKaKmQstubuC2NBeDsW4/sLmH6Z8c=;
 b=XoJXkAIgylqQHPJw/RxdnXZhZyl5PP42kkTd2vQs5Kg1qV6D3ZEimN/Ndmez2jDD02c8y/
 8Kt3GvifEuI3376MaNJ/2N1im2t4mIvENdAjGSrIrgJoXtExfV2shXkVVqkhj++pc+sxkE
 nCY7Te6kyLzniSfS/9ZPp+5ltDd/oy0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1649345205;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HY0WGnVyYhCp+LhKaKmQstubuC2NBeDsW4/sLmH6Z8c=;
 b=tIy2FgiTF5PZUTeuG9JADUiSC1+VAIkjbGxP/lEc71v2qsAsFxGTxeSFScU8FNeVlGcnPr
 Dj41KlwW0MN6N+Cg==
Date: Thu, 7 Apr 2022 17:22:43 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220407152243.GK15609@twin.jikos.cz>
Mail-followup-to: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
 linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org,
 ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
 ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-24-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220406060516.409838-24-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=142 impostorscore=0 bulkscore=0 mlxlogscore=385 adultscore=0
 priorityscore=372 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070076
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 23/27] block: add a	bdev_max_discard_sectors
 helper
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
From: David Sterba via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: dsterba@suse.cz
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: F9MpimYQaq9B-kyG-y247efRSuBJwYMs
X-Proofpoint-GUID: F9MpimYQaq9B-kyG-y247efRSuBJwYMs
Reporting-Meta:
 AAFuL6JJyfa+TZ6TSVbJ/ZeYth1N7pPBCerdYcy/Hlk71iwWQa0WCdm76RUclLU8
 yVifXn1WlEgd33s6/PTA/L7wkL1Ma5js6aXjJWNFcKJaoGpT/4Oiz7VBKcHzZn6k
 0mHRrTu/ssFRJt+rcM50gEnVYdX4xBz1FsCf68sN2bn827Aq3lS0h9TxHmmhA+qs
 bYisjEBielRKNIQt1Cc5umkLkSOyRzzFhRYSa0tQuBwIY/HQT9XyBgQma7YOIA84
 Jxm7Gi4KLiKYRt+hnSX1iyDrknA1am+pEetd7GOhNZ6QKYCRAdUYsA2uc7+5Mi6n
 qoVbclsSx/WvbXk9LrUzpsSJEO57my4Ey2i6WrW+rzrABG9ptJyrUUb5/mi4H8yg
 tT87OP48J6kHB7zeuMTpuATwAsEhShYEUqCULbtPiHbDon6Jyrwt4hjiqzAyQbE3
 bqya4bsldED4Z9NSsAoCiTQh3v2c4DXUPejDk8i19cK8v4HEt+gHu1VctaeF07qC
 Zh4StKug1kHpIudOEvUJk2e5Zf70yOY17F7Su7Dyl1s=

On Wed, Apr 06, 2022 at 08:05:12AM +0200, Christoph Hellwig wrote:
> Add a helper to query the number of sectors support per each discard bio
> based on the block device and use this helper to stop various places from
> poking into the request_queue to see if discard is supported and if so how
> much.  This mirrors what is done e.g. for write zeroes as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c                    |  2 +-
>  block/blk-lib.c                     |  2 +-
>  block/ioctl.c                       |  3 +--
>  drivers/block/drbd/drbd_main.c      |  2 +-
>  drivers/block/drbd/drbd_nl.c        | 12 +++++++-----
>  drivers/block/drbd/drbd_receiver.c  |  5 ++---
>  drivers/block/loop.c                |  9 +++------
>  drivers/block/rnbd/rnbd-srv-dev.h   |  6 +-----
>  drivers/block/xen-blkback/xenbus.c  |  2 +-
>  drivers/md/bcache/request.c         |  4 ++--
>  drivers/md/bcache/super.c           |  2 +-
>  drivers/md/bcache/sysfs.c           |  2 +-
>  drivers/md/dm-cache-target.c        |  9 +--------
>  drivers/md/dm-clone-target.c        |  9 +--------
>  drivers/md/dm-io.c                  |  2 +-
>  drivers/md/dm-log-writes.c          |  3 +--
>  drivers/md/dm-raid.c                |  9 ++-------
>  drivers/md/dm-table.c               |  4 +---
>  drivers/md/dm-thin.c                |  9 +--------
>  drivers/md/dm.c                     |  2 +-
>  drivers/md/md-linear.c              |  4 ++--
>  drivers/md/raid0.c                  |  2 +-
>  drivers/md/raid1.c                  |  6 +++---
>  drivers/md/raid10.c                 |  8 ++++----
>  drivers/md/raid5-cache.c            |  2 +-
>  drivers/target/target_core_device.c |  8 +++-----

For

>  fs/btrfs/extent-tree.c              |  4 ++--
>  fs/btrfs/ioctl.c                    |  2 +-

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
