Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677C3C4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:24:13 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE29461242
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE29461242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KFCvNX006622;
	Fri, 20 Aug 2021 15:24:12 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahsxd2k3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 15:24:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KFBEgM184409;
	Fri, 20 Aug 2021 15:24:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm1wp06-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 15:24:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH6NN-0007bT-Eu; Fri, 20 Aug 2021 08:24:09 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mH6NK-0007b4-MY
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 08:24:06 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KFB4pH007630
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:24:06 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3ae5ndscyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:24:06 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KFDCTL014542
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:24:05 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ajcxv1np8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 15:24:04 +0000
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
	[209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-287-wjDZE_BrMLib615vBSs-YA-1; Fri, 20 Aug 2021 11:23:11 -0400
X-MC-Unique: wjDZE_BrMLib615vBSs-YA-1
Received: by mail-wm1-f72.google.com with SMTP id
	c2-20020a7bc8420000b0290238db573ab7so4937228wml.5
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 08:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=AlytKq7WyOzUT/K3H+q4IM3u5JgzyFxG/3NBnWm69Pg=;
	b=E3NrFtdhzXspskwfsBkuMvlBNLyA6TZSBrTkSzprpBHAfUY5+kyr8i6/TlTmJpqWma
	IZVYK9uWFTedIPVxTbxp6J7imM7NLGCD1rqop1VUBLF2iZCvHWpFxgFzehxBpbkA8Bnr
	9sl63b197+uJa3regx9KyNpl7EEUm8j3uhO/sl9W+xvoG8G6dPxj6tj2TaC/3IwX6Era
	MHhj/2pIiWKKBQQA8K8TxitT+l02nC7o/iS4QPvIsMKzDWMzeFCp4wGAbkaWMEAJA9Xs
	DR4waksoa86WdqoOZp1SKa8F7rJo9cCJRc7m+LeuTRmFbFSUBCFc6Jse+WUUXtOJpSNK
	07fg==
X-Gm-Message-State: AOAM531aMl63PFmJ1JFsZwJcMlxHN/ZVojHZhmUtBr0atioI2wy7yb/Q
	UJ/R3Q6alIPzgQ/zHOl6d42Fz3l3wmaPQRAs5Y8w7umihgYAeZFoZndfczfqIAKFA4nwnNN3Kz+
	4jdkYq9JK+xllrW0RGJp3VlGHAv21FwiO4hi/eQ==
X-Received: by 2002:a7b:c106:: with SMTP id w6mr4615323wmi.152.1629472985921; 
	Fri, 20 Aug 2021 08:23:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUvS40eZJ1ySsWNGqcyFBL2tEQZaB8k3Slyb91HTve5oMdHFCyWX4WR3jQt8qnTrXHAXjGShbj4VZTgbuL91g=
X-Received: by 2002:a7b:c106:: with SMTP id w6mr4615303wmi.152.1629472985719; 
	Fri, 20 Aug 2021 08:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
In-Reply-To: <cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 20 Aug 2021 17:22:54 +0200
Message-ID: <CAHc6FU7EMOEU7C5ryu5pMMx1v+8CTAOMyGdf=wfaw8=TTA_btQ@mail.gmail.com>
To: Bob Peterson <rpeterso@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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
X-Source-IP: 170.10.133.124
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200086
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10082 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200086
X-Proofpoint-GUID: iBa9zc3eW1Za-BcvzkbWNwwX6ib8x8c6
X-Proofpoint-ORIG-GUID: iBa9zc3eW1Za-BcvzkbWNwwX6ib8x8c6

On Fri, Aug 20, 2021 at 3:11 PM Bob Peterson <rpeterso@redhat.com> wrote:
> On 8/20/21 4:35 AM, Steven Whitehouse wrote:
> > Hi,
> >
> > On Thu, 2021-08-19 at 21:40 +0200, Andreas Gruenbacher wrote:
> >> From: Bob Peterson <rpeterso@redhat.com>
> >>
> >> This patch introduces a new HIF_MAY_DEMOTE flag and infrastructure
> >> that
> >> will allow glocks to be demoted automatically on locking conflicts.
> >> When a locking request comes in that isn't compatible with the
> >> locking
> >> state of a holder and that holder has the HIF_MAY_DEMOTE flag set,
> >> the
> >> holder will be demoted automatically before the incoming locking
> >> request
> >> is granted.
> >>
> > I'm not sure I understand what is going on here. When there are locking
> > conflicts we generate call backs and those result in glock demotion.
> > There is no need for a flag to indicate that I think, since it is the
> > default behaviour anyway. Or perhaps the explanation is just a bit
> > confusing...
>
> I agree that the whole concept and explanation are confusing. Andreas
> and I went through several heated arguments about the semantics,
> comments, patch descriptions, etc. We played around with many different
> flag name ideas, etc. We did not agree on the best way to describe the
> whole concept. He didn't like my explanation and I didn't like his. So
> yes, it is confusing.
>
> My preferred terminology was "DOD" or "Dequeue On Demand"

... which is useless because it adds no clarity as to whose demand
we're talking about.

> which makes
> the concept more understandable to me. So basically a process can say
> "I need to hold this glock, but for an unknown and possibly lengthy
> period of time, but please feel free to dequeue it if it's in your way."
> And bear in mind that several processes may do the same, simultaneously.
>
> You can almost think of this as a performance enhancement. This concept
> allows a process to hold a glock for much longer periods of time, at a
> lower priority, for example, when gfs2_file_read_iter needs to hold the
> glock for very long-running iterative reads.

Consider a process that allocates a somewhat large buffer and reads
into it in chunks that are not page aligned. The buffer initially
won't be faulted in, so we fault in the first chunk and write into it.
Then, when reading the second chunk, we find that the first page of
the second chunk is already present. We fill it, set the
HIF_MAY_DEMOTE flag, fault in more pages, and clear the HIF_MAY_DEMOTE
flag. If we then still have the glock (which is very likely), we
resume the read. Otherwise, we return a short result.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
