Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79530C4167B
	for <ocfs2-devel@archiver.kernel.org>; Fri,  9 Dec 2022 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DQeFUZDEK0dg/489OgOFmmy80u2dxNAQWBGTqC3jHc8=;
 b=oWFOnkNrfNF6/+SlMAclUwyTVDWpJkMbRC8pXoAYFE4Y0jHojk4eH1xTZ6zBz8CW7dCgzZljHzwo
   7jgCGSZcR0mhCc9uQ8PhVgak1FocN1aEao5WbiRu9pHelQJkbHGKjfCTmqLyzWG74T0lTsKlyTns
   f8Mn4uqCUm+4f7+OkF5FTrfAMdCLmIdF2qS4WDGIpAayXQ0QZyeeXyEyL4IGaVt1QlCr1oLL5y+C
   UovBdOA1856oT62fb1o+TA0BC5fGu2B9+ERkrwUtcTIAnYU1s90sCejGWNa3gg1pNmoSug/8EliE
   5m20FDOCCiZIid/r7QbeHazyHXeCRLbO/KVftw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DQeFUZDEK0dg/489OgOFmmy80u2dxNAQWBGTqC3jHc8=;
 b=Ec7CH92LKu7pLFJHKVqXTytUkRTVPvKBOIAyUuBD87DWaScfnPZK0r2sEJWbIzydlfiMowDKHsMp
   pNCgo8KlAWu47UKtSdvELmDVICxtexsGPOF4L25PIKjmqxJ5qClYHauqrqEiaEUrZQuZbclzcRwa
   uXlqri9h1FJ2sqdHJHg2UelBb//esIU+mI95LiyNi7cFlxouDC6Ih5J2BG6nKMpGMQhWxZYcFw8Q
   ohJK/KgakBx4eur1XA7nIOtkDck8O3G3hlZiFreLBnXkYgtQSQfHNihO11Ljr4rjaEhGFmNjAwYJ
   xgtHt9ZV9EY0UX5gEdGP7rTXuARj0vWdw7bWUw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221201 64bit (built Dec  1
 2022))
 with ESMTPS id <0RMM00G43VM281E0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 09 Dec 2022 17:08:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1670602264; bh=OclmnU1jYcdMFqciE3c6RyUB6hgvanpdH2l220bFhz4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=lP5pQ24T3IT2YBfVVAYFE/vlA14kPUGpHI19DQSbfMFFqcLV6yfVQX2yzf3FWU9BJ
 DEPOy15CleSzGVLHHvdVrCdctgS6AMOlWyxNMtd1UP4Jl6EFRe7WSmHsdwacu3KmIi
 3gphHYn83fw+acEzH9vRCOj48wMtBY8ejFf/mJMd7kxsJCGH1dwZt2JHDO6M2WNy+F
 RxYdcuexGpRtzv/r3df/M1OzYPk521V8CVwEXUXt0ZTCVSTYNw6OFG3RfFVHJS6f4s
 Cy+bJUuWARFf6RP5DMfx0m0W7Y2ou/9vrV6yP2gJYTEe5AantjuQErI6+6QNzX5szc
 v2qI3ygfSsAtw==
Date: Fri, 9 Dec 2022 08:11:01 -0800
To: Paolo Abeni <pabeni@redhat.com>
Message-id: <20221209081101.7500478c@kernel.org>
In-reply-to: <d220402a232e204676d9100d6fe4c2ae08f753ee.camel@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <d220402a232e204676d9100d6fe4c2ae08f753ee.camel@redhat.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
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
 Steve French <sfrench@samba.org>,
 Christoph =?UTF-8?B?QsO2aG13?= =?UTF-8?B?YWxkZXI=?=
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
From: Jakub Kicinski via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jakub Kicinski <kuba@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: 08OTy_Dobn14lgmJLrNygS2mQQJSVPlw
X-Proofpoint-ORIG-GUID: 08OTy_Dobn14lgmJLrNygS2mQQJSVPlw
X-Mailman-Approved-At: Fri, 09 Dec 2022 17:08:25 +0000
Reporting-Meta:
 AAF3w0QwxEAH5UaQvjijwVTQafBwUenzs2pHnrXGxfkO3F08pEKC5NXUBijXx8hx
 Hl0KoE6H/21XYsbK6aLp6+iIhd3IzqoCAlxQouqHYW7a2S6Zjh+52oHxBc0gCwVS
 ssrj9TKb4GkJZd2yOWJuYkeepqTpEQ2EWIrmFv7vbDdamVJna7qPp7P8d/+pry+2
 aX+foDk/aTkxtW2HVM2y0OVVKYgAgBRbay8raWH7WFMlWWP0qw+SVxI/1rferfXa
 QPoJiM6DX1b6biI0t6PiE/k6ZMhGcidUO45/DzLMUiIq/3/yulP9RcosUNVxiwMm
 mFuOCV/kwDJ2HdHXA2fIBPqfhS2P6UrIH1M14TSlj3r0M2rmkQQwIL3fsUlYIrn6
 Aers/B5Jkm4bT33h9zbjr6t8TMB8t7GWFuW1TX1UG/FMLwUx+2xzD1TqJtOzOovD
 lX0ooLYN1USDPOg4nkbm8fYq3eXotMXAMAR9NRBzA/Xhj6sYyQwweIJ7NiSK/z5n
 Deer+kxq/3L8z5RwXI5qw6hv/H0DV0GV9jLKIsxAQ7Cd

On Fri, 09 Dec 2022 13:37:08 +0100 Paolo Abeni wrote:
> I think this is the most feasible way out of the existing issue, and I
> think this patchset should go via the networking tree, targeting the
> Linux 6.2.

FWIW some fields had been moved so this will not longer apply cleanly,
see b534dc46c8ae016. But I think we can apply it to net since the merge
window is upon us? Just a heads up.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
