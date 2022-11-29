Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FD0C352A1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 30 Nov 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9htgZIz2RF64IkV9Myjte9jQbAVV8Y0z0qACX/rIix0=;
 b=uBYhYgnQFKtmz8WPdPE2QiiusHtaeQMI/o349YcvlhObca275iCeb19d+/XtGRAcny6NTO5dQYfs
   gzAuyATuGNP/I1uIKBbAE9C4yAGFEhaz/AKEg5LUR/gdX8WBwPznM/7x4mU5Y5x0BGFdoHkf4ZEL
   P1ThwnTSYUJJRp5Kzpa1+0AreBJo8tUp2HayYFCuRZsNwf/Pas7hV9X8YrGA4rFm3pKBJiygS0cL
   gXYb8zYooajCAcjgEHF9SGdziZFAKP6CewWQB3oqaoRBX6EujP3gFfp6lA9Qj7SAIxbTXyeX47Z5
   6cwNkYiFTKUZDogXxsl/Caje/Id4RXCwnsuVLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9htgZIz2RF64IkV9Myjte9jQbAVV8Y0z0qACX/rIix0=;
 b=M5FTW9tdJbD6WyNSA0ORgFf0EZ/0VZyrZanC+ZbBnQCqDTTMpd8U00usnIurVpnWZKudPyi8Wk5q
   0PjKzqOBAsZbJz/ZDGnj8qkuXMIJSIa6yEMKQWtrwQHjMBCqMNY+iSw4HtPdFS4vuzoouO1WRYXE
   HRdyt0mxmf+i6OXSszqUIzNqeoAW+9JsJ6QKEZ8Gb/7e36dbzCMPzrFMFvr5LxNURJMeOipAsmEU
   D4Jrt+wHUyNGD4oDvbwH/q0KVtN6MSTirAhyZjxnijHtU/6OHzgnEjvaXRSNERMTmjyM3KSPCpRZ
   YJVcjty6gs0pI/yZapwaH8rppRNr0LDyCYvL9Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM600F9075R5XD0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 30 Nov 2022 16:58:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669740481;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=e0muEHBDbnLFxSz/8uKrynkgUxzkHQQXyf0Q/GGNCDo=;
 b=K/nE77BgifFtolvBtF+r3nZ8JC4AAZd/wKlA6TAZyl+hEG+CqKfJr8KIYQj+YIWV56d0N8
 2aKHysieru32Ob0iV5QrILnbqT0sxNnCTP1tYAHvZ43GddS29yHVHFPa/nrOuPSNM5uV1h
 ehDIHjhwUIIOS3OK5Ak5Aw70fySuWLk=
To: Christoph Hellwig <hch@lst.de>
Date: Tue, 29 Nov 2022 11:47:47 -0500
Message-id: <794DBAB0-EDAF-4DA2-A837-C1F99916BC8E@redhat.com>
In-reply-to: <20221129140242.GA15747@lst.de>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <20221129140242.GA15747@lst.de>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10546
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
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
 linux-usb@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 =?utf-8?q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
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
From: Benjamin Coddington via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Benjamin Coddington <bcodding@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: NLEV3qqHMjm2VIHjZofz1g-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Proofpoint-GUID: V9N_hxMuOb8Ebm1E4W8z1jiRFBpFvPDW
X-Proofpoint-ORIG-GUID: V9N_hxMuOb8Ebm1E4W8z1jiRFBpFvPDW
X-Mailman-Approved-At: Wed, 30 Nov 2022 16:58:36 +0000
Reporting-Meta:
 AAGS6nJP22xNVbPY9edaY2MHtHi8xSrAuMQbYWrGM50mtpGTx7KE9ihH53suoPn8
 RHGN4YqG3QBXu3/yaeQbTSk6HLS13tkC1Klu77/51Uqag+Cb3KZeNKt5bTDmozCW
 vk3vMIWnBxIFmrQJ05963cLlLzpEqIgSTHfTIOHsbT7fxRBF6u3kvAoupHihjvq4
 k2ZINJoLRdyqXIY8wX21eyss2TEKcxQxEqDRXKHnbb5/JYC8usJP35Vb6sVx7igZ
 8TaN0t3cuqI1mGrMx+hbIU3MEnIFreHjKmw+H7EnQsSELSnmaml5oOUgYDbXEuEd
 KZ+0Rg309HYFRN17bw/trcLR2ih5FblUOFi6gMU7uGpXmQONuuI29/VxUVonbgl+
 OTW9UVsoqZeh1e8IBI32DAs2TBgyhSpHAaU+ntrQexDJTNXjv+rgH7LKC9UHy7xs
 /7d2RLUDX4TUGpRTUQ1UDo/RD59qC/UilZzPm65uzDDsYIzPOljOFwLhLDS4tyAg
 dzzpLd4X/cN/lesZjD81yEFZv/R5l6Qm1aHfO7y7ZDQ7

On 29 Nov 2022, at 9:02, Christoph Hellwig wrote:

> Hmm.  Having to set a flag to not accidentally corrupt per-task
> state seems a bit fragile.  Wouldn't it make sense to find a way to opt
> into the feature only for sockets created from the syscall layer?

It's totally fragile, and that's why it's currently broken in production.
The fragile ship sailed when networking decided to depend on users setting
the socket's GFP_ flags correctly to avoid corruption.

Meantime, this problem needs fixing in a way that makes everyone happy.
This fix doesn't make it less fragile, but it may (hopefully) address the
previous criticisms enough that something gets done to fix it.

Ben


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
