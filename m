Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD464C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 18 Apr 2022 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5cm6DhKBeyp68RA3sWXOQWWodC85K3+WaRPoHSVr5g8=;
 b=GeTZflsUw4ktLur1wirB6ctYpoO4eb/drFD1o2rsoJ/T5s6rs8Yxuke0PvWhD/YzRg8GL3oemD1b
   y8EuSCG0oT5kqJ7Zqz/uE96hNghNz6bITwkElFp8n3BtIUV0/D9yfePsTsumbcbu0Rw04IJ/MR0K
   QVD4MjvV3VJM1N1EPubEsgNc/sTCdR/WoL4CDS+jfCC/YHoT1qsojWdksIq9gh06DSF3cxPRqqaS
   8LsRKxs445/xR2JUaU9te4JKanJckDvsIB4LTrPr1kFDMlnyJBT33z7nD4rXfitr85bBRY/K81xy
   picBH0Xqep58zplXe4OwRe3KTZHDNF22zmYYZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5cm6DhKBeyp68RA3sWXOQWWodC85K3+WaRPoHSVr5g8=;
 b=ahM891yBRIC6Fp6+Xz5I3EwDOJLKOxC6CfiPlALUYKcDAfdKrGnGPoXxZdZPMqWD0vZ2rM0SNXmW
   DyeNNqN5bRb55tDqALG+sJF7qlng3nb2XeF+c4mFmoKuGHxWF8G4TLW7OIg0cn5TLuvn6WlFsiZU
   9ESvVL8vcyWjGlYVV+OW09D82EuB1PO4e7ZywJk/nzNiFKdQTgQwxbuNC5b7I04OJ6M73KT6Q0fn
   A7glX29f9ALEGol+izxvRjZb8+DvIkWiFZYhP5E7gtnIpcxaXbNaEMARAubj+6Z3KEms19J5XokX
   AJPZuPy2fQ478A87lOlAdmBCgdGZN2WqrznFjA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAJ0096ND4GSZ00@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 18 Apr 2022 12:53:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=kernel-dk.20210112.gappssmtp.com; s=20210112;
 h=from:to:cc:in-reply-to:references:subject:message-id:date
 :mime-version:content-transfer-encoding;
 bh=F9FMycteyYrs8wEiBExwTDtAcc/2JBQ5GQqodkswvTM=;
 b=zqMJx9kEO/syGgh/jfUujcMdgZO1Zk4th79yyPJcsdnvdIDI8Xk864jrHuyarDgv8c
 gBt2ez+Ym/+EaLgC6MfWMHx5OVcgB54eOfckx7Cmdvf3bmGVDc/T0aLwM9rpN+nKDwcO
 dWklV+ARMeZbUO1+GrFCqFc/xZjiULaGiN1ll1DVCyoNwgzG1P+0Y9ZhUcwBpI/7WQx/
 gN/pYZdJuI935bVWCVcjkTqu2k20R+5oG6mGhil2uYi4X3QtR1zxXemtHM8NZ8XUvixz
 3tQXFtvzqXbRCXIajCtyaq1nqo4kcpEpLyzsTyB3FvSvWQd/rTixV4XGHzsBwq9Bu/vV stDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=F9FMycteyYrs8wEiBExwTDtAcc/2JBQ5GQqodkswvTM=;
 b=nvtV8kLX2crfhsEL3oAl0Y2UVUbyUlMq+7oAjpyN8YRo2o2rNHNxI4b0V1fh//v3f4
 z/nPw4lDdRYV8Mni9e2DM5SIYihPAXjCbB9u5V0xfgkiMRkO2tUwOEjJKGBaMno4yJDJ
 yDaLBRh/k2H6haaH6kYVFXulCTVjTe96VPXFs4IwiPKhRWctWGcVg3gjIW/InLUsDo0m
 Vx1WuHEiahJNe6nISD1vN9LZf9k40rsjY7b1g/1uaNtxoq66f+iIwbfPhTTlTyOPucXZ
 QNBiLuFPEorC3umlyUAm+RehGBdjFEeygjLXDr49uEah2QUYaQY0/He6IeawrAzr8jd9 Rhwg==
X-Gm-Message-State: AOAM533jsHU3/u1nqNdDjAzIVIY+dbYmX51d4AFoixmBhjnDgdidM2IX
 XvJWR5Lo1vDj8XggtEgtmFhcjw==
X-Received: by 2002:a17:902:6b44:b0:154:4bee:c434 with SMTP id
 g4-20020a1709026b4400b001544beec434mr10858040plt.43.1650286372060; Mon,
 18 Apr 2022 05:52:52 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
Message-id: <165028636949.14872.7589996414521818725.b4-ty@kernel.dk>
Date: Mon, 18 Apr 2022 06:52:49 -0600
MIME-version: 1.0
X-Source-IP: 209.85.214.170
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10320
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 bulkscore=0 clxscore=-12 priorityscore=1501 spamscore=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=392 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180076
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] use block_device based APIs in block layer	consumers
 v3
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
 ABdhPJyPDIaLEewZhdBb/81ulQRxH4lnSCW72QYENTWzgjKzLqW/EIFRVhnHg8tc4oCKtNOZ6kDuRg==
X-ServerName: mail-pl1-f170.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: pXuwVxiFc60y6VhVHSyuA6yHJzjOlE-O
X-Proofpoint-ORIG-GUID: pXuwVxiFc60y6VhVHSyuA6yHJzjOlE-O
Reporting-Meta:
 AAGMNtuUNBIfb/SVklvQN6oZ3ZyFb4Ilh85wtqcIidbP/aCTE277UGbYHsejAcpd
 Lvbexjc5ZnlcH8uZEomITQ19mS4FkjrgUM2vq6Y6lD3YeUUsXVzbCHhXibalK9qQ
 3DfWA86nvvvNV6bKdbiw8yD/Rt5j7My/uYODzHRtwtEMaOPdJJbJ27XAITNnBiI3
 Kq1KRfDnmVA5fH+ULfb+6nhoagLYP00uA1/Lf86tLVRxAfR6ZsfAfu9a+CBEWmt4
 BimDAawVU0JvRXIdmwjUXtaH+s+B7kFf1o3or4mm8ROEoMfoOQMBA4rCAP1tVv/i
 VLL1SrYvGkWr6SehHBwmTsCvymR8PVcW/t0qwvIYFdoDCQDvkvCUoxMe9Ay2fYIM
 kBMcJSFLpazTGpjljousBRhbILtsBLT+VULTAfFVVmIC8ELQ8BGw3M02zNgL9+BR
 RRpvPnq+wyk4nmH1eP1KTBy5lTy8EcfDThLAw+1FF0mJDm+x8ZPo579MkfPO7iPh
 zFBWKBqqk0M5dvHNph6cSEd5U+8Qi4ipe3uI0jXy5W8QBw==

On Fri, 15 Apr 2022 06:52:31 +0200, Christoph Hellwig wrote:
> this series cleanups up the block layer API so that APIs consumed
> by file systems are (almost) only struct block_devic based, so that
> file systems don't have to poke into block layer internals like the
> request_queue.
> 
> I also found a bunch of existing bugs related to partition offsets
> and discard so these are fixed while going along.
> 
> [...]

Applied, thanks!

[01/27] target: remove an incorrect unmap zeroes data deduction
        commit: 179d8609d8424529e95021df939ed7b0b82b37f1
[02/27] target: pass a block_device to target_configure_unmap_from_queue
        commit: 817e8b51eb3d927ce6d56ecf9f48bc3c5b26168b
[03/27] target: fix discard alignment on partitions
        commit: 968786b9ef56e75e0109158a4936ffffea962c1e
[04/27] drbd: remove assign_p_sizes_qlim
        commit: 40349d0e16cedd0de561f59752c3249780fb749b
[05/27] drbd: use bdev based limit helpers in drbd_send_sizes
        commit: 7a38acce229685968b770d1d9e64e01396b93643
[06/27] drbd: use bdev_alignment_offset instead of queue_alignment_offset
        commit: c6f23b1a05441a26f765e59dd95e8ba7354f9388
[07/27] drbd: cleanup decide_on_discard_support
        commit: 998e9cbcd615e5e6a7baa69e673ee845f812744e
[08/27] btrfs: use bdev_max_active_zones instead of open coding it
        commit: c1e7b24416400ef13ff92a1c60c336c9a2834d7b
[09/27] ntfs3: use bdev_logical_block_size instead of open coding it
        commit: f09dac9afb8e3ce4b6485dbc091a9b9c742db023
[10/27] mm: use bdev_is_zoned in claim_swapfile
        commit: 9964e674559b02619fee2012a56839624143d02e
[11/27] block: add a bdev_nonrot helper
        commit: 10f0d2a517796b8f6dc04fb0cc3e49003ae6b0bc
[12/27] block: add a bdev_write_cache helper
        commit: 08e688fdb8f7e862092ae64cee20bc8b463d1046
[13/27] block: add a bdev_fua helper
        commit: a557e82e5a01826f902bd94fc925c03f253cb712
[14/27] block: add a bdev_stable_writes helper
        commit: 36d254893aa6a6e204075c3cce94bb572ac32c04
[15/27] block: add a bdev_max_zone_append_sectors helper
        commit: 2aba0d19f4d8c8929b4b3b94a9cfde2aa20e6ee2
[16/27] block: use bdev_alignment_offset in part_alignment_offset_show
        commit: 64dcc7c2717395b7c83ffb10f040d3be795d03c1
[17/27] block: use bdev_alignment_offset in disk_alignment_offset_show
        commit: 640f2a23911b8388989547f89d055afbb910b88e
[18/27] block: move bdev_alignment_offset and queue_limit_alignment_offset out of line
        commit: 89098b075cb74a80083bc4ed6b71d0ee18b6898f
[19/27] block: remove queue_discard_alignment
        commit: 4e1462ffe8998749884d61f91be251a7a8719677
[20/27] block: use bdev_discard_alignment in part_discard_alignment_show
        commit: f0f975a4dde890bfe25ce17bf07a6495453988a4
[21/27] block: move {bdev,queue_limit}_discard_alignment out of line
        commit: 5c4b4a5c6f11c869a57c6bd977143430bc9dc43d
[22/27] block: refactor discard bio size limiting
        commit: e3cc28ea28b5f8794db2aed24f8a0282ad2e85a2
[23/27] block: add a bdev_max_discard_sectors helper
        commit: cf0fbf894bb543f472f682c486be48298eccf199
[24/27] block: remove QUEUE_FLAG_DISCARD
        commit: 70200574cc229f6ba038259e8142af2aa09e6976
[25/27] block: add a bdev_discard_granularity helper
        commit: 7b47ef52d0a2025fd1408a8a0990933b8e1e510f
[26/27] block: decouple REQ_OP_SECURE_ERASE from REQ_OP_DISCARD
        commit: 44abff2c0b970ae3d310b97617525dc01f248d7c
[27/27] direct-io: remove random prefetches
        commit: c22198e78d523c8fa079bbb70b2523bb6aa51849

Best regards,
-- 
Jens Axboe



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
