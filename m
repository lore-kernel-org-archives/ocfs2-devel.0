Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17EB3C6370D
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+M2sMgESXy1sfKYxqiVKCk+vZeSxuNKiLyyFRW/Hv/A=;
 b=GsZl5ux8fY7YjQPi/vwC8apNilX//4h3c7/TBqYcu3bgBTRqmxt4zRYQro6aRbwCMVG04PnEM2v7
   9EQwx80wSrBPBGn4jBfY0b/IMQDYb065TifnfS6CQwHuLrgZ4VzGj9T6DxahHQlt9036Z0GELNiD
   gFjZC0wGA3vzzIdtTvajeOeknjbECvpCJdBKSezGbSk0fB8tzIja6y+cImnk1ZU+WQlFTDPJ8fEx
   E2OFP09lxnQUefDNJNxQcdBz7LIZKBrA79I1EPHhXw0pkxhTG7IMhKzK8oWyEr5ARTlncLs/2/uX
   hFF7DdfZLS8w01/kfrY8SB70kPZfpPo6Ss53JA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+M2sMgESXy1sfKYxqiVKCk+vZeSxuNKiLyyFRW/Hv/A=;
 b=j1bhBI2QdlKKKmSVYidkRsKQtw6p+ne2b/i3qGql9++rFqN4ufSQKj/njYvfhknXTz6bIG9WbQMo
   4AvLPS7Nt8gnJHmr3cFqjLblMtSP+LfS6Iitj3n7tYHRmz/Ts0pmvngNJG80TBIScL5bvVa/WZhv
   1h0QCep8RKl6d9/4gC4WVxORrBGbRhk237hiEprNc5clHShA3hLq1IYfWNw6nCt9bq4RKEQOg/rg
   QLLJn1lq46knErtWO2qGqiFrGti8qcAltg2IpNXNzUyoeZnFlyd8YjdyoLVreemq6reg2Oj0oleH
   etDhEl7zMnOZjQX2G88uSOgYdxCZK9kJDuejmA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00APSVZ1EY00@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669127026;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=geVsTAOXAFmfC1p8NU5oUZW9hh2dqn+X7qlWo6CR96Y=;
 b=QD9HNhfwpjcZAyrcVDtGcyvcJC1Jt05Njs2nDDlxTHOvhswfgrgNAdHBiLEZ9+1+paIjfS
 xvMFD3qCbJf6A6xMlIn0VpgRM8BByfNqUyTTD/aKI8613kGDOh1+aFjPHhlm3ubdqQY76a
 4fjNNftK21PKnaEPXhuRK9+8oDaXYTo=
To: Shuah Khan <skhan@linuxfoundation.org>
Date: Tue, 22 Nov 2022 09:23:29 -0500
Message-id: <C3E8B434-BAEE-42A8-85AF-3B676C65B2A6@redhat.com>
In-reply-to: <96114bec-1df7-0dcb-ec99-4f907587658d@linuxfoundation.org>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
 <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
 <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
 <26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org>
 <A860595D-5BAB-461B-B449-8975C0424311@redhat.com>
 <96114bec-1df7-0dcb-ec99-4f907587658d@linuxfoundation.org>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
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
X-MC-Unique: clNrV_glOTiRpOT7AptSQA-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Proofpoint-GUID: hT2qouiI_x8IneoPPoADd4mHzOvMzMMc
X-Proofpoint-ORIG-GUID: hT2qouiI_x8IneoPPoADd4mHzOvMzMMc
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAH2+oXap0+0ja48fxG522j5c8oIUnqxQBxcO3n1xjDBdfvakE/wGHkmgf8uN12I
 LnmZ1dySt9MoNH1Zpk385y7VFCmJHoeS7FwZjRaX3D+4iGod1BCxQDzyK3nhtogI
 +ChPmGwPgnMV2KgGBr9O2p7EcrrW8ZmwpZ+6XVxtZnTEqe/bbLXCH/XEKpuYVPQy
 G1gzDE4TvwoMlpT+q3vzAdvyiSVy/rkwZ3qMjQcDtSRQBHQ3Xhnq99r4qHhaSXZk
 M2G7IpNHBN2LPZVJPOKy96I49ID0rUuaLxH5KRBcBL5Mo2Cf+T8eLhVgSQ7TBuCr
 3x9uFtjHZXmhyHJO3Jc0eVF5M128Sul7Ot2wK8oQJDphY2ZGSV0NfWSWlIi8x1UV
 avrR9WIyd9tkK68pS5h6+O2qPocE35yd1goq5NbpkdgokOo7Q1fclTrM8Tox7w4m
 yoqJnCYRrMusBQ5BL3S2HJAbg9LIM2W2mJO+MU0gVcbddKaq+uI3B1/0BgwZNfv1
 e/ctJB3owZ1nRXbmGpdwf854VQGfiwrIEoJM9h9q/NNb

On 21 Nov 2022, at 17:32, Shuah Khan wrote:

> On 11/21/22 15:01, Benjamin Coddington wrote:
>> On 21 Nov 2022, at 16:43, Shuah Khan wrote:
>>
>>> On 11/21/22 14:40, Shuah Khan wrote:
>>>> On 11/21/22 07:34, Benjamin Coddington wrote:
>>>>> On 21 Nov 2022, at 8:56, David Howells wrote:
>>>>>
>>>>>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>>>>>
>>>>>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>>>>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>>>>>> when it is safe to use current->task_frag.
>>>>>>
>>>>>> Um, what's task_frag?
>>>>>
>>>>> Its a per-task page_frag used to coalesce small writes for networking -- see:
>>>>>
>>>>> 5640f7685831 net: use a per task frag allocator
>>>>>
>>>>> Ben
>>>>>
>>>>>
>>>>
>>>> I am not seeing this in the mainline. Where can find this commit?
>>>>
>>>
>>> Okay. I see this commit in the mainline. However, I don't see the
>>> sk_use_task_frag in mainline.
>>
>> sk_use_task_frag is in patch 1/3 in this posting.
>>
>> https://lore.kernel.org/netdev/26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org/T/#m3271959c4cf8dcff1c0c6ba023b2b3821d9e7e99
>>
>
> Aha. I don't have 1/3 in my Inbox - I think it would make
> sense to cc people on the first patch so we can understand
> the premise for the change.

Yeah, I can do that if it goes to another version, I was just trying to be
considerate of all the noise this sort of posting generates.

Ben


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
