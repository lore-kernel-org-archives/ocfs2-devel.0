Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC0AC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F9h1T6LaqVrafMarYSAir9UKFSQmlLHGm6+X9wxvMZY=;
 b=wL4BbCRYa5yGoQ8um/zGRwm0dY0paZfFHzAl+iG/Wx4jTtFs9Q23p5wktUDtp9MLrYd2Yhe/E8Uw
   c/I0UvwMyGu1KBmmd4HtMlB7ZR5T7nXC5gFRrIO686TdTp0e4jSzzAE+J6fjkPazifDHLNhO8HO9
   bYj9+NyEu0TVHnX4xY5qDKZRelaKxji0ncwrbMMKgEs4BXgXrtVjSwQ5dgB9PDHoMuRf8NjIc2vc
   lzB8u4p0LKIHIN9Z5/AxaBfOVcFhuoYVWR9XKF8ln45/7LOhdOjoQXzglaPMd1VwzjjhOlOIGpm/
   DWbKfbcM60fL4FJqFp++IQNcGQCK0WFJbIrJ0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F9h1T6LaqVrafMarYSAir9UKFSQmlLHGm6+X9wxvMZY=;
 b=dsPw/Ens2Jw/LaAhqpjgaXdYFyiKg7leok6Jgm1zbTRIeErKncQn59vz1vx3sWBobdZrIsv8xqTA
   gM+kdbPcVKH6vooXl5pRJO1wTIv7NEt+UrThWEjFkLXdaS6Oq9ZNUm2luxAeD5TDjt+0+SFx+1/t
   wr28hVj0rDXN05L58fyZn7gAbwKb3Kk+1BKNmnRa2Y7zpOE9mQyLkhOmXqJ51OB0x4RfgVCENYQM
   Sa/o7EO4E1A3XSdddvboPeMn9iC0EL7mcZAqwuKaFD0oJPPpkqwRMvChhwO+zzf5nOTOWddU0Bw3
   rVcDYMlIrKnqzPmt3gfFenhWpRJckKvaUbK7nA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Z00EIW6TV24A0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 15:25:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1649345092;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RtA+SPF4j8BVXsqmszO7xH0OxCICEh+Est/knHN20Pw=;
 b=JdwcskixEmG8Id6CFcHmK2HMPcVcB071Gxs55mSKq7gYvR2Ikd8MNoO/fLtEbVpgdj1eqK
 9zmwivWn67QHHcgD9Kfm5GQ7CXBQeMe5lW9iJ9AGGV3Pl0ul2ocJyd3loaCvdRBmNQxip+
 WgCnpcThcFxRJmTkxC30BSU3q0i1qd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1649345092;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RtA+SPF4j8BVXsqmszO7xH0OxCICEh+Est/knHN20Pw=;
 b=pkLC9VLc/9JNFZ5DsOV/UM/28hXligCH1VLYaRzzl6m3sxWEGPlvl1H8p8FVldpalCYBR6
 DsLUEWMcp0v/ApCw==
Date: Thu, 7 Apr 2022 17:20:49 +0200
To: Christoph Hellwig <hch@lst.de>
Message-id: <20220407152049.GH15609@twin.jikos.cz>
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
 <20220406060516.409838-8-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220406060516.409838-8-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=94 bulkscore=0 adultscore=0
 priorityscore=85 suspectscore=0 spamscore=0 mlxlogscore=530 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070076
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
Subject: Re: [Ocfs2-devel] [PATCH 07/27] btrfs: use bdev_max_active_zones
 instead of open coding it
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
X-Proofpoint-ORIG-GUID: CGYjBUHRp9vbT500hYMgeIse1FRsPCjn
X-Proofpoint-GUID: CGYjBUHRp9vbT500hYMgeIse1FRsPCjn
Reporting-Meta:
 AAElJS2BqRtUsKGvNK5Qzz7bdHGO+ZTpA4st+JdDtC142HUIYk0Vtt/hBjHeZe3L
 bhNeXqbb3/Pn2hnijL9r9JJ3Y59eZhwrVoUPDLeY4w4Iy+AQB4d3AafxiDlQs4/X
 pMmSC5ciTNXA+AI9HRC21rJigzfL80kXxX/f6/pFoofWvG86mgth8KlxcNOcG+2k
 EsSv7e3wBNxIY20L/w1+JL5IA142un1JwmBSuabndOB696MuG3pjRvkop2LYWGGA
 UI9/32JpHd0xZa6V6IAbVMlsaItXgI21yJvizYyPh68y0GVqQmjjDIoeAGbQ+hh+
 fZ5T0h1MvaYtJwMLuEAJZP/UJ5zChwajUOf6Qg7uOzb0FxEsCwTeu791XBREyaUy
 R3wLxIomIJR/AXf1TxMCbcYYu53KZZWJsVIEE2EMEG7B+Rt5yfwQ+o6A1T1Xqbkh
 EPzWs9ySEnb7/EBI2whrs2H4D4Epk51xHVIgQpHT08n3Yi+E9DPDXKF56Yjv7EaU
 Mtn8ExUrF9feas/NON6Rv0k0ZMpzMmb6yl7/iVqGaaJm

On Wed, Apr 06, 2022 at 08:04:56AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

As it's a standalone patch I can take it (possibly with other similar
prep btrfs patches) in current development cycle to relieve the
inter-tree dependencies.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
