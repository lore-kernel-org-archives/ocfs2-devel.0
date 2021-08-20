Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DB8C4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:41:45 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 968C9610CC
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:41:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 968C9610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KDW9x4030029;
	Fri, 20 Aug 2021 13:41:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agykmnygr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 13:41:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KDfCe4051632;
	Fri, 20 Aug 2021 13:41:42 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm1rabu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 13:41:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH4mD-0002SU-2B; Fri, 20 Aug 2021 06:41:41 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <swhiteho@redhat.com>) id 1mH4mB-0002S7-95
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 06:41:39 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KDf2kB075582
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:41:39 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3ae5ndmbpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:41:38 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KDbIfQ025972
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:41:37 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ajc1bs8wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:41:37 +0000
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
	[209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-39-F9WzPrt-M9CGbOhIOKpqhw-1; Fri, 20 Aug 2021 09:41:34 -0400
X-MC-Unique: F9WzPrt-M9CGbOhIOKpqhw-1
Received: by mail-ed1-f72.google.com with SMTP id
	e18-20020a0564020892b02903be9702d63eso4567774edy.17
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 06:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
	:references:organization:user-agent:mime-version
	:content-transfer-encoding;
	bh=4KjTjMbm6Ax2NoBz/SV8LRb7ROzLCYCzwIW7Ojvzm8c=;
	b=au9Z6XjYVEVmesZRmEZiFNOqxyWOCFP40ahJBdCzJzSXEJZyiq1/Y+cOq7xcCE1YvD
	I/O6qQmpg62TZJVEPctkbCjBwYYEX2SQDUjtywkAVazcTCyG7YE8B/+LcDtIEwdJy7NF
	Uzy2OSZIKR+lEgHkSKgRvr3hr5Bjb0AxxJoiR1D/1/oN6cvF/3YXcSq4BkM7rC86Yop4
	td9QtCLOFWM4S+y9eqBInQB0eRp8x4cKzJ3jU2EPaZNx/I5hdmZU9TI3NmUhjsh92ohF
	LDBYWbmVQ7wK8n9ixbVx+yUfO78vT2gr4AUru1XnIqZ8gJmOHG8FmI/lZOIsKvNNZFd5
	7MLA==
X-Gm-Message-State: AOAM533tOzPXHNtF0UYfWDamSZyj/w1iYKah6yimlJi6BblJ8MdnCuEU
	FVS5pmoE2NXaNWXoqi+NBrB2e2tDsmtYdHkiHV2JCbWTurll7PccD1n3PpgOalKRfvdI8stAxXL
	DY4TJtxtv7QurT1Qihth5nw==
X-Received: by 2002:aa7:db8b:: with SMTP id u11mr22178961edt.362.1629466893416;
	Fri, 20 Aug 2021 06:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0hLwN+s7rk8F847DLOmn4dy1Ao93kGJxxgV8+oY8fbxG+6Lejz40d6vR1Ye9lqW0fsphjXg==
X-Received: by 2002:aa7:db8b:: with SMTP id u11mr22178939edt.362.1629466893221;
	Fri, 20 Aug 2021 06:41:33 -0700 (PDT)
Received: from
	0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa
	(0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa.
	[2001:8b0:ffda:0:2059:8730:b2:c370])
	by smtp.gmail.com with ESMTPSA id
	g14sm3636121edr.47.2021.08.20.06.41.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 20 Aug 2021 06:41:32 -0700 (PDT)
Message-ID: <2508f12f0d2a5eedaad0c6b77657f53222b33e3c.camel@redhat.com>
From: Steven Whitehouse <swhiteho@redhat.com>
To: Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher
	<agruenba@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig
	<hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 20 Aug 2021 14:41:32 +0100
In-Reply-To: <cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<cf284633-a9db-9f88-6b60-4377bc33e473@redhat.com>
Organization: Red Hat UK Ltd
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=swhiteho@redhat.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200077
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200077
X-Proofpoint-ORIG-GUID: ldb-bxYf7idGe_qPJ6jx9mmJcRNtI6eC
X-Proofpoint-GUID: ldb-bxYf7idGe_qPJ6jx9mmJcRNtI6eC

Hi,

On Fri, 2021-08-20 at 08:11 -0500, Bob Peterson wrote:
> On 8/20/21 4:35 AM, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Thu, 2021-08-19 at 21:40 +0200, Andreas Gruenbacher wrote:
> > > From: Bob Peterson <rpeterso@redhat.com>
> > > 
> > > This patch introduces a new HIF_MAY_DEMOTE flag and
> > > infrastructure
> > > that
> > > will allow glocks to be demoted automatically on locking
> > > conflicts.
> > > When a locking request comes in that isn't compatible with the
> > > locking
> > > state of a holder and that holder has the HIF_MAY_DEMOTE flag
> > > set,
> > > the
> > > holder will be demoted automatically before the incoming locking
> > > request
> > > is granted.
> > > 
> > I'm not sure I understand what is going on here. When there are
> > locking
> > conflicts we generate call backs and those result in glock
> > demotion.
> > There is no need for a flag to indicate that I think, since it is
> > the
> > default behaviour anyway. Or perhaps the explanation is just a bit
> > confusing...
> 
> I agree that the whole concept and explanation are confusing.
> Andreas 
> and I went through several heated arguments about the symantics, 
> comments, patch descriptions, etc. We played around with many
> different 
> flag name ideas, etc. We did not agree on the best way to describe
> the 
> whole concept. He didn't like my explanation and I didn't like his.
> So 
> yes, it is confusing.
> 
That seems to be a good reason to take a step back and look at this a
bit closer. If we are finding this confusing, then someone else looking
at it at a future date, who may not be steeped in GFS2 knowledge is
likely to find it almost impossible.

So at least the description needs some work here I think, to make it
much clearer what the overall aim is. It would be good to start with a
statement of the problem that it is trying to solve which Andreas has
hinted at in his reply just now,

Steve.



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
