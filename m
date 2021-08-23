Return-Path: <SRS0=lQMM=NO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B57C4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 16:42:41 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B0896124B
	for <ocfs2-devel@archiver.kernel.org>; Mon, 23 Aug 2021 16:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B0896124B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEYval008816;
	Mon, 23 Aug 2021 16:42:40 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3akw7na2vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Aug 2021 16:42:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NGfTWD151369;
	Mon, 23 Aug 2021 16:42:39 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpkvj1hj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 23 Aug 2021 16:42:38 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mICvr-0007fk-Tp; Mon, 23 Aug 2021 09:36:19 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <rpeterso@redhat.com>) id 1mICvp-0007fF-RG
	for ocfs2-devel@oss.oracle.com; Mon, 23 Aug 2021 09:36:18 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17NGVOPo116874
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 16:36:17 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8t14dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 16:36:17 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17NBqQRR016241
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 16:36:16 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3akr9ec5vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 16:36:15 +0000
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
	[209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-121-w3VtuRsbNceK5XnbRjLrrw-1; Mon, 23 Aug 2021 12:36:13 -0400
X-MC-Unique: w3VtuRsbNceK5XnbRjLrrw-1
Received: by mail-io1-f69.google.com with SMTP id
	b202-20020a6bb2d3000000b005b7fb465c4aso10446035iof.17
	for <ocfs2-devel@oss.oracle.com>; Mon, 23 Aug 2021 09:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=r5NSirjKs41jSzfQIVFQxmbd80RcTLP1GCVAVajYdQQ=;
	b=T1veKVWKZnxNpPy4PQ3JmrbjXRZ0X3nXYm7wGN2EBd7r8cXzJmL10pscw3hNu0ziu/
	QfpIzDQ71TGvQaZS+3j6wl6tvG5N8RCNjebC1ni54VrIleV9y+C+y65m5wgoWvXjW6pq
	va4fBhF/C91Gl6bEv0toK7Wb3SGIkdKFVo67/Iss5+y0qx9PivALeuj4MZcPvAkEMRLK
	ODL0VTG8mAaJwm0xdGt4kBYQAA3Jac4gq+QzjnfxCmEhKUwi0LNDQ/0vuLMNdMXPSbYt
	tN2D146XIE8NlHKvUI7INbCKnLo6yXxzYb84et5EZjpqm2Fdf+ccm/idYjJcaGHlDH7y
	hfXA==
X-Gm-Message-State: AOAM533PzV4S6K7tcIGIuy6jlMB4j+L7xUt/JpzhxAyOdd+LLRdMXUqD
	tKPLYLw622CCoxgx9tSt+85Vou7I1xh6IPn7xhaGyh7slKw/vr8wgcK6tBt8ts96dhrbvlB90LI
	SZECpnDvZ65y3noloWkgxNkQtcdgSc75/wauZEvBngfeycDAnnWPK3vvBYd4vpVt3Ic3x6KEFxA
	==
X-Received: by 2002:a05:6602:341:: with SMTP id
	w1mr27131486iou.40.1629736572427; 
	Mon, 23 Aug 2021 09:36:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjIF/CeJPjrbLMOMSAillsWB3d7qGWogCMb9ncBdT7T+8wQDkqYOC3c+S2kxOZsak+rrto5w==
X-Received: by 2002:a05:6602:341:: with SMTP id
	w1mr27131468iou.40.1629736572248; 
	Mon, 23 Aug 2021 09:36:12 -0700 (PDT)
Received: from [172.16.0.19] (209-212-39-192.brainerd.net. [209.212.39.192])
	by smtp.gmail.com with ESMTPSA id z6sm7453260ilp.9.2021.08.23.09.36.10
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 23 Aug 2021 09:36:11 -0700 (PDT)
To: Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
	<CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
	<8e2ab23b93c96248b7c253dc3ea2007f5244adee.camel@redhat.com>
	<CAHc6FU5uHJSXD+CQk3W9BfZmnBCd+fqHt4Bd+=uVH18rnYCPLg@mail.gmail.com>
	<YSPHR7EL/ujG0Of7@casper.infradead.org>
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <43cf01f7-1fb5-26a9-bcda-5c9748c6f32e@redhat.com>
Date: Mon, 23 Aug 2021 11:36:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YSPHR7EL/ujG0Of7@casper.infradead.org>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=rpeterso@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108230113
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH v6 10/19] gfs2: Introduce
 flag for glock holder auto-demotion
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230114
X-Proofpoint-GUID: WWvtjZY3-7EgWXewjOBhPrHlcO0gDnv6
X-Proofpoint-ORIG-GUID: WWvtjZY3-7EgWXewjOBhPrHlcO0gDnv6

On 8/23/21 11:05 AM, Matthew Wilcox wrote:
> On Mon, Aug 23, 2021 at 05:18:12PM +0200, Andreas Gruenbacher wrote:
>> On Mon, Aug 23, 2021 at 10:14 AM Steven Whitehouse <swhiteho@redhat.com> wrote:
>>> If the goal here is just to allow the glock to be held for a longer
>>> period of time, but with occasional interruptions to prevent
>>> starvation, then we have a potential model for this. There is
>>> cond_resched_lock() which does this for spin locks.
>>
>> This isn't an appropriate model for what I'm trying to achieve here.
>> In the cond_resched case, we know at the time of the cond_resched call
>> whether or not we want to schedule. If we do, we want to drop the spin
>> lock, schedule, and then re-acquire the spin lock. In the case we're
>> looking at here, we want to fault in user pages. There is no way of
>> knowing beforehand if the glock we're currently holding will have to
>> be dropped to achieve that. In fact, it will almost never have to be
>> dropped. But if it does, we need to drop it straight away to allow the
>> conflicting locking request to succeed.
> 
> It occurs to me that this is similar to the wound/wait mutexes
> (include/linux/ww_mutex.h & Documentation/locking/ww-mutex-design.rst).
> You want to mark the glock as woundable before faulting, and then discover
> if it was wounded after faulting.  Maybe sharing this terminology will
> aid in understanding?
> 
Hmm. Woundable. I like it.
Andreas and I argued about the terminology but we never found a 
middle-ground. Perhaps this is it. Thanks, Matthew.

Regards,

Bob Peterson


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
