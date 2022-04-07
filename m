Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9F4C41535
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3az255lg3EbD9hQIQyW0y1k3yUZevdPC+vkDs6TBLyg=;
 b=17nQ6zimI8L1QfCh6sUfpHjzvr+OFjyDazAR/EkKXIaQsB16HDaHFSTgSMXtnorxF850Pqgko6l6
   p+K1Iwc+yIedKXIMDs8QEhLoKq9nogH0GLrSsjeDszdQqi4oh+hXjWBfqb1w4tsGXYa0nwikfybI
   RcamQUCaSqsSl/u02r/VoZQW31251uw5wB2mWZQbdrGY4tS+A3tsRxQkLz6BzIwQ8V7a77cQyL+I
   GJDf+gUd6Q6wPQwf/U71qyLIJN1iOng3N0TkzvJQFpddhFI5O2rUFa5sN9oWAw3NtzwYJFy/4DSF
   eY1CRb3kjTMqN2nK3AVWNatD0z3KJhsUJCLVYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3az255lg3EbD9hQIQyW0y1k3yUZevdPC+vkDs6TBLyg=;
 b=cMXudUTXEAOjHrQnGwm3Hl0xWPKJ95cZB0Uhcn/NR2eIIvGuXcNfeF5+c1JLzoCWjIoIm7a0JHKX
   jgg9BHy+Jh/OvwyVGNh3wwqXjAwDeIFBaMzWA2dGaIOeSsHewIYedQOfVWcw/gbkeXGyiX90K5+j
   50XLaKXlE6PjS9VIZxK/JMRfXz1Fi4v8L0GzBRwgCY4hXT5KemaVU785LU1q4eymmNMs8pn7fEHK
   gdQY2x3hNkornxMDXbSj4DT/inOjw3j3kEcILgQBvv//opFImWHG9Xs8it9na4S0W5AnUwa8b0xO
   8dAJtpY1m5D9402o1fhYU+pFDb27v2sbfMBL7Q==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Z00GO76V05J40@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 15:25:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1649345134;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=u5NLYRb0iRWqH+wp45tMsxWQ+2lcKX7UH+x3jrUc4CM=;
 b=gyRKbvUTSeCHD0kZFeha6b8GtwnfMcBVdpUrcZUXAMFpgjyGa2cKvGcE+1LQgsvJsr0yFR
 VJy4sQoNdJcuIc7oMupD7ITgqoAKAsjuZZusxwRbFTjJc52vRJgP/0hGLJXdzVq3P3r19L
 5WyRvzygj8B2JBXB13wX08lyO4vdhmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1649345134;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=u5NLYRb0iRWqH+wp45tMsxWQ+2lcKX7UH+x3jrUc4CM=;
 b=h4c6BQrPPD9W33KeeEtgIxkffE6SxGamCvLBsxsw2FlmdG/K+M8MV8ruvANXF9Az9aOJRY
 CNJk3HEoegzTiHDg==
Date: Thu, 7 Apr 2022 17:21:32 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220407152132.GI15609@twin.jikos.cz>
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
 <20220406060516.409838-11-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220406060516.409838-11-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=178 mlxscore=0 clxscore=143 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=417 phishscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 10/27] block: add a bdev_nonrot helper
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
X-Proofpoint-GUID: 0luykMMbEG8PrzFehNWXlrtPS28TNolz
X-Proofpoint-ORIG-GUID: 0luykMMbEG8PrzFehNWXlrtPS28TNolz
Reporting-Meta:
 AAHslLtxbqr5LGM+9WFR0/Sfrpgtw1RGhnHjwSJ6Vtti3qT5KRrDPgSGLXKGef5y
 p0CihZDnJdZYOrE/cYc0F32m5XA/Q4+JivcBGSD33zNgiSJ8U8a1+LwDhvDirbPf
 90zNDvgWiVl1fEjhGMpVODJjnWUKfOUZpdQxe64odFrPl+HTWEjnSj+EanfESl+R
 f2sY1O7L4cPcGCcTHGRLWfO54GBjLI27DhzIlFde1fh1PjbHMCXAhWEhzISkqbZ+
 XO/SsRtvDJAdE5lnsSBOaaXfu7DJ6OLx/YdB7Pma8QIEAR9RO2HxlYkbfjfKNUJ3
 A6BI2aNqvrHwGPqIQyCE+hkkRk789pWKoyS5BXzaRjA0UJRF1BSPWSaGxJdM13+k
 UfXteH54aZK+O57q3et4lez8xSC0Z54a6RC0IIFqBUF1OcnLLDNB55+V0j2hdLMW
 mF8VhHhBPaAnzJiG3niwKjXHvrvLq2EPoQnBUC/H/wFwtpmZ1ErH+frCamENMzk8
 dZOFsoKShEW++1fN81RYxv0jOa1bx6eY4vvydtj/YZM5

On Wed, Apr 06, 2022 at 08:04:59AM +0200, Christoph Hellwig wrote:
> Add a helper to check the nonrot flag based on the block_device instead
> of having to poke into the block layer internal request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/ioctl.c                       | 2 +-
>  drivers/block/loop.c                | 2 +-
>  drivers/md/dm-table.c               | 4 +---
>  drivers/md/md.c                     | 3 +--
>  drivers/md/raid1.c                  | 2 +-
>  drivers/md/raid10.c                 | 2 +-
>  drivers/md/raid5.c                  | 2 +-
>  drivers/target/target_core_file.c   | 3 +--
>  drivers/target/target_core_iblock.c | 2 +-

For

>  fs/btrfs/volumes.c                  | 4 ++--

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
