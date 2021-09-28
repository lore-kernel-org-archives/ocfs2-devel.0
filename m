Return-Path: <SRS0=SdAF=OS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95283C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 15:09:29 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C98D611CE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 15:09:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C98D611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SEU5HW007903;
	Tue, 28 Sep 2021 15:09:28 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bbejehvj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Sep 2021 15:09:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SF8Aju036637;
	Tue, 28 Sep 2021 15:09:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bc3ccqas2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 28 Sep 2021 15:09:26 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVEgS-0004Zb-N0; Tue, 28 Sep 2021 08:06:16 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mVEgL-0004ZE-11
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 08:06:09 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18SEuQRB173192
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 15:06:08 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bc3bhexqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 15:06:08 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18SECG4a015187
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 15:06:07 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc4kds14m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 15:06:04 +0000
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
	[209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-231-dnIz1UZDPRq7qqkQPhYchQ-1; Tue, 28 Sep 2021 11:05:59 -0400
X-MC-Unique: dnIz1UZDPRq7qqkQPhYchQ-1
Received: by mail-wm1-f71.google.com with SMTP id
	z137-20020a1c7e8f000000b0030cd1800d86so2164297wmc.2
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 08:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=GTEeKi/UYmjYJkWNK0SGATQ/qYJFiOXPZZXq8sMSFeY=;
	b=TYzk7O4s5RnBzAPXitVZLrtlyQXTAYHFHLA6czO4FezR6T/K6CeflrKQVWqSyLjRUh
	mFPMZR49/7amNgywsk085q1bEFkK01Gd5c9eethFsfmGBJLbEkVopDNonRTLAGzOqy52
	h7bH424GlP2V01ax5K/j7XQeqM7ioVISz9CTA65DU71cNPH22kFJh6F7O7jigcAQsALc
	IVw8/98dBpPTdhjPLTxrAMblEJ4NILLRLZ3rKW85VhnC+9XNqHbDy8qDjuSyJdkiBfGx
	9sPfHNBVEevjzf3Sk+wsxebeqU1gX/icagZfdhi+7Bsws6EoXvFWZ7H6gWiMrmPsLoCA
	rVkQ==
X-Gm-Message-State: AOAM533CsVuG4yBQLxyG4KdC01Ivcghqm5ptIe9b8YtR1Y8Jj45oLkgq
	OYqEfj3XZB7IVkwJE4dtCZcm1o/wbB9k47L9LgxK0PCSYPg3sExLSeYS0/iOd+peoB94WmDGaoo
	HR2t0ou3XvwVD/vz75QfwxA92ukwX6ArrwS0dwA==
X-Received: by 2002:a1c:192:: with SMTP id 140mr5194536wmb.186.1632841557838; 
	Tue, 28 Sep 2021 08:05:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz45bDVa7yHh7ZlDdOqmKGhDvsP9wWie0zsYCjSZRICnWeTnJ+JMvq9BqN1jrAgmwTyXD/iZRUEiGUwLJEUR9A=
X-Received: by 2002:a1c:192:: with SMTP id 140mr5194517wmb.186.1632841557678; 
	Tue, 28 Sep 2021 08:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-16-agruenba@redhat.com>
	<YTnuDhNlSN1Ie1MJ@infradead.org>
In-Reply-To: <YTnuDhNlSN1Ie1MJ@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 28 Sep 2021 17:05:46 +0200
Message-ID: <CAHc6FU4_3m-f2T360Vq-WF=nkqDq9Zc+dekRt+wrcjvbUR1oSQ@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 15/19] iomap: Support partial direct
	I/O on user copy failures
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280087
X-Proofpoint-GUID: weShyvVkn2KEclfTLe26HzUIl3a_Q5MM
X-Proofpoint-ORIG-GUID: weShyvVkn2KEclfTLe26HzUIl3a_Q5MM

On Thu, Sep 9, 2021 at 1:22 PM Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Aug 27, 2021 at 06:49:22PM +0200, Andreas Gruenbacher wrote:
> > In iomap_dio_rw, when iomap_apply returns an -EFAULT error and the
> > IOMAP_DIO_PARTIAL flag is set, complete the request synchronously and
> > return a partial result.  This allows the caller to deal with the page
> > fault and retry the remainder of the request.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/direct-io.c  | 6 ++++++
> >  include/linux/iomap.h | 7 +++++++
> >  2 files changed, 13 insertions(+)
> >
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index 8054f5d6c273..ba88fe51b77a 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -561,6 +561,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >               ret = iomap_apply(inode, pos, count, iomap_flags, ops, dio,
> >                               iomap_dio_actor);
> >               if (ret <= 0) {
> > +                     if (ret == -EFAULT && dio->size &&
> > +                         (dio_flags & IOMAP_DIO_PARTIAL)) {
> > +                             wait_for_completion = true;
> > +                             ret = 0;
>
> Do we need a NOWAIT check here to skip the wait_for_completion
> for that case?

Hmm, you're probably right, yes. I'll add that.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
