Return-Path: <SRS0=dlQ5=NL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BFEC4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:48:14 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2441160FE6
	for <ocfs2-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2441160FE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KDl3tr022950;
	Fri, 20 Aug 2021 13:48:13 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ahsxd2bvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 13:48:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KDlC5S068081;
	Fri, 20 Aug 2021 13:48:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm1rjkq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 20 Aug 2021 13:48:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mH4sO-0002b0-7v; Fri, 20 Aug 2021 06:48:04 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <swhiteho@redhat.com>) id 1mH4sL-0002ai-HZ
	for ocfs2-devel@oss.oracle.com; Fri, 20 Aug 2021 06:48:01 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17KDlHWO111761
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:48:00 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ae2y6n89j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:48:00 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17KDlxZH030092
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:47:59 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aj8bc3uyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 13:47:58 +0000
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
	[209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-382-ALm5lGfXOzmB7kQvv36sqw-1; Fri, 20 Aug 2021 09:47:56 -0400
X-MC-Unique: ALm5lGfXOzmB7kQvv36sqw-1
Received: by mail-ed1-f72.google.com with SMTP id
	p2-20020a50c9420000b02903a12bbba1ebso4561532edh.6
	for <ocfs2-devel@oss.oracle.com>; Fri, 20 Aug 2021 06:47:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
	:references:organization:user-agent:mime-version
	:content-transfer-encoding;
	bh=S4VaO/ZlpDnEtWAJ02e00kwDAMMR+6kRDVmQuNZWgk0=;
	b=QRI5B1sjtwdSxTizhVIkPFFMxW8q/+sP/YOsZPClEyTxX1QMOf6dd1wV3hqfGLIasX
	9DHIQ/pDCOWGEL9bp7BCizTK9PaJ2A+pEDdJnb76ksw16RgXGzArsrh+1NJaiokVs8d+
	BhYDmhrJFitFXU5C18bn3COtbXM00tRfGirBRhcyNJMBnsGgo/N6Jf7H7J8d90hFmwly
	SVg6XbBgE1050cLMQGUbAzPx98GfSuRNf4Jlt5j3E95oCb7TCXC7K1ZDYhXVVNPAnGYS
	DJuXD+p3b15XUkkbnuXZ2l41yNugVdP++mAHhNMSZtGEyPoPhKBI7RHCWjmy/ApE3XQz
	UP5g==
X-Gm-Message-State: AOAM532Y4vzcLqpGnd2tAxiSmNV7G4za4XlI80Mvori4nQHWz3+7GLNk
	6s6CR7RkDNjeF2HtgULItA0/xsJL04oA/EQzfY0tYz7p+iv+Jk3WnratwmxWLouLHAhIP3d6Mb9
	He6yJwf9v7cKpIV4w8rYUGQ==
X-Received: by 2002:a17:906:c52:: with SMTP id
	t18mr17733333ejf.148.1629467275432; 
	Fri, 20 Aug 2021 06:47:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxGgzFzFSgxvMjImNOJovDn+MR8vHdHX44QmGlTVPfBl8l/23tH/xJ53AhweH4OH2mV6s+mw==
X-Received: by 2002:a17:906:c52:: with SMTP id
	t18mr17733309ejf.148.1629467275222; 
	Fri, 20 Aug 2021 06:47:55 -0700 (PDT)
Received: from
	0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa
	(0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa.
	[2001:8b0:ffda:0:2059:8730:b2:c370])
	by smtp.gmail.com with ESMTPSA id
	e22sm3641397edu.35.2021.08.20.06.47.54
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 20 Aug 2021 06:47:54 -0700 (PDT)
Message-ID: <d5fbfeff64cee4a2045e4e53abbd205618888044.camel@redhat.com>
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 20 Aug 2021 14:47:54 +0100
In-Reply-To: <CAHc6FU7jz9z9FEu3gY0S2A2Rv6cQJzp7p_5NOnU3b8Zpz+QsVg@mail.gmail.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
	<20210819194102.1491495-11-agruenba@redhat.com>
	<5e8a20a8d45043e88013c6004636eae5dadc9be3.camel@redhat.com>
	<CAHc6FU7jz9z9FEu3gY0S2A2Rv6cQJzp7p_5NOnU3b8Zpz+QsVg@mail.gmail.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108200078
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
 definitions=main-2108200078
X-Proofpoint-GUID: Vl5ngLreXVqenvUbg_3d8Nx17txXRMo2
X-Proofpoint-ORIG-GUID: Vl5ngLreXVqenvUbg_3d8Nx17txXRMo2

Hi,

On Fri, 2021-08-20 at 15:17 +0200, Andreas Gruenbacher wrote:
> On Fri, Aug 20, 2021 at 11:35 AM Steven Whitehouse <
> swhiteho@redhat.com> wrote:
> > On Thu, 2021-08-19 at 21:40 +0200, Andreas Gruenbacher wrote:
> > > From: Bob Peterson <rpeterso@redhat.com>
> > > 
> > > This patch introduces a new HIF_MAY_DEMOTE flag and
> > > infrastructure
> > > that will allow glocks to be demoted automatically on locking
> > > conflicts.
> > > When a locking request comes in that isn't compatible with the
> > > locking
> > > state of a holder and that holder has the HIF_MAY_DEMOTE flag
> > > set, the
> > > holder will be demoted automatically before the incoming locking
> > > request
> > > is granted.
> > 
> > I'm not sure I understand what is going on here. When there are
> > locking
> > conflicts we generate call backs and those result in glock
> > demotion.
> > There is no need for a flag to indicate that I think, since it is
> > the
> > default behaviour anyway. Or perhaps the explanation is just a bit
> > confusing...
> 
> When a glock has active holders (with the HIF_HOLDER flag set), the
> glock won't be demoted to a state incompatible with any of those
> holders.
> 
Ok, that is a much clearer explanation of what the patch does. Active
holders have always prevented demotions previously.

> > > Processes that allow a glock holder to be taken away indicate
> > > this by
> > > calling gfs2_holder_allow_demote().  When they need the glock
> > > again,
> > > they call gfs2_holder_disallow_demote() and then they check if
> > > the
> > > holder is still queued: if it is, they're still holding the
> > > glock; if
> > > it isn't, they need to re-acquire the glock.
> > > 
> > > This allows processes to hang on to locks that could become part
> > > of a
> > > cyclic locking dependency.  The locks will be given up when a
> > > (rare)
> > > conflicting locking request occurs, and don't need to be given up
> > > prematurely.
> > 
> > This seems backwards to me. We already have the glock layer cache
> > the
> > locks until they are required by another node. We also have the min
> > hold time to make sure that we don't bounce locks too much. So what
> > is
> > the problem that you are trying to solve here I wonder?
> 
> This solves the problem of faulting in pages during read and write
> operations: on the one hand, we want to hold the inode glock across
> those operations. On the other hand, those operations may fault in
> pages, which may require taking the same or other inode glocks,
> directly or indirectly, which can deadlock.
> 
> So before we fault in pages, we indicate with
> gfs2_holder_allow_demote(gh) that we can cope if the glock is taken
> away from us. After faulting in the pages, we indicate with
> gfs2_holder_disallow_demote(gh) that we now actually need the glock
> again. At that point, we either still have the glock (i.e., the
> holder
> is still queued and it has the HIF_HOLDER flag set), or we don't.
> 
> The different kinds of read and write operations differ in how they
> handle the latter case:
> 
>  * When a buffered read or write loses the inode glock, it returns a
> short result. This
>    prevents torn writes and reading things that have never existed on
> disk in that form.
> 
>  * When a direct read or write loses the inode glock, it re-acquires
> it before resuming
>    the operation. Direct I/O is not expected to return partial
> results
> and doesn't provide
>    any kind of synchronization among processes.
> 
> We could solve this kind of problem in other ways, for example, by
> keeping a glock generation number, dropping the glock before faulting
> in pages, re-acquiring it afterwards, and checking if the generation
> number has changed. This would still be an additional piece of glock
> infrastructure, but more heavyweight than the HIF_MAY_DEMOTE flag
> which uses the existing glock holder infrastructure.

This is working towards the "why" but could probably be summarised a
bit more. We always used to manage to avoid holding fs locks when
copying to/from userspace to avoid these complications. If that is no
longer possible then it would be good to document what the new
expectations are somewhere suitable in Documentation/filesystems/...
just so we make sure it is clear what the new system is, and everyone
will be on the same page,

Steve.




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
