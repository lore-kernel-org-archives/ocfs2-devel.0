Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82BBC04FDE
	for <ocfs2-devel@archiver.kernel.org>; Fri,  9 Dec 2022 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FV+DpY+cLGHk6ivhgwWk5FxceJ6qvF7S8/DnfhiYZE8=;
 b=vjWJzELDhX4YpjDiYOc25jJo0qscVqoSpONZH4hwNu61IxeT8qPubaIEKG3t+accPndau1GdK5gt
   OHUo140SCOQpS6XAfpcFPW01Wl6Wyl2Gbm/FIT/4OV70I9sePT9bkSU+fqgMPDE8vzqmAaPZQmOM
   Cfc98AsCLQEcoNcpnAxo/OPXhYdbgDk3fEKuKqBajqRr4Wy3KpK5IrlmugWC9LKp68DcopwLPS6p
   mMqROSGp/6EloDy+W76sQFeoq+rJdDu7toEbsLa6k4nYNNh3PpYziONm2d4c3jZ5Qr2+JwzLIoTA
   oWMmJ3fgKAnRQTgKtHu0/SbeUJX7QEOE55AUXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FV+DpY+cLGHk6ivhgwWk5FxceJ6qvF7S8/DnfhiYZE8=;
 b=Gah8FbT76oBGpZPf8MKPf25rHTtBHnqFU6k1tBUfGPnBrGhbCcwMA0nYz+YxBxp0YnIkqZif2aBb
   CrHcjVDCa8vkyAFQckMpjPjth9K/Z+A83RWtUfPSF94rWYa6IEoIvj0zCnwaJ7i4jXZ82NP8E32T
   6QcBqof7c0S7uXptpqNPYYZNqnyRdsVUQROahg3zQQrLGjFEhb3eO0MjOI3mCil8chLZzd6Hz6Yo
   yOFI9j4gXCwOs/4h7UC+yGhqW9N2rgm0qTLKcjIw7fTMvJILIP6PkQtrciZ7l7/nYHipXy5R8NFS
   vdXp5LnQWVE1C2gHJTrLhdEreH7zZ9ub5a324Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221201 64bit (built Dec  1
 2022))
 with ESMTPS id <0RMM006R0VM3IIC0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 09 Dec 2022 17:08:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670604673;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hEHtknj7G67yuPB9tWefZgr9ALjA/T5Vl29gdCA8cwI=;
 b=cPRI/kR8AIBHENzdjGP712YpUpmzrnR0h3fuN+pIP+/u6CWbJLpt3jMyrt44ENSnjvuz9o
 fmkFnR3u2jOo5cESzoteQXGs/Kpd3d1K9yTrFGwajlCcoqwhqWtImOPeWZQmzp1oCerDT7
 fajW5URBIu/oXApIAtl0n9k3xeaYTAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:mime-version:user-agent:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=hEHtknj7G67yuPB9tWefZgr9ALjA/T5Vl29gdCA8cwI=;
 b=zeo37tenv3Hcf4vLtlfzAjHxIP16Csbo1H6aTUWVVv+tX9zv2Yfd3DTVFmrhzNMtjR
 wpJJSzAZYgqhoCSXblpIMQ44aUz+7dcCUcVz0R7pl/kZJgIPDSqz/6G8sM3ouCaeSkB+
 7xOEVnbIHJ2HXUepuNd2PEklLx4Oza2TFcQfb+6PkqWsBVixc63CFPnelTiBJuvr2q2Q
 zbEvOUpbaeiDEabusrxHc1ohOLdm+uvgy3EJvbZwa1s55CVYZ7K0Z8js37YrtwJNNfNa
 sPZh3hNp/KaXqNn3S/cgsBkcuhODxBYDRPBX1K39bKefXPtU6oRofdwa0zAktvlsdbjM wGbw==
X-Gm-Message-State: ANoB5pnXECIF05yV/uwwPMRnBELQLUzfkljAAZu46R9g5eco/XANwhJ6
 B6uMOBpfc1CXfkmHIbNO8rUO2NdQ52HyO7zr+zYec6wdGyRpAEJDtHCgHNjdPi7SWRRIC+3tAzL
 PP6TJ/Y2FlHugPWuN/qUAGg==
X-Received: by 2002:a05:600c:4f48:b0:3cf:e850:4435 with SMTP id
 m8-20020a05600c4f4800b003cfe8504435mr5700781wmq.13.1670604669141; Fri,
 09 Dec 2022 08:51:09 -0800 (PST)
X-Received: by 2002:a05:600c:4f48:b0:3cf:e850:4435 with SMTP id
 m8-20020a05600c4f4800b003cfe8504435mr5700758wmq.13.1670604668951; Fri,
 09 Dec 2022 08:51:08 -0800 (PST)
Message-id: <73186bd6e1ad62da16726b95b1a266c0aeb39719.camel@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 09 Dec 2022 17:50:53 +0100
In-reply-to: <20221209081101.7500478c@kernel.org>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <d220402a232e204676d9100d6fe4c2ae08f753ee.camel@redhat.com>
 <20221209081101.7500478c@kernel.org>
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35)
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10556
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 Philipp Reisner <philipp.reisner@linbit.com>,
 David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>,
 linux-nfs@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
 Shuah Khan <shuah@kernel.org>, Mike Christie <michael.christie@oracle.com>,
 drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 open-iscsi@googlegroups.com, Anna Schumaker <anna@kernel.org>,
 Eric Van Hensbergen <ericvh@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, Chris Leech <cleech@redhat.com>,
 netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>, Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
 <christoph.boehmwalder@linbit.com>, Benjamin Coddington <bcodding@redhat.com>,
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
From: Paolo Abeni via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paolo Abeni <pabeni@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: psRH0Z0CPRmzoQpl3brW_w-1
X-Google-Smtp-Source:
 AA0mqf4vPLwblTckd8B2URRNRbKIW7VqMLQd/PWlQAHufJr6jh2xD5egmlwfWsaGwQofLy1f6L/9tQ==
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
X-Proofpoint-GUID: 5DuzdQCiS7Znrqd37GmjrnGexdQ6eKvr
X-Proofpoint-ORIG-GUID: 5DuzdQCiS7Znrqd37GmjrnGexdQ6eKvr
X-Mailman-Approved-At: Fri, 09 Dec 2022 17:08:25 +0000
Reporting-Meta:
 AAEqQoLPdz7GRuleUFnYbQqrXDu0xBzN2UjGwWjbOJUhJqXMM07p33HSUE1eWrDz
 XBvDOVZnXi8oi2h6TrLHGE4DQ0OQDR3M3Z1D/y0Arh2T/+NGYlyM7E8pDLnl8tx6
 U/XVAOxLd6NVFNDHyAD5wuRXyNqRdjKA9CWfqANcm8cP/dQt3pg8yd52vozHIRaT
 8i+uZFq0ZmtQ3gySJ4izVCXJbkcKm5mfUp5n9lHBt637VNEn/SyqpKiuR8u+3PoC
 vCB/K/Thi/wzHK6bO5sQ+rNufbBKDhJWQTRKY3YQqcgKjPM2JP2ZclfMLmlCVHfJ
 hjRgxW0NtmEm/840KgwTFJ+aabb5MhYqoupF+JRGr4QiWs1yTKCaJdbGyC+8YqZS
 GUvI3aL3emhyvTJOupK4vXmaQFqIXjyY2XbVXFJf3bsXWGR3NkCfBqxNH6kVHHv6
 HBUDfq7+/ginFV5xv5EgcXYOp70LO2xdZKa8wbs2BXqAvhHpbru6evCLBMGP1oBY
 GIKuNtoOZPv4GVR0O8kH82Dm2C8O4YE8Bj94Vs/Ai85G

On Fri, 2022-12-09 at 08:11 -0800, Jakub Kicinski wrote:
> On Fri, 09 Dec 2022 13:37:08 +0100 Paolo Abeni wrote:
> > I think this is the most feasible way out of the existing issue, and I
> > think this patchset should go via the networking tree, targeting the
> > Linux 6.2.
> 
> FWIW some fields had been moved so this will not longer apply cleanly,
> see b534dc46c8ae016. But I think we can apply it to net since the merge
> window is upon us? Just a heads up.

We will need an additional revision, see my reply to patch 3/3. I think
the -net tree should be the appropriate target.

Thanks,

Paolo


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
