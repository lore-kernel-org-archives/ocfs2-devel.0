Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A466FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nILbfJwHNsHhjG3vB134MGIuD/dukPYsGA9R17Vp52k=;
 b=RX1wiM6mfK165clTMFRz79BnU3ZfEA85+Q5dF3OG3NTJrVOeKoRxOWKbyuiVhd1pXlELVupwVyE8
   bhsKgTdNdPsWrCkE3144uRy9o+Uhxik9HnP/W7Fenr0zal4irNQo0XriWRYlncw9agVdCS8BHQn3
   sjpXs63QizQCK9g0ZqZlvpd6N78MQnP7vOZ0Quwk6OSWVfnDXtOh2DtEESE2Ndh0BE9XCX2M0+Of
   fdQN5iPMk2PizahjROc40w/ugSoP2lQvbhns2quzeNYG9uVQ2j/nHSVxCWqJByjjNXQu3uvZcGVG
   Y2S7bBw/1fr8gfYaED1BMpW89mPZWRdGboRFkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nILbfJwHNsHhjG3vB134MGIuD/dukPYsGA9R17Vp52k=;
 b=EMQ3A36fjCFbgo0E+YLjRFU5qfdnxoe07hT2ZkHlbyFAGreasppVUdPHRHKsglfsIKTio9ZSzbzD
   0NdkZr5D/s7gFgL2ryQkpIJuOEbVPt6mKoijlYkzaFR4tv583TJQSOsiGQzKbAT+E4j9Dr9KMQv1
   6I7kuqHEYFnukaQSeQqpl1kSFzLogn1959cxgA+uNhV3wWIgFYH6FfFVfh1HXTnNmHMZMgcox0qA
   gt1ZqVliCXBtk8L/1FFhRBtBO6qNAC0gC7DHhfhuToa5cM2gRI+cKjwTR/Xht7yzNxTj0KYu/dpx
   JIetOvbmWpZdVtxxNCbLK096cCXhAN6Ni1r7BQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Z00E4173Z3P40@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 15:31:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1649345459;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=VK52HHYwZ5mydc6ONgZ3weVRrNtBzOOpSIr7pOvXQbs=;
 b=WySqupirn7YZPnIWLV0GfVAqxihpYRle8XEAkyNVF3WBqDMBwi92kUG3G7Geq80fpEpqDG
 ac7ABA9wFAVhQVApAGDNJmbt/DMKsm4fE53BT+WEDXzbauuxegcpY8cjYEPD+30zCAK/0V
 /KcfIrKcEqFeLeaqKdylieoJrRuFiL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1649345459;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=VK52HHYwZ5mydc6ONgZ3weVRrNtBzOOpSIr7pOvXQbs=;
 b=dPYi+hdX0iWuGGA7k7dxuydFXSe1+2WyOjXtxXeAslnPVSFPemFb/xuBKsBNhRAOcY4W1X
 dBEDeLvzeSqw+rCw==
Date: Thu, 7 Apr 2022 17:26:56 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220407152656.GM15609@twin.jikos.cz>
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
 <20220406060516.409838-27-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220406060516.409838-27-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 clxscore=83 spamscore=0 mlxlogscore=611 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070077
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
Subject: Re: [Ocfs2-devel] [PATCH 26/27] block: uncouple REQ_OP_SECURE_ERASE
 from REQ_OP_DISCARD
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
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: o2iwpELMMVWC0JHu_dXbX7W_UTTL3rBp
X-Proofpoint-GUID: o2iwpELMMVWC0JHu_dXbX7W_UTTL3rBp
Reporting-Meta:
 AAG+A2tkDtYVdnOm4k7bvCOP+ZGDRoJmUYuQ/uASjRYmHgGyXlhJTnb+/70sKtoV
 EIB9qYCZolR6G59gQ+9LOn+bvFeDdKh6q/VoPLZLVp0sUgGRW9GeImeYDBcP2IjZ
 HK22KUB9WhFoIN5cwqAQJDQGL9MHlL0LFNZ4y+7nHDkD1XJpwu8odu4fsPx3vCV0
 6QFXlLZUbAdiuQ8b+1vN7xeZ14D+G154uSzMWbNpzF9Ts3owqJgMAUjjO/Ob+BY9
 2MUMuIDAWfg89xIdmyhftmdPG+JyEe2hLSTmwQJz87v8ddQfiJHOEreTEWqKXOmr
 Zg+Rx54o+k/RnjszEcDgbnbFktZcnUxFm7BmGtSROcFKTaRdt5zlgdTyaMneKZ7u
 JYMT+uwCNwKRwN3PntlOKs8CghlkJjJ6Z2/KEtBPgB0crgtrr7azhDY0og8jiev9
 y/8CMTtm+kfWX79MwS7w0ldParQDcB/WDef/AF9RezAyqncN0LrFtgHBhopsVpZF
 jCzS0XBbsC82wBmtBG4MFAEHLhqazaU++O7obTt3No8=

On Wed, Apr 06, 2022 at 08:05:15AM +0200, Christoph Hellwig wrote:
> Secure erase is a very different operation from discard in that it is
> a data integrity operation vs hint.  Fully split the limits and helper
> infrastructure to make the separation more clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c                    |  2 +-
>  block/blk-lib.c                     | 64 ++++++++++++++++++++---------
>  block/blk-mq-debugfs.c              |  1 -
>  block/blk-settings.c                | 16 +++++++-
>  block/fops.c                        |  2 +-
>  block/ioctl.c                       | 43 +++++++++++++++----
>  drivers/block/drbd/drbd_receiver.c  |  5 ++-
>  drivers/block/rnbd/rnbd-clt.c       |  4 +-
>  drivers/block/rnbd/rnbd-srv-dev.h   |  2 +-
>  drivers/block/xen-blkback/blkback.c | 15 +++----
>  drivers/block/xen-blkback/xenbus.c  |  5 +--
>  drivers/block/xen-blkfront.c        |  5 ++-
>  drivers/md/bcache/alloc.c           |  2 +-
>  drivers/md/dm-table.c               |  8 ++--
>  drivers/md/dm-thin.c                |  4 +-
>  drivers/md/md.c                     |  2 +-
>  drivers/md/raid5-cache.c            |  6 +--
>  drivers/mmc/core/queue.c            |  2 +-
>  drivers/nvme/target/io-cmd-bdev.c   |  2 +-
>  drivers/target/target_core_file.c   |  2 +-
>  drivers/target/target_core_iblock.c |  2 +-

For

>  fs/btrfs/extent-tree.c              |  4 +-

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
