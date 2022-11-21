Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1ABC63705
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hIFdC5jNzdNHMvIETKZDyu+KU+rVTGwML9SM8nl+yEc=;
 b=N/P6CQ7NBLFFPmYk+TWs84Nzn7EEWlHgVcWe9MPsr1nWWHjRa0wsRl91zBndWPPOaGOpLAiISr6A
   b74LZKq1+19YE3L6ebIKKK3lpUaqRrHUZNMBkI5SHbkJvqQo1yyauzuT7uTXHwQHDxz7wn1F5asQ
   2tnWLhpndzGIG/IuwANYX6gLv3LsyTUGpxJebo/dnzc1Hfx4Dk9ZWvPb8qsj/jRRhcu/IMeN0V0E
   UUqXfxWXAnDBqwkGLREkcZultDLKlrVh34hqLNsrHyn0aKIkpGrWLjwg/NoVON2L16v4lvzWH0Hs
   V2BWOn4demTfnF6PvpyGj1f0TZsid0GkhD5KtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hIFdC5jNzdNHMvIETKZDyu+KU+rVTGwML9SM8nl+yEc=;
 b=liNHVplivCKuzC3Pmr1i2nSjhNEq03Ecac4mqmZTpSM/Wd4UPNQWi/8vGiD9s+fNLe9tK5ZAZl+W
   8UojUgyzVyjNKNWJQ3ltsdb+ozMPWOgvUITWkrLAIkso61UhXchMbWHTRQZfoY7yQ1cN6n32RCOo
   YkT3qkNAip2bqvvkG5D9sYnt5lpydbmUFYf5j3bvFq5LXWda5RjyuNOas9wc5Acb016+GDtP6t7c
   A8rGF13XwIf89UlMpF/Wqr0wsMVwh67jK8MgVNSjVOkI3u+kpPAMAxsWSHFxlSsxkdxsixXW6ztT
   iwdIJkIR19pEp3B7Gu1Gmf0Frdn5DeNzgBeaIw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00F6PVZ1BJ40@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
 s=google; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=C14m+5yBrv+u7QhAN78BFentZAFfnah8l0PUC4om7m8=;
 b=Hffgzad5MotJq5EstTpwFVQ55zJ2m4sb3dYfhAhqq6QB33wEMcRLHmm2P2eeaxcyl7
 AuWzz1/l9u/1PZyxMCWxsiA0Q6e5fRCsSvqJb8QkirXxS7f+WkWGHtcgrG5qSrXeSLS7
 dJYa3L0ToHNG/CDOCknNOKSmu/izuTLa+EFwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=C14m+5yBrv+u7QhAN78BFentZAFfnah8l0PUC4om7m8=;
 b=jBpCM4lRsVbj9RKehFPbxwqxMUsy5X3ujaNz8lbsFNgaJU2EHT1T3sfOu0mCwygtEq
 TSS/A6/DqVMXz8Hrimvvjr2IfVngiiJqrSyiZD72svlfF9NHVCXMrFJ36ypecR0AMo64
 YP3F4ohi6EGgeF38k4bGXXBE2Sbvye9dT3I8Qbzwxpbel4iAZZDiswZ9Okr+ZOowAzOD
 VaVBgbikJLMqaOKPSNXhomGMdVqVPzbRiacFjOBcF0wyZnYocgJYrXiOlujTyTMqCwL6
 Hjx8C2ujV/ht67kW8pUtl479PXZRQ1hqOtI125zpdl8SxE42GuzNV9FsotmZ3WKl5Z2f wshg==
X-Gm-Message-State: ANoB5pnZwpiD9Fb8Qka1LiZN1sugQfmuinpXSj9LTw2Y21FolG2vn5yZ
 41nFxnxzoZu1nbv7+WZiVamFAg==
X-Received: by 2002:a02:cba6:0:b0:375:a360:a130 with SMTP id
 v6-20020a02cba6000000b00375a360a130mr9477313jap.307.1669069925449; Mon,
 21 Nov 2022 14:32:05 -0800 (PST)
Message-id: <96114bec-1df7-0dcb-ec99-4f907587658d@linuxfoundation.org>
Date: Mon, 21 Nov 2022 15:32:02 -0700
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-language: en-US
To: Benjamin Coddington <bcodding@redhat.com>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
 <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
 <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
 <26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org>
 <A860595D-5BAB-461B-B449-8975C0424311@redhat.com>
In-reply-to: <A860595D-5BAB-461B-B449-8975C0424311@redhat.com>
X-Source-IP: 209.85.166.50
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=91
 mlxlogscore=613 priorityscore=231 suspectscore=0 phishscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210167
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
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
 =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>,
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
From: Shuah Khan via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Shuah Khan <skhan@linuxfoundation.org>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AA0mqf7LzJaZLZ7BN/ieedWyHJVfNYy1D/3fvJQ9uHDra09xLMDQnM+TgsskrmQ988UMBIXzYDc/Wg==
X-ServerName: mail-io1-f50.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: CZzjyRA4W64GsyTC5LcpgNm3ZuhMVqPi
X-Proofpoint-ORIG-GUID: CZzjyRA4W64GsyTC5LcpgNm3ZuhMVqPi
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAGlbkWNsQjdtFOiJr2BqDePL3v5ts+Q18eaP+/Otni+3kwZ+0Uh+1OpHv1nHTZt
 +J76Hf+V4f5b2iUqyqVIiqedR1TeMfHnsKbAbOIss/1Mxx6f7MTbUJoE+uKN32Tt
 TZmXa/xc45KOXcmB/1i78MmYN6a37fi48hEWRe5BiYgq2fj1yGjyVE2+NovEDQ1t
 rFWl1DKWfp/4JJ5pfMF4CWEVO00OZpQ9cWKT+ETZZ30hwskBpM2ztefTJDAh89I8
 FoS1gQ9e9C5F0cQ1Bs065dt2hF/im4W5+DQb1Pa2mYCRM4Qpw/ROq+wa2uNcvzi0
 71xlzB3UHzeV0/Z0MW44pVnvQyHSZV/+cO1z2StvWnKM5OF0xunMlgrGoK7Ve9QB
 2BKnVm2jpUdAr7uruVJ2Em3h9BSaUdDOJIFAC97MrDIuEB3tWriC9580Z4Q0UrEx
 +S7XxtV1NL+VQEHt5QDhTsUJG3XG3CXKbfoamhRTSJC856uAhTEc5L3eiJpYtIrg
 RszaMMFTR1mLnZGanIjTHiJUzqL+nmCJpreJZm8PsVZ1

On 11/21/22 15:01, Benjamin Coddington wrote:
> On 21 Nov 2022, at 16:43, Shuah Khan wrote:
> 
>> On 11/21/22 14:40, Shuah Khan wrote:
>>> On 11/21/22 07:34, Benjamin Coddington wrote:
>>>> On 21 Nov 2022, at 8:56, David Howells wrote:
>>>>
>>>>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>>>>
>>>>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>>>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>>>>> when it is safe to use current->task_frag.
>>>>>
>>>>> Um, what's task_frag?
>>>>
>>>> Its a per-task page_frag used to coalesce small writes for networking -- see:
>>>>
>>>> 5640f7685831 net: use a per task frag allocator
>>>>
>>>> Ben
>>>>
>>>>
>>>
>>> I am not seeing this in the mainline. Where can find this commit?
>>>
>>
>> Okay. I see this commit in the mainline. However, I don't see the
>> sk_use_task_frag in mainline.
> 
> sk_use_task_frag is in patch 1/3 in this posting.
> 
> https://lore.kernel.org/netdev/26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org/T/#m3271959c4cf8dcff1c0c6ba023b2b3821d9e7e99
> 

Aha. I don't have 1/3 in my Inbox - I think it would make
sense to cc people on the first patch so we can understand
the premise for the change.

thanks,
-- Shuah
  


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
