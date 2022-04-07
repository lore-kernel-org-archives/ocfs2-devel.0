Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49DF9C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oUSh5hysOwfU8HSsmnFStVe4dnlpjOJ+ygMiCJil670=;
 b=c2x0504plYITjDorgKBUpr9Jckh6t6J2KP5jPmeWTpNp+sKi/FuIvJDBOmDHD7X+TJxUAYJQfk5z
   9SuRW5PzKDQBjHO1kIC/gl2Nckr3Tq2lwJpcWXRiY0LPY2436nhABUPWCvhN5y1rrypQ2deKgGDt
   o0F/lg2gjs7tkXtRnvCo36RiAoXsCJMzrh5A0yX96lId53YhmGyR70UdOqm4uq9/NrUWn6OODnB/
   FE1yUZfnYlqdU0/PnNwOEitpk4mpXdqX/LDPCZWg6YaKfXziaBYN6IlSMV6iBBddALj7i/WsNeyo
   3cidlTexwhJMZkeBBXQ2fJZOgSY6D8+O/bD4OA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oUSh5hysOwfU8HSsmnFStVe4dnlpjOJ+ygMiCJil670=;
 b=An/AQ6EOhlyHBl2fOgfpyYlnMZaWehhrl1Na3dwOfbSwuI5N83xI78aDkl1JkxGJDsG/axNCQ6K8
   /dOsXviH/XeXGXto5TQ+zEnkEOS7HJh4afAH2T4ZE6/w4Cph6m7ApP81xHjVrgABk77MAnnBJDGi
   HhAH7Q/Ly6tLjy4QaVr0aQwOE6fzzB076nmFfLJJcCw2xTMXx11R25NeID3T9Cr4UkTv2y66huro
   o0LyJPVhGfimdfyCq7tBPmsmx04BUSDzWKHGMuXILK3GDCopYy5AuRNhjWCV30yUJSN2UtNdPlFs
   UdTYBirmMoc9LmDw5ucQD0MjjSfVcLESVVO+RA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Z00JID73E9M10@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 15:30:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1649345436;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zPq01JLA6dLoXnFchjjFxJhIcKHBhEdkrZLnR4TbLUY=;
 b=arXCGHubFNDMJivA50IVAh5E18SENgaJ+8psB29O+dYSp9GznJDHN9eBNpNqVEEypC+xPt
 YsOhdRjVTg1mFsMpWqZ4oNaVAGZnjLyClojrRdjsUuitokjLJy7oqe8RxGnlNpP0HUVyi6
 8uSBZYdSoqUowgEJK8P6YGm7aUVWSbo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1649345436;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zPq01JLA6dLoXnFchjjFxJhIcKHBhEdkrZLnR4TbLUY=;
 b=+RoHDuxhi8eXdx1m79jW3LC9fhbmevwd72sFBk44Osas+gmEsPN5qSbgbwIpqCBgrNluyA
 EXeawVVGeX85rgBw==
Date: Thu, 7 Apr 2022 17:26:34 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220407152634.GL15609@twin.jikos.cz>
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
 <20220406060516.409838-25-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220406060516.409838-25-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=142 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=293
 priorityscore=471 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070077
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
Subject: Re: [Ocfs2-devel] [PATCH 24/27] block: add a	bdev_discard_granularity
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
X-Proofpoint-GUID: juUkCrnhsE-SoIttdmjx2_b2eYBvYSf4
X-Proofpoint-ORIG-GUID: juUkCrnhsE-SoIttdmjx2_b2eYBvYSf4
Reporting-Meta:
 AAGlCPhTgSyUTQ3pBQICQOEBjGhsdQ7NV7Ukb+bZeIEoKy6/yJk5j36NnkpSfmT5
 9ttnhKpxxADVa8xEScFMdH/JzXfsf6HoKiaJW2QaiBeHr5CDLMuErcicbZVjoua/
 wy9wNxVkvjiXn1dyDwkiUfDG4XoofttG32gpvnBdEaFgAur3tJerR6o75xu5lsw9
 hu0UYlUMdfrbCcXqMT5z8EBq0kjmmBxpFXJcAiORBNK5/O4/I2rSbvTQskz7Exas
 YuM/fuIA/sYt20cyKtQamvpzWatePVbpI80J8ug8vdqBd9/ttrsxBPj4gsoL+0Lb
 0PN+Wwx83Ct61Lq69HaoLfFDMGHvjS2irSbY2cslEnO6Io1juAj9YAOFKnK80ahE
 xCWS8w84E5G90BDlGUnbqj7IHRVZ3LMfmwqOkwWN6rpTSWa7OSUEhua7ObQLcsDd
 rwtNax9FNlKpj7DcMu5zMZWo4CZDpC9ZvO0CmMSuzdGYz58KN4ZCu6IDOyZ3/J8k
 aMOM4MtvzbV5ujEAmAgZ/rGObXxZYgFHAQeSa28gsric

On Wed, Apr 06, 2022 at 08:05:13AM +0200, Christoph Hellwig wrote:
> Abstract away implementation details from file systems by providing a
> block_device based helper to retreive the discard granularity.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-lib.c                     |  5 ++---
>  drivers/block/drbd/drbd_nl.c        |  9 +++++----
>  drivers/block/drbd/drbd_receiver.c  |  3 +--
>  drivers/block/loop.c                |  2 +-
>  drivers/target/target_core_device.c |  3 +--

For

>  fs/btrfs/ioctl.c                    | 12 ++++--------

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
