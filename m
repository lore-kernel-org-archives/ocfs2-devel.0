Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F548C46467
	for <ocfs2-devel@archiver.kernel.org>; Wed, 30 Nov 2022 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7Ikgq2UsIpcTh4R2jM2qPwosTuszsSy55aPJCRr4Gtc=;
 b=kfu3lmxYqua6D7pdPeK2GKZgCikoqjsWakZ/Y9aJjo8/edAP6LODMwLQ/20SFfPz1hG8O/XwidMy
   AvXhAQG++vE1XEEPAdi0nAP+e6wy1y0kCqPv2VJiHVEiKFDUVSOh9gwhEy/eXFcYyV/WWNfgpCzn
   0you40NDfi41bu2rptveT7MIThi0MGk0gmQ/MEe0ZXZqAPYKTHdzHIr9ZYgzzYIlkSEkTc9KivRo
   SpdmaklcTema75S50EVpdtqjrs3MicVWWDNXFvwyVnMcC4XMZF8Gg/3AWbDUekmX64WaPqM0iLkT
   ovHu9uRoBIeQqneiYI+yY7bkgzxkDIf2UiiLVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7Ikgq2UsIpcTh4R2jM2qPwosTuszsSy55aPJCRr4Gtc=;
 b=iTJ+HMVv8RR38F88xxOL8X3RX2boud1TdOkkBMrlk/rFOUHFJeu9KNyDGtXNhuc56gZZ3uaAGw2R
   2F0pvfSchKqWEtJLvPpAvLwyaGjh8A/zsT0vQKa0nrN87C3/4wxRW+MX01pjRix4uab6xD7soGts
   Ou/i1fZ9nsGS+WSTQWPZsSfqpj3Hi/FZrEmNfwcUynEkoMG8O6g+aVXfVcd/yNF/S+ksi83hbzcB
   6rVCN+vnI/U58PavhDbtwXejCxdSrLHAezPDnVkLETzCusQ8Yxh4NCx7BQ6OwFABi4c1ImXKeiT9
   7u+OMpxHepMWBQ0XkSyHGKqxigkOXOimbCaLpg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM6004XE75RUCD0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 30 Nov 2022 16:58:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669810058;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jnVdlteFV26Z76cEF4gxE55CdPW4P3QACX8nQF2ZXTo=;
 b=W/dSB4qs5hwMfYN4TjxxFnqFD4auu9K07/woj4RDIZunyWcd9qT2g9XoFZvOSjAqfTe4Ga
 sPDuA5GKhAnz1PJtE0E805fwucXHtgi6wF0TyYucotzcJnBT4lkI2YNflsI6f5EEvixFEq
 5X6WL3hpHvkVlHRo2bXgnkAdSZ4Yo+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to; bh=jnVdlteFV26Z76cEF4gxE55CdPW4P3QACX8nQF2ZXTo=;
 b=5TG5s0/ku7629WG3kPbWT8VhEQR3KzcbQVi1z+b+vek20G/0mQL9nUZQEc77gdo7Fz
 lBQwWpe9ql1mp+eqiTxMQ+ghFkFQ03ozcoyepfZuXcCCFbTHdctvcukeuUUEfkABjGBU
 PLschdIgvqEIZSB+ttvZOOKUiJRPz2t9jgKk3uMWcIBr9A+CHMORGQd2GLTi2mEbdGlu
 xgOwdCdSDkXvnWRC/ECX+HWTFPDQbtR8a1bA1dsvRG1qIjdgrDQQbxM85Ot1u4IGVe5o
 xZp/ZkGy2i8YflzUt6XwpGrbyArEDobagW16oEA0gL2V9JXsSCxPqWajYIzWnxOcBpOV Ql5A==
X-Gm-Message-State: ANoB5pmi6g2RAhgyJww/9T0dIO+efC5f7dgaegUAWB+ncAewTeofRD9J
 6Qi9PChfE6pLT0O0AXWwju2Gyr+NT/VuBGp/TYkhYEnFt0fy5h4QTMno6BXlAqNmj7HG0GuOyeS
 eoEWE60vDVbn3F5QY0FAcaA==
X-Received: by 2002:a05:600c:3c8e:b0:3d0:69f4:d3d0 with SMTP id
 bg14-20020a05600c3c8e00b003d069f4d3d0mr4598077wmb.93.1669810056101; Wed,
 30 Nov 2022 04:07:36 -0800 (PST)
X-Received: by 2002:a05:600c:3c8e:b0:3d0:69f4:d3d0 with SMTP id
 bg14-20020a05600c3c8e00b003d069f4d3d0mr4598054wmb.93.1669810055886; Wed,
 30 Nov 2022 04:07:35 -0800 (PST)
Date: Wed, 30 Nov 2022 13:07:32 +0100
To: Benjamin Coddington <bcodding@redhat.com>
Message-id: <20221130120732.GB29316@pc-4.home>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <20221129140242.GA15747@lst.de>
 <794DBAB0-EDAF-4DA2-A837-C1F99916BC8E@redhat.com>
MIME-version: 1.0
In-reply-to: <794DBAB0-EDAF-4DA2-A837-C1F99916BC8E@redhat.com>
Content-disposition: inline
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10546
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Eric Dumazet <edumazet@google.com>, linux-nfs@vger.kernel.org,
 Marc Dionne <marc.dionne@auristor.com>, Shuah Khan <shuah@kernel.org>,
 Mike Christie <michael.christie@oracle.com>, drbd-dev@lists.linbit.com,
 linux-cifs@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org,
 cluster-devel@redhat.com, Christine Caulfield <ccaulfie@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, Anna Schumaker <anna@kernel.org>,
 Eric Van Hensbergen <ericvh@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
 linux-block@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 Keith Busch <kbusch@kernel.org>, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, Chris Leech <cleech@redhat.com>,
 open-iscsi@googlegroups.com, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Steve French <sfrench@samba.org>, Christoph =?iso-8859-1?Q?B=F6hmwalder?=
 <christoph.boehmwalder@linbit.com>, Chuck Lever <chuck.lever@oracle.com>,
 Lee Duncan <lduncan@suse.com>,
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
From: Guillaume Nault via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Guillaume Nault <gnault@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 9U07sd7VMRewUIS5-iGkwA-1
X-Google-Smtp-Source:
 AA0mqf4PpVsPubG71ps8rgagttNzK50w8zECDxzJfF2enqQnAPQgsvcgKe3HBaErdsIeSxrgevrHjQ==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: AK_q0IHBfApxBp_bQaRWm6oIN83F1bZC
X-Proofpoint-GUID: AK_q0IHBfApxBp_bQaRWm6oIN83F1bZC
X-Mailman-Approved-At: Wed, 30 Nov 2022 16:58:36 +0000
Reporting-Meta:
 AAHHRjIC+jKnyfF3Kct35YvsU0CjM4kdIqkl8HIl865uWcWiUxlGwARqbhbRwMsC
 IMdWOgWkfb3qFxpUzuuc6OboGTDGL9MOnc9AheBvTLEps7pZ4xbK6eutSDXU8RZF
 GeEJw5Sd//UHB0nIjfjM+D13lw90DAzBNmw0KShMh2RCGT0f+occtPTO05s7wN8w
 N9xiAh91+uO6kghe7ahvpw60NZBdJO3jj4r3weUNYvOw+fJJVglxPs9QdRjI6hVl
 GuPgKcI1Nh9vwjogUw4rIv078jCbUGwwb4xZNyhamGJ7g4n1Uy/rH5SXSygc8VzY
 9qGO0HPMC4Op6gyBV7zTRdIXIZzOna8SyTLiRBYMgB/IWhTEZx4hVjnZEfEDz4Go
 DHMzDzNfz1GLVY9TJNWQEUMs9zFDWG3ygs98v4t6CjSUvACKyA7/nDcFe7A+F0kL
 v5L7VlXjR14EOdBsjdZHdbIKuYgN+Mm0llVoUeIz0Ws9FasXxKEg6Sd8nAH5UtNL
 OEdvF5zQFyTmUXMUUXKuiBzz6S84Y7Q6QR49a9AJZaCK

On Tue, Nov 29, 2022 at 11:47:47AM -0500, Benjamin Coddington wrote:
> On 29 Nov 2022, at 9:02, Christoph Hellwig wrote:
> 
> > Hmm.  Having to set a flag to not accidentally corrupt per-task
> > state seems a bit fragile.  Wouldn't it make sense to find a way to opt
> > into the feature only for sockets created from the syscall layer?
> 
> It's totally fragile, and that's why it's currently broken in production.
> The fragile ship sailed when networking decided to depend on users setting
> the socket's GFP_ flags correctly to avoid corruption.
> 
> Meantime, this problem needs fixing in a way that makes everyone happy.
> This fix doesn't make it less fragile, but it may (hopefully) address the
> previous criticisms enough that something gets done to fix it.

Also, let's remember that while we're discussing how the kernel sould
work in an ideal world, the reality is that production NFS systems
crash randomly upon memory reclaim since commit a1231fda7e94 ("SUNRPC:
Set memalloc_nofs_save() on all rpciod/xprtiod jobs"). Fixing that is
just a matter of re-introducing GFP_NOFS on SUNRPC sockets (which has
been proposed several times already). Then we'll have plenty of time
to argue about how networking should use the per-task page_frag and
how to remove GFP_NOFS in the long term.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
