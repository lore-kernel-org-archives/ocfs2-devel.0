Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02105C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 30 Nov 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XuVexewj+HGDZ5fmjPLHRVHJEJV9lGMyA09may72IgI=;
 b=CUBO/8RfdPOiTDKDsXJscY3t2B9/FUUAtpT46UW7W93J6wiIcc5zmFbkUZgettSlkkNMDvVKCF2L
   2dUIALimEbWXoCmLf/oCqvYU6ejknPTYdoPAoNzlr21B3GZOHKhforq2qaDaSFg0atlfsfKrjHKC
   t+jNZDY5pwD1UZM9EgzjJfvnrB7nP8CHqyMM7jqVBGjBlEP/kdSAPVxDf4ptBcZSpVflYms6k82v
   n3qYoaUK/VzX5MkMqtuWWpWEdmreZclQc3zmzbvlSor80wvLPXrjklcVLpTXvzcrBmbifardsTPo
   0BygOrkVFIyWUFX7msT2kcIJjcZ+PVPnKRqRag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XuVexewj+HGDZ5fmjPLHRVHJEJV9lGMyA09may72IgI=;
 b=WU22xYIuhYWjax7CKszTYzuJlWXEvhbnusvmI0xS0gWxFpFX7AuvP62MDW5cVjAqkHnPQTak+TyN
   zcZHjqB2bNmJEGRQauYP1gy4V7ZGZYtfnDvOtxrU86cbexTlCByoNQX/Xb70TomL8gaNzQGWQGDh
   a2Khy575bcp3ONqEaDhscd8r1IiulwZfvJE+iYhtyOXln9ga8Q4P5D68HLKSwROYUMQHbKLZcG4J
   yHm8TFTAcfZuU175JxyF+qUMUdXGRT0AHDRloCuh6IDn2DmvoY2c2yrt5gxGulbF2AgmYki4QVa0
   cOF6cDfgPk/addB47ecqX5j6/GOmcuNyCZmpWQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM600CKY75RND50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 30 Nov 2022 16:58:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1669743759; bh=3+jgbqIH2MJTIsVHlcxt6FoqC9JTTWJi5HGZCaZxgug=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=QUm6mA5J8FMakXMYs9TxR1saaYz2xtuB1WQ4vJJERTQPls5BaIPHVnOKz8jZIo9kT
 XulObDx1A347icJCI3BmL1Pf+V0Y6vDE7c7GJVgCQGxPvlvdctmnzKGaymxCYNMyXQ
 dKw/DfIH615h0CSbluMrGHtANR4WOUzVKajaI/Lk7UG43sRTDV3681zTOgmNB5PA42
 4z8cYl3L4lhD0Mvd0OcboC2hB3hl3nwz3MNA3jwsaSJnlHZe8k2mACwlMT6PMRhQUD
 9V/1JVeknQRJ/G2/votnmVuu78OlhM7g7yW8UlJERa2tg+7VQlKisF3sYHT8GaId68
 G+E9LkyPR/ygQ==
Message-id: <d0a8f7a5e307e201926ae8e80d629da10c706a91.camel@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Benjamin Coddington <bcodding@redhat.com>
Date: Tue, 29 Nov 2022 12:42:33 -0500
In-reply-to: <20221129140242.GA15747@lst.de>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <20221129140242.GA15747@lst.de>
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37)
MIME-version: 1.0
X-Source-IP: 145.40.73.55
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10546
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 Philipp Reisner <philipp.reisner@linbit.com>,
 David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>,
 linux-nfs@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
 Shuah Khan <shuah@kernel.org>, linux-afs@lists.infradead.org,
 Mike Christie <michael.christie@oracle.com>, drbd-dev@lists.linbit.com,
 linux-cifs@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Anna Schumaker <anna@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
 linux-block@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 Keith Busch <kbusch@kernel.org>, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, Chris Leech <cleech@redhat.com>,
 open-iscsi@googlegroups.com, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 Christoph =?ISO-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Chuck Lever <chuck.lever@oracle.com>, Lee Duncan <lduncan@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/3] Treewide: Stop corrupting socket's
	task_frag
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
From: Jeff Layton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jeff Layton <jlayton@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: sin.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: JUA8QpiEedyoJP0HI6JBSq2cPpvrNHL8
X-Proofpoint-GUID: JUA8QpiEedyoJP0HI6JBSq2cPpvrNHL8
X-Mailman-Approved-At: Wed, 30 Nov 2022 16:58:36 +0000
Reporting-Meta:
 AAGah/sOmLPFZDatqAfsCOVrCfFbNLADOz2SYWxEe4TXMqV/8X0Vn3afpz+g4RWw
 RJkNKuxTusJDarjyMyQES6Sh29jaXTQwEf79+/zYuiHg023b8QwSnJN+sDtnlXMd
 yQU0NfBgOYfByI59QEngRO6I1vB8e9d6weeKdpihIWEnwl/14Un8Z4YXTaqDu1WM
 V9A5cbGpVo6bINuXlujjuvRCtmaIxVk1kL7YmJfI40uS08zyya1RYN9fi2wzo3x0
 nnBJsEESFQhs0zZ0izFG1xsTa/nKsF4yUVN/51wfJsi4BYJ6TAHT3dLlTVVq3jGz
 fu1u//Uas06ePv7HwUuNMXrh7e8CDF8irpbB4bNUHGW3QHKOjY/s7Ga8EgJ6FxJp
 Rpkm4Ky/wlo+8Z95A+0oxSxs6Mwk8MUc3oFyj/Y6fojAQRoU9E20W6ROF7aK1kBi
 XascZmMaZwsdXcc2RviInxw3X/xI0F4mR41rmW0EW24rMOlxX/NiX/SocM6Fcxg8
 L8/BacxssroMFmJrN+av1pMpRGTlaoJV/D1I2zcHFaXP

On Tue, 2022-11-29 at 15:02 +0100, Christoph Hellwig wrote:
> Hmm.  Having to set a flag to not accidentally corrupt per-task
> state seems a bit fragile.  Wouldn't it make sense to find a way to opt
> into the feature only for sockets created from the syscall layer?

I agree that that would be cleaner. task_frag should have been an opt-in
thing all along. That change regressed all of the in-kernel users of
sockets.

Where would be the right place to set that flag for only userland
sockets? A lot of the in-kernel socket users hook into the socket API at
a fairly high-level. 9P and CIFS, for instance, call __sock_create.

We could set it in the syscall handlers (and maybe in iouring) I
suppose, but that seems like the wrong thing to do too.

In the absence of a clean place to do this, I think we're going to be
stuck doing it the way Ben has proposed...
-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
