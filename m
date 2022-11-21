Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2B8C4167B
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9ht31rzmJqkIWmaucbh0iqGcgZVHvWBsmC7NfedaLaQ=;
 b=uHHDg6EL8wlnFyNuEF0EEc4WEoJDDLlEb/ToVBhdMW/YqvDZddxJlOi//oNuZPLr+TXm0U9tCq5z
   tIXYhDjwUdl/NrhHQYOeoHJ/oYuwj0qmu3KpYlKhtVmV5UVAy40BK2xmUaTh3i11szhXX0CL9iPU
   vbTTLjfKYP+YA6a7VP1ftJkF9AIaXxFVwlKlGNfbGudCBZST4YNLuW1vkcikMmCQNRO4wvxoUwqq
   srLgwTkWKIyTv4/JZsHS3jJps8/nj52QjIVYPXYw5KhgadHQ46tVw+cw223L2FORASP5nACCSaqT
   5exJDNKHPQ4EC6IxxkRE8v9Yg9dKcM6Li5f1eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9ht31rzmJqkIWmaucbh0iqGcgZVHvWBsmC7NfedaLaQ=;
 b=hgVoiWxZL/NVqSMs6nRQjuqzcREukEtM/SLBFYl2UE1bZiFGX9a98jJFRmVI+CS5Z/jxXlZoS8GI
   HkWDWSujdg+AX4MDY6ISZgU463AC2K+etNdS8nOiXiu/9IvKYQzLT56sJZBzJ469aeLNDrIViaFT
   AawAsC24EGzYKk3ORjo6gUtvW8EXlptpXWbPtcMKwToh8zbl2ArfhIVue0Eok9ir3soyNOGZw+bd
   Snaa8q/I0QgTaCLBsVV0IL165v/9SFdDzuDLSV5i31D6/jnU0UjdL/jArczhWGWzW4/0L9la8NIA
   RJnqBNMFIc5dt3k69TAMqXSi0g9o/SeGF94Bjg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00M2GVYYW340@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669039035;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZDwjBu4RghRAGfAihvi/wXSTBbp9s9Q2lKXWhxCyRLY=;
 b=XyI+L+imz1PeDCnQqafxtxvIns/Vy5UeOsLQ0gtVOTXh11ZfUJ9wIhE8jbSL18L+Cn5g/P
 Nf1SzX2LjrhgURqPM364MBr7Cu1FGVwf69yPV5jEhygsWRS1YQilmhWc3YRJB095+a8xdz
 faD9oK9XUjvXYFQLumJjHRBjV5+nQkM=
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd,
 Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE,
 United Kingdom. Registered in England and Wales under Company Registration No.
 3798903
In-reply-to:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
To: Benjamin Coddington <bcodding@redhat.com>
MIME-version: 1.0
Date: Mon, 21 Nov 2022 13:56:59 +0000
Message-id: <382872.1669039019@warthog.procyon.org.uk>
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 Philipp Reisner <philipp.reisner@linbit.com>,
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
 linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
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
From: David Howells via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Howells <dhowells@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: r7ih-rJfOeutGzbihEzMtw-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Proofpoint-ORIG-GUID: nVvY2Ly6FPzi22lPlPUuDJuYNuDjhwZd
X-Proofpoint-GUID: nVvY2Ly6FPzi22lPlPUuDJuYNuDjhwZd
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAHQhWLkpXgn2HgFLftQcpD/xmEqArfO+3rnLPhRt3f/I+r1TiB2UzVAvrw6mWSB
 IR54K932h1sGGgcfB3jD3nlH5MmxOM/Oz2wNKFq8CgEz4Ecjo2w/t7scs+/W3hIf
 DFPBHmGYdDQMzRrvDU5iz1eMRgMPTZc1ppFBkvmUQgl97LcniahAB9XuBZpTmu8/
 +pJc2XwuPBgVzVfoAHded4xLQ81tGiKtEFbeMXY/mNXGNWpnjiggAf+08dhAYCRL
 oB1zd/IBd6Su5QpN5TGYLHHqsArdtblGwZbVAo8ATqaeNxRRk6e++wGzHAPkva3Y
 o4fy6CDV0eXaLAe+TBix/f+PqcV5gKTmQK17lKGLwhL7ypAe///5RuNAnkz7TVnW
 FvGKUljGLSCCzhAsLsLPFff+pFeYORNpYETBKi+G9KYuRUOVheI6jNkClxIJCwQP
 af9zdTS5xYHvBgmorPqpKEQMiuxeUb9PZPWwisHadA5cn6a12OdKdB53Bl3OIY9l
 e8l1m7oIiYCHEV56tlDtnoLag3PW9moSzyETBhbqcTw=


Benjamin Coddington <bcodding@redhat.com> wrote:

> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> GFP_NOIO flag on sk_allocation which the networking system uses to decide
> when it is safe to use current->task_frag.

Um, what's task_frag?

David


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
