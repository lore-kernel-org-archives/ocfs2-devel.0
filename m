Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E7C7C4708A
	for <ocfs2-devel@archiver.kernel.org>; Wed, 30 Nov 2022 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4oAIzVL5DFlwdohoympEFb1ggqVKX3W55tEYe0+UFMU=;
 b=nk7fYkwBtXq8CRbnSSe3txVR/Y1YxSSC5WYJMpxuCRoct8X1nQbbmgV2UtvYtpeg7sdWDFKN3PP5
   S45sjadi53276lnCw0d6GJMiZ6bYSp/is+mscMdsv0o+jPC85s92eMRU2QRhVfaF+0p03jlfkZCe
   aUv91hWwtsZkYv+yyY075cFB9hCdw7bQQQHJV3Wq3FC09i+kRb7VJn9VVkr5tbZ4nYT9KhkLudgs
   h8xBN6SIC3RVZRaZIrNxV50qN3t0YRaBWN7E8MtevPsSBjrPAGu6zxwUw2y1ROGVu4pJtW1wL6Yw
   utXXzpJ2nRTK06PeOgkKDsCnL5iPIkob06MXXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4oAIzVL5DFlwdohoympEFb1ggqVKX3W55tEYe0+UFMU=;
 b=Q2fMPCki2cOep9kPe82sU2+KQDqxz6nUcRKjamO1cFA26GaK7Cumxluh6e4FJqIQrY2MIL9wNDgE
   S6/ErQHoZRDHdbak7qT2AJuD2NgOexY/vMuyUHPXwCZbLRhEmBkIhBxpXrtPIAmDdg+yJCvex4k/
   hikqa9BCSTdbfyvTvB7S0csmvFxhXJvf51q0BATTndRy0OebGy5LCrZ+GWN11z3z7m0OhoBtTlwt
   m/ustQ81qnNNIj3vMrDrIqVvbf5KD5oak1g/e/UDTCZTEqpZiKbs9ikth+zkrzXoJupAv6G1ar9X
   H1zmu6oav2Gr+BtMzp4QtFmE0ISx/oNT9x0Aqg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM600HKN75R8110@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 30 Nov 2022 16:58:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669808922;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ew+rmcqxH2n7lRVyzxgZ+S2EuF0zHGkt1auf+7rBZUw=;
 b=Cce6Epb1x/gxvawGKXvHwZ7r7X2kFRNKxGP/BXmIm3Hcxqu7e8qfgHHdK8XT9E0aRtpVLD
 KxUJdW4okUUk2bGb51epGzQi6f0o1h6MLG9RmEoU1WN+B8hnfLYll+Y6WUmQ+OTcCa6vxF
 yIHMyGLFmJBWyJuSSJHLU2bIeobCw+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to; bh=ew+rmcqxH2n7lRVyzxgZ+S2EuF0zHGkt1auf+7rBZUw=;
 b=HX8byO45SuQmiPfTkScCwAFdiRA4qs2MFoPJcugoh560UuwobnLqR4Gk34PAzmlT+1
 wOyQ6UZkhFFpr72Frhcl1TW6jbbCArfs0H9cl3tB9xw8oYMDs3cKeK4IqrkQvrsTlXN9
 pW9q/oXU81Je7MVbbceGHiW7mRmotFlN8SOzxCnjIo8bfQGuEC6yo3agjL5q+KAMgRHi
 5dtd0zHzyB3SdN7QwOuxpZy9B0SujxtVxFMmyGL5jeHihyBe+tzLFLYWQbJ/4jeMkcy0
 W/Hj/8zUYxZJOpEj8BMFfMqcfVzNjxIHoY904sEYgqYCOcR/QCLrOIaF/QucGJU6Vr7J B6aA==
X-Gm-Message-State: ANoB5pk0HkcOXfirmBbpF0DqjfiL8wmEVEUWbkN8i++kFtLzWc478ikq
 FaxhmgUg1+RfVvjbVtH+bh3xx7n3ui+m8qlDRFiebfflFtmOe+qp2gOoFHfLo70ottl8Q3gElfm
 gdp6BGKxstympSeTU5vDCWA==
X-Received: by 2002:a5d:5f04:0:b0:241:e9a6:fb3 with SMTP id
 cl4-20020a5d5f04000000b00241e9a60fb3mr22408091wrb.462.1669808919573; Wed,
 30 Nov 2022 03:48:39 -0800 (PST)
X-Received: by 2002:a5d:5f04:0:b0:241:e9a6:fb3 with SMTP id
 cl4-20020a5d5f04000000b00241e9a60fb3mr22408062wrb.462.1669808919318; Wed,
 30 Nov 2022 03:48:39 -0800 (PST)
Date: Wed, 30 Nov 2022 12:48:35 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20221130114835.GA29316@pc-4.home>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <20221129140242.GA15747@lst.de>
MIME-version: 1.0
In-reply-to: <20221129140242.GA15747@lst.de>
Content-disposition: inline
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
 Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Benjamin Coddington <bcodding@redhat.com>,
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
From: Guillaume Nault via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Guillaume Nault <gnault@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: f7DRnVDYNFC_f4AXAMh0SA-1
X-Google-Smtp-Source:
 AA0mqf71i1QvnhhrXaTwa+I+8EpX/qnDqrYR4GbrQTWzEGi7bUvVncNy/xc2a74B4erNgTJKDcQn3Q==
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
X-Proofpoint-ORIG-GUID: rzsV0AmaH2PsIJ1GZqzBznaMtX2M7gIr
X-Proofpoint-GUID: rzsV0AmaH2PsIJ1GZqzBznaMtX2M7gIr
X-Mailman-Approved-At: Wed, 30 Nov 2022 16:58:36 +0000
Reporting-Meta:
 AAGWosCjrf8dcQoNT0LLR5X+ctUqYOMnAOciSacmmatNrDb6S1LiiEOaycS7fdxU
 kVHBnfFqb9It99WeivlVzz9+nCFPtbNpgbIgko2aRt2rbylDhfDpGFmxO/ZH/p2Q
 0JalrnIRUiEstvPxTrpkCRpJkC8rTyWS5oCv3/nv00eZDrjPHixeWOG4GLwGm58U
 s4WGjIi1S1dYFzScEJVQ5uVzgpANM7pJaZe2r6Raed81H44FM4fCReRZ3ltNzJGY
 JcZnHUDwfFbf0XWv4ZU+URqhK7zLcAnJlBdn5MVsdYzVOd8CtboDeRc8f3h0RHW6
 Diuh51O1w+S0RBFQjIPAQkRiIS6rdGIGFXwy7FzXBPM1begUvHm+DkEo9F5GCWby
 3iAB9siKdqXXONlQwKwEAqW7ZSPvyzwQaSAt43kBtXFEWAYeAC9jWqDI74qq0hth
 TyOD6lnwGEjvQXyN1+McmxweSu8YxaTa+Dd8iau/0efHaQ+4zp7Arrc06AXO5pD8
 MpwiN8Gf85Wrsw6AObC4SvoPEAWA2l8ZGuGBVwlXYDpB

On Tue, Nov 29, 2022 at 03:02:42PM +0100, Christoph Hellwig wrote:
> Hmm.  Having to set a flag to not accidentally corrupt per-task
> state seems a bit fragile.  Wouldn't it make sense to find a way to opt
> into the feature only for sockets created from the syscall layer?

That's something I originally considered. But, as far as I can see, nbd
needs this flag _and_ uses sockets created in user space. So it'd still
need to opt out manually.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
