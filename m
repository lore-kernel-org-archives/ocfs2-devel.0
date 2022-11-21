Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB33C636F9
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Vfbe4pByEwy7uWXS2QBEFI/s67I4o6HhMcMoJDVtIxk=;
 b=ZGq6j2fRDqnsOL2+PALqrTLzbz0w+LBNPdw0W567q9nPuhgl2fMudBlgOKeqdUwj0spI/6ALncu0
   YyJr7MB4lbWxKcOOqpChXFyjcj92V7Cp+e7PJ1IYKdXbnY5JV6vXRIHInPnGb+iPcLtKvwRTI7cl
   Pnh9pGk5LJzHTARFnTPvtCtPsD5Ee2OPYc7CkkHIX34ldDzc3hRGCzz4iFT2TkeHx1Bfa6UB8kFJ
   Sx3PaJ+n3jbDyApgORAxyQB14OLBKfWABfChHPZCc1wob+tHUOkOyXK4kD6019UCcUslSFpNokGz
   yMqa1NgrO8rzVRbycgoOU+zS41QPxJWRvG8l+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Vfbe4pByEwy7uWXS2QBEFI/s67I4o6HhMcMoJDVtIxk=;
 b=U6I6dk+Sjez9zqvDM19+V6aLiuBoNOCd8YwyzIYtf2VETHUUUwxUAQtgktZ/Th6MQ0Dtf40Xffyg
   +jiDlQIiS01/aPBAAtZNe/qsDP3XFaXsSDp+it7dYdUhjZr9h2o3VuZJRRHyuky9arDGhmFwPc6S
   nfiRTFE+t85x4GXuBVAVtHR1t7SDyUjhQfHQv5F7Nr9eYuGQmI0/oDR/nYBK3Yhs0unVyVPG4VqR
   msSJJuXab1+Xvb2vw9I+P0m/5uFKSOYogIqV03qqCnbccbhiAIOOvwfQMFfZb960Bul1kY7JXzKw
   ofVKXPjaxDgdJDhUZ/chbHvtgnaLL73gjjfV1Q==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00KAJVZ00Y40@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
 s=google; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=ImVe+g+b+10JJjRyFbVg3VQDLgN59Ue/Abv7vaFmseQ=;
 b=OHO4FjaPJmimqdrzS/OkstIvhocxCz1emkoHfOdBnFW624ABdZXIGpUr2qg1Kuoid7
 jQ3zRS/xznKzGtwvpkBw8YcBHanbAjUGKtSMJ92a5WUJdkI77H4tBot4cVhu32vyccdd
 iMTMhCXmKhazzg9UmrMMNr5aOJxLl31QLMnEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ImVe+g+b+10JJjRyFbVg3VQDLgN59Ue/Abv7vaFmseQ=;
 b=ME2307NuCumCfIF3wmsGN4pLXlHApj9wIZ/xY7fUL52rWwM2ZLSbPW0kbQMQ38P0sG
 VuAr+qtzKhRIpJD7SF4UrmgJq7gKOgU3ASKqES7qTErG0Z7Irr87FB05Mwz6VFC0DYKK
 ruiolEG7LFiGWHvYT6dzXuKVtHsP3Rmh9QsZ52kWtlWP72LLxEfBRPqPNeHloed+l22k
 H/+RKYRRXj5IAduOc28Sf6WvJH82Ihos3QdJ0qV8+eBMB3C7uhk1FCfXQ1j8BjX227Pn
 eW0y/WNZff6NY9IZh+j3R0CicJTExSSFmNCygdBDAsyTck6Vp+DZdal568KrWLxM0dED 1URw==
X-Gm-Message-State: ANoB5pnbsbnGKoblyhvjHak8O3ICRkItWtnM5FAOFHXfVBG0f+SjUy+Q
 Co9+qUnIR85Las1VyJH9O4MYRQ==
X-Received: by 2002:a5d:9c0d:0:b0:6de:e346:27d4 with SMTP id
 13-20020a5d9c0d000000b006dee34627d4mr639526ioe.138.1669067012402; Mon,
 21 Nov 2022 13:43:32 -0800 (PST)
Message-id: <26d98c8f-372b-b9c8-c29f-096cddaff149@linuxfoundation.org>
Date: Mon, 21 Nov 2022 14:43:29 -0700
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-language: en-US
To: Benjamin Coddington <bcodding@redhat.com>,
 David Howells <dhowells@redhat.com>
References:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
 <cover.1669036433.git.bcodding@redhat.com>
 <382872.1669039019@warthog.procyon.org.uk>
 <51B5418D-34FB-4E87-B87A-6C3FCDF8B21C@redhat.com>
 <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
In-reply-to: <4585e331-03ad-959f-e715-29af15f63712@linuxfoundation.org>
X-Source-IP: 209.85.166.54
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=90
 mlxlogscore=702 priorityscore=255 suspectscore=0 phishscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210162
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
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
 AA0mqf7f7poc1w7ewSMxS1++ciq574fA83Q7zTNUSYFoHm3cWPyzQwbrRSPhTjg/tqVe+6wU++ijsA==
X-ServerName: mail-io1-f54.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: qw8mfuLKQQ5yASPNVCUdUGD5JikoOH6U
X-Proofpoint-ORIG-GUID: qw8mfuLKQQ5yASPNVCUdUGD5JikoOH6U
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAGlbkWNsQjdtFOiJr2BqDePL3v5ts+Q18eaP+/Otni+3kwZ+0Uh+1OpHv1nHTZt
 +J76Hf+V4f5b2iUqyqU8iqedR1TeMfHnsKbxSjvZpPLdDkkJeoPu1wYxHXBA+Yv4
 hELATdXLvXP8/DQReO3BoTP/83GKoadbF5bDp1pPH/Cl9fx+YvhaW6OFH/Qp6ChC
 SUjh/tIgPaXywq2Cmz+c9XNM+ZS9zNuwkJtq2N2eXC98b0t51heGNhO1JOK9Q4hP
 lRe0J0AAxPBFzAOY8zU7ZT6wqZBfTXupOJKlmQnHH0vVVtr1/Qx8Zmf1QJmlrY4r
 2hl2SVAP7LX5Ju+jB1nXpdrUMCapNV/hrJYgRhonn6p5v91w6ujYylmbj2aq7Z8Q
 zEXGqJxydTUFDE+icRGZcjp9sC/ovcJw04k3wRcwcuCSu6dO5ivIzxmY94GZs0jY
 Xg6Mrjl457SJOqw7JFKDc0BIHt//SGO2AeL7jpcxlCrWlKnKIsgyUIoUcnMyOjGg
 Rq0ADOWBDXbAgkxzu7KHSu1IbKqpOG2J48GSRTNXznZE

On 11/21/22 14:40, Shuah Khan wrote:
> On 11/21/22 07:34, Benjamin Coddington wrote:
>> On 21 Nov 2022, at 8:56, David Howells wrote:
>>
>>> Benjamin Coddington <bcodding@redhat.com> wrote:
>>>
>>>> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
>>>> GFP_NOIO flag on sk_allocation which the networking system uses to decide
>>>> when it is safe to use current->task_frag.
>>>
>>> Um, what's task_frag?
>>
>> Its a per-task page_frag used to coalesce small writes for networking -- see:
>>
>> 5640f7685831 net: use a per task frag allocator
>>
>> Ben
>>
>>
> 
> I am not seeing this in the mainline. Where can find this commit?
> 

Okay. I see this commit in the mainline. However, I don't see the
sk_use_task_frag in mainline.

thanks,
-- Shuah


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
