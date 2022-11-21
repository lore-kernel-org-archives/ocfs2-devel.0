Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34FDC4708C
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WAdQHAF4B0ax69rrutUvFAt7W19xh6yjlRw5kp4EEAI=;
 b=famh0RZXb/HItqcrqTIdskhedkaIcaL8dMqO66L4bNTKAk174GFizbjacmFlniWSOD2fUxzscX5F
   imqCNeDJiRUoYHDdNUa5tNx60nopJjw0ZAbVu4DGUQgwq4G0BA44vVKS4RxWKDH9G7G/fgvdvk3j
   sRJJwLVzndDRcmlh2twSyFowxA6gKAFLMIWFRAzNvt5rth04kculgS2smzqCiwCnhzyro0c647Ce
   l8m57GXP8Z+vYq19DWAchjElSrCNaEbGEhHA/A6zvel1qZ44Q1M61Z/jlKns+NO88QAV/B8dgLwB
   xjAEZidbQ4EKUN0qE8NA6Hhf9DD2EG0JPgVExg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WAdQHAF4B0ax69rrutUvFAt7W19xh6yjlRw5kp4EEAI=;
 b=Itpw+gx9642smkFngWdmjVsWsCsvTKjCgWhKO0pN7rD7ROxtUPVS+EklfWCj0KIae9bSHn1z59hM
   5lx8JfTUmzcSkys4dokYRBY6fGTZQ+Oqs5yRwh2amiU+/S5O84xiHWbQd41BQGr7yh900W+xxecy
   eZfv2H2KaXNq5XUFPwlRKeR/Aw3EJqJcBv88MQhZxhlHEE/FfglAEBFB0k8l1Bi+Zq1RyLtAWqLI
   xHFtmgMmrfzdbzol+f1oRourPwkfzYuviCHNYckLz310EIMcGvzBi5HtzGSAbh058F+AGzJx8+GC
   MK0+cZqTU3qJkW2ehvUs0C0KW7K4QwQqNDlXJA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00LYAVZ06R40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669041300;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=181ZHweS4wHRSdLySvK3fpfT7WMJLPwn/rNHBgW8rAk=;
 b=aiK/KsY2wKTWcmefXXOuUYrTCtCiGRvPZfTwygH6p+GIoDYHia4WM5UPy2kwT7bpWgGeQq
 TniJf4bVqe+DMh4EbjqZWjCATAko9fuekkhz1Ye7zfoulNCDUQjgh+v4F+UPgNsj0wxLDo
 wvqCkOC6sNDOsWtpiZgha083BGTwLPY=
To: David Howells <dhowells@redhat.com>
Date: Mon, 21 Nov 2022 09:34:43 -0500
Message-id: <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
In-reply-to: <382872.1669039019@warthog.procyon.org.uk>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
MIME-version: 1.0
X-Source-IP: 170.10.133.124
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
X-MC-Unique: cKpJPG72PVO5ijDDtOCqbA-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Proofpoint-ORIG-GUID: IXrXcDN7Kn4-bNRrV1cKxTuxScT6RYo0
X-Proofpoint-GUID: IXrXcDN7Kn4-bNRrV1cKxTuxScT6RYo0
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAFd/htfq0cqkEyvbEoEUFBYcxIucxInEYeBS++3RtgStN4vB3wo6b//bVRB5Nrk
 jIRS+EtjMZxO+4RHUYaJhZsjcu4LQAEgr5OA3JC5zr74m04pNi7WpJcutWb+juQc
 ku7+y4/6a1P+H1Y4RbJQCyDBDxUQN8u8ObJ/RqlaioP8Kby2MYrSftufcCUF9ims
 PfF/rlqo0ewfPcTtsoXSB4JGZE2NINchvXYhEjBxkGxlHvQrNgXcHFyNonfaoQRW
 HQA8yZtNYY5+fQZNvJ3vm3QT/ZHuwLdQvDpQBIlbxlQxUDRVNpEv8CWeT/UbsE+x
 dez1pZiJIaR9HLLm6OsNTalcrSOBVasFjtCyxLAFbuFCISILEXm+6jFZvmMd86Sm
 BXkKJO0toJvbDGWFbidkBUDoDLSb1awEun+Gf0au/MagOBb9A3+SRFPAzqyk412L
 iJOA1YWq76z4a3N3w8EUmVbf5H5rgv5OTSLFUsLD3A3gIaaWfsowPvW0yAZvDW5F
 5OaoxUX4M+mjK5s/leEurDgs6SM250U8C3FjYEQ3VtmE

On 21 Nov 2022, at 8:56, David Howells wrote:

> Benjamin Coddington <bcodding@redhat.com> wrote:
>
>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>> when it is safe to use current->task_frag.
>
> Um, what's task_frag?

Its a per-task page_frag used to coalesce small writes for networking -- see:

5640f7685831 net: use a per task frag allocator

Ben


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
