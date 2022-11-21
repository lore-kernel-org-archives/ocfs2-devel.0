Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA82C63704
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7FOllxYDE+UPTdevgQJmPLhw60Ck7cJ2iR62xU09C+k=;
 b=k+UHtmWTKCZrKBymJ/nC+0M88jYP8h6eFoNzon+eA89KvZmaPwZXr5DzC5dyo1QC8Xw8XeEW5QHr
   NMpof/Y1WMpPxJjl/vGxKX3KYr0p7qtO9Co3BMGhj83CWDLZlYsCjhYyUKgexsyRJyI1zzSEOT2e
   tq3foxeF/I4fnXnw9qF4+QtbV8kdy9qJ1uBUv+hStAcL/MzR6Zq6bzMN5V4VeObbEDiMl5dRO0mY
   8ycoKAiO2HlC7+Ky9prG+nQt2+hOBYL67YeNvZAapjH4ZOdg2C408Cex561ox7Kx4yB0W8I23RUk
   csk3wTjaex9kXkteNhOBhDX9zqeCZsayGx4uDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7FOllxYDE+UPTdevgQJmPLhw60Ck7cJ2iR62xU09C+k=;
 b=psf4RzHUE8oRvEKpLMvldJiBkoph+8Iv1ZF/XxUH/2SNZkz9OLb4xFnLxT0PDhJLOR0VtRflozUt
   vufBdAO0j/XqFpP+voGv2ZAdG9UQHzelJmyPdjPl+D6FDfRtej84/2u0bnOavW5l6EhK10QOZ7qI
   7CfH40E8lYLq38tvCYxOFb/uInDygtGhfc48HgyEv7VM8u9wg3NED40ZDWJpyL3gOe1Fhc3JsNhb
   FHosG8mJ0QR0C3xbb08tko2mO+cTuCK4kwcEcSUQLz/ypEwvAu0+XU8X9aLA5d68t+/JY6X0QDi+
   QheVEWW9wcR2FrUkXom1NjT5RuuS+hb5y0qdeA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00LZ7VZ06R40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669068134;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YMKd/Bs7qgKxK3d2yDLuSvYLpTNEB6rexVneY8E6It8=;
 b=J9UbiYc/SxnBN1Q4GYUNXqPoHIQoZz3s0CMMTfMeLrQpY46MEy+rvt5XkKYejLJGUQbubI
 2/o0ezqglDL8pqHTdaQeIclsMB4sDG2+yOdwknNdkSz62YJ7V52069EInm+mwhICvqtctg
 AYU2WoT5C99V18BEVJOlGZhogdJIjOQ=
To: Shuah Khan <skhan@linuxfoundation.org>
Date: Mon, 21 Nov 2022 17:01:42 -0500
Message-id: <A860595D-5BAB-461B-B449-8975C0424311@redhat.com>
In-reply-to: <26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
 <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
 <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
 <26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
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
X-MC-Unique: BCJecrIfN9ORT1g62yEryw-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Proofpoint-GUID: 6imSCQ7u-a_AmDxqUGMvNX61_ZxZLo-S
X-Proofpoint-ORIG-GUID: 6imSCQ7u-a_AmDxqUGMvNX61_ZxZLo-S
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAFd/htfq0cqkEyvbEoEUFBYcxIucxInEYeBS++3RtgStN4vB3wo6b//bVRB5Nrk
 jIRS+EtjMZxO+4RHUYachZsjcu4LQAEgr5NrelVNsL9jEHjNhhqUBG/jXHAYcqJw
 869bX+r7UJRSB+sTUJ+CAt/p7qeSluTJtDa3s/lIu0LlUlPqOD+u/g6Anl0hh4AR
 kp0yGCrV+kEAfiqnWDwi25+h79shdF4lQ73BoChcM5cv10y/tsqEALYXHPY2hy5E
 VRpT8Jr4o4biVjdzRpGMz22B3GVXpGdIDSPF1S5ttC5FM78QU3+ug0Xzyxh5Soa9
 eUtAo7/JVlX8JSLr3eyLkmMlnstgxXX7hboB4K0Xd9MuW7OHdIHe1W4VHbijUejl
 /uTHsSiF80iWPHdr+fWyW58RuEobEsoU90MwqMNLGymwfsqy0JNPhUsYEExKpSBB
 0UECJu3m2ZQlo59wQJbiP3YyO9w1heGfnjTsYJGlWQPTIfuvMigbLZj9YEz+QezK
 2CZ5soN+WuqR2j4+6p4UDJlbvOfjup26zuodnL/sUD3j

On 21 Nov 2022, at 16:43, Shuah Khan wrote:

> On 11/21/22 14:40, Shuah Khan wrote:
>> On 11/21/22 07:34, Benjamin Coddington wrote:
>>> On 21 Nov 2022, at 8:56, David Howells wrote:
>>>
>>>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>>>
>>>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>>>> when it is safe to use current->task_frag.
>>>>
>>>> Um, what's task_frag?
>>>
>>> Its a per-task page_frag used to coalesce small writes for networking -- see:
>>>
>>> 5640f7685831 net: use a per task frag allocator
>>>
>>> Ben
>>>
>>>
>>
>> I am not seeing this in the mainline. Where can find this commit?
>>
>
> Okay. I see this commit in the mainline. However, I don't see the
> sk_use_task_frag in mainline.

sk_use_task_frag is in patch 1/3 in this posting.

https://lore.kernel.org/netdev/26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org/T/#m3271959c4cf8dcff1c0c6ba023b2b3821d9e7e99

Ben


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
