Return-Path: <SRS0=Lpf2=NX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00D1C432BE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  1 Sep 2021 19:56:55 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91A3060F90
	for <ocfs2-devel@archiver.kernel.org>; Wed,  1 Sep 2021 19:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 91A3060F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 181I3vCf018863;
	Wed, 1 Sep 2021 19:56:55 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3atdvygduh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Sep 2021 19:56:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 181Jnqk8116916;
	Wed, 1 Sep 2021 19:56:53 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3atdyxp9xx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 01 Sep 2021 19:56:53 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mLWIp-00078D-6F; Wed, 01 Sep 2021 12:53:43 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mLWIH-00070P-F7
	for ocfs2-devel@oss.oracle.com; Wed, 01 Sep 2021 12:53:09 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	181JpmZR176263
	for <ocfs2-devel@oss.oracle.com>; Wed, 1 Sep 2021 19:53:09 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3atdyvwmn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 01 Sep 2021 19:53:09 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	181JHbt1030591
	for <ocfs2-devel@oss.oracle.com>; Wed, 1 Sep 2021 19:53:08 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3atdwxshmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 01 Sep 2021 19:53:08 +0000
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
	[209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-395-U1ARPnxeP36uz4BMO8bqyg-1; Wed, 01 Sep 2021 15:53:04 -0400
X-MC-Unique: U1ARPnxeP36uz4BMO8bqyg-1
Received: by mail-wr1-f70.google.com with SMTP id
	p10-20020adfce0a000000b001572d05c970so241909wrn.21
	for <ocfs2-devel@oss.oracle.com>; Wed, 01 Sep 2021 12:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=bFy1F+QsYxR5COx5bC/TDu7Bi/by603yH1cn5pidm4Q=;
	b=sfTiOEGijm2vFcGBhktQlezcQ7GNqDN6PVv7i7f/EKJZnvxe/nbjbewvvPZ3o/e1eg
	R++pPryJnLbWXWpzzVvf1FVKXx3qtjTKmSHxXL+r8nKxKRpnjb5O8cT1BDInzTfHpR9v
	U5/K6PddxfxBhC+bofvHw66IU8QRX/cDnfXEJDa97CTYiDRSZNCnmesdyuTLO/WLRqHm
	S2OiEnYjLoa/y74QwD0s6jg0IUIR1z2ygKoJh1l0b8+qlDl76tvMBhAHYRYPLXBuzdgE
	0weZXknw46ObCatM0ZcnJ9QEqv0Y6XcNTvMRWlRptQOpwPop4R9EBC1LIkIKtf//RGiB
	OEBw==
X-Gm-Message-State: AOAM5337r/f3qZuHjjyJfTc6CLcEvJuhL5nKAzKRsPPY1ei376Roh9im
	HLdy+PWHCOm2r+90Dx6+lQkstW+L20ZhX3DURkw4u0E3Coo6TTke7KqkKrqkvWKn7N42nC8eU4Z
	ZpIucA6e4Tk2wFA6AU/gdNArn6IXPobKW2Q+yog==
X-Received: by 2002:a5d:674b:: with SMTP id l11mr1134425wrw.357.1630525983086; 
	Wed, 01 Sep 2021 12:53:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy13a9+qZa6g03QLR52J8E62dIEzq7mnQQkvBXnCkrMx+s+g3F4vOoKLHB3KfUO0ib83MII2IoHGfd93bk24N8=
X-Received: by 2002:a5d:674b:: with SMTP id l11mr1134407wrw.357.1630525982924; 
	Wed, 01 Sep 2021 12:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
In-Reply-To: <CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 1 Sep 2021 21:52:51 +0200
Message-ID: <CAHc6FU7K0Ho=nH6fCK+Amc7zEg2G31v+gE3920ric3NE4MfH=A@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 00/19] gfs2: Fix mmap + page fault
	deadlocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109010115
X-Proofpoint-GUID: 1NUDbc7X8mLZIvjjUSWQ7PxR0oecxLOu
X-Proofpoint-ORIG-GUID: 1NUDbc7X8mLZIvjjUSWQ7PxR0oecxLOu

On Fri, Aug 27, 2021 at 7:17 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Aug 27, 2021 at 9:49 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> >
> > here's another update on top of v5.14-rc7.  Changes:
> >
> >  * Some of the patch descriptions have been improved.
> >
> >  * Patch "gfs2: Eliminate ip->i_gh" has been moved further to the front.
> >
> > At this point, I'm not aware of anything that still needs fixing,
>
> From a quick scan, I didn't see anything that raised my hackles.

So there's a minor merge conflict between Christoph's iomap_iter
conversion and this patch queue now, and I should probably clarify the
description of "iomap: Add done_before argument to iomap_dio_rw" that
Darrick ran into. Then there are the user copy issues that Al has
pointed out. Fixing those will create superficial conflicts with this
patch queue, but probably nothing serious.

So how should I proceed: do you expect a v8 of this patch queue on top
of the current mainline?

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
