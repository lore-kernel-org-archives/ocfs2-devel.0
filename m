Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20082C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=piKhL9KS+y6jw9SpsnJpDVn+Z5bCapJ+Jm0PvQXQIhk=;
 b=tfCOwxVj0qA4dgqzq6Ik4kduqoq9iLGrRaBPfAu3J69fP6pVg/gTR6ggKb/UsZZb2ugor8DUaG95
   FiBa1AFH9BXAHhmSgs6Eem9/7WFvm5ocFoBthYDyJ+ZUuQwMOauUfCyqNYGfqT4JvHULaAsCPANq
   HLmvhQqtIT461HQalRi+pZ1DI1d7fqPVu2qcD6G1XnB4Bm4clgx7/GszmhlQkKkGMw0ZQE08OEdA
   yGUoHmxCqXNernOaXPOAHDlMq8W4XWmroAJwvXPotuQMHPRfr0YHWm+LOZRP//0A77kaCwDlOHzZ
   cFldUO62PL0hQK5ojd4jshY788BLEJVp9DA7fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=piKhL9KS+y6jw9SpsnJpDVn+Z5bCapJ+Jm0PvQXQIhk=;
 b=ckFiAMJNxI3LT8r7j+0Angh6KberGiLM5nbiM3CV1AII2ezKpgByB2Cl6fer/g1pRlhg2o8B2DeV
   PnCT5x5+fo9bQ806PFsus3AnhKwHf9UVhStUL+AHkLrm9LnPbOwdSzger3/kWFygfxdo6IRyXSJa
   km30eWuKzwUTSWj/Er7hyyaE48u1YVRTw9SE5+Cy6AtYGy8EmETePkQW4g1X4dqwl5bKHOh6Zh92
   UUpZ36H6Vmh95Gf5w9YqSYx5jZX2Xgw32pyqzAp69pIEohOhhwS8Y4UHFyEpOh33u8EVj2KdK0gh
   63hBzkQNbTq9EGzOOQqr+O/MP0e+d5zzBbdx0Q==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Z00GPT6VI5J40@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 15:26:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1649345154;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Bgv24cnq4wL+/PQXezU/e2ARnHoovKOhXIgsZis+Zv8=;
 b=xtGtLoA1rxTAfbwnyD8y0m1GZXkoG2Eqm/JKAR1yflAQGXCIe+EPKLsQ3Jl3HF1ejkdCzO
 R69fN/3GghEjXF7FLzZ630UM55zcmFGAOi43l86+pog72f9MfM9XFXEk72PJM2lSVIy0eO
 Ar+NvvcjWPRZc9tp6WgYAzpMBH3HwQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1649345154;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Bgv24cnq4wL+/PQXezU/e2ARnHoovKOhXIgsZis+Zv8=;
 b=J9TTigpMGNAp9ruFfwwGecAvDY029f3E2IK2t7dI3TCObbagdDL5XIR1t0kPQCQDtlPljo
 bs6igqf+zh/8rsAg==
Date: Thu, 7 Apr 2022 17:21:52 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220407152151.GJ15609@twin.jikos.cz>
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
 <20220406060516.409838-12-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220406060516.409838-12-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=141 malwarescore=0 lowpriorityscore=0 mlxlogscore=421 adultscore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 priorityscore=280 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: Re: [Ocfs2-devel] [PATCH 11/27] block: add a bdev_write_cache helper
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
X-Proofpoint-ORIG-GUID: h_J8V0u4akT4zZYTL830hYZQ3ukdCBah
X-Proofpoint-GUID: h_J8V0u4akT4zZYTL830hYZQ3ukdCBah
Reporting-Meta:
 AAEV6i6lWSW50qfgP/uzxvHZz7w3iRHTkjRMebHh6f+OUoqY3TMLS3prKvogdclc
 toETtHZwAdPd81hfafWdHfFQC2VnL7Llw1J9xzotAUKw/ndK7ZyQ95ilsciGG+zy
 nhYSw/NLna+q0cZs57GzZrBKtai2YwbYyo9kx3fiR/6zCeEb1BCDTRvbidrhjQiT
 F95NTD65gP4bsTDIifLupatzJQJwkk0K+eRuOCZEu7raYRZWAccsSgunnIl28GDF
 dxniTus7BGs3SB2R3Xh//riHZUG8pD8C7ncErnbk6abRHIZmrCjJ+btWHUNrmJno
 xvK5c0q8NSHac4jxGlxd1D6r604tCTpsUNGNAdjixBOnIDZSDt0Byy7+Qt7lehjw
 7Rul/ICu3JxKMfdNeBzcvfos1gsd/IEQCtL3kmNuOPvFUSvTfVq7vO76x+lsMIS4
 R8ZXJsy4SXnABoHA+Qd/rVgwK+Qif4nAVIOcTZ+ZK6Fhd1AbY3Dv+kDGgpp2fH3d
 cka2kZOiM3P1Pq+J1kM8M8NWu9JD/QIpWbcTNmGPdtQ=

On Wed, Apr 06, 2022 at 08:05:00AM +0200, Christoph Hellwig wrote:
> Add a helper to check the write cache flag based on the block_device
> instead of having to poke into the block layer internal request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rnbd/rnbd-srv.c       | 2 +-
>  drivers/block/xen-blkback/xenbus.c  | 2 +-
>  drivers/target/target_core_iblock.c | 8 ++------

For

>  fs/btrfs/disk-io.c                  | 3 +--

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
