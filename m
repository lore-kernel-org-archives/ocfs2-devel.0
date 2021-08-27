Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF134C4320E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:56:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5E4B660E78
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:56:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5E4B660E78
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGaMVW013604;
	Fri, 27 Aug 2021 19:56:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap552cd5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 19:56:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RJpqsu018792;
	Fri, 27 Aug 2021 19:56:35 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm594dq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 19:56:35 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJhxq-0004pp-5f; Fri, 27 Aug 2021 12:56:34 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mJhxk-0004pO-Nd
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 12:56:28 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RJpN1e173768
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:56:28 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3aq5yy1u6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:56:28 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RJdECx032539
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:56:27 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq6d5g5n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:56:26 +0000
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
	[209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-571-_3TuT7B0NXONfJgwjWjSyg-1; Fri, 27 Aug 2021 15:56:24 -0400
X-MC-Unique: _3TuT7B0NXONfJgwjWjSyg-1
Received: by mail-wm1-f69.google.com with SMTP id
	w25-20020a1cf6190000b0290252505ddd56so2470958wmc.3
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 12:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=sd/3n0607wJTjqztLgFnu0bOLL0OQcH0TvNvy1LbLr8=;
	b=PEWVoJsYRGhxeOKU/lHuj5ZduRYuBfRLXBRE2cbpUPqmOp3pA4w8rOc4dZU/HX1upL
	zY1uwFwEHkvYL2ctljm4Sm9qnOznAtaL0F441F+gzuKMo0ntBEtQ3BMSAoagQiFGYMl7
	G8o5aYDnxTZZSrTo3tov89gKPPzaqbzUMgA2S1QOr5hEYquuxOAU8Bljn6qTznReNjS3
	itNxUxZpEsVI9HkDwnwejtydT4Qt0hgDFebGtv3R0JC0K1BOVeI2MzxZUdlN6J+lVJgk
	dk9E9adbu3XIlRNg1J9jAgIKHzJ5brRdqZeu4LwW4M7uJ0pKAAWnbzXhnrK0TcoLKSj9
	Pxpw==
X-Gm-Message-State: AOAM531MLgKrWdV3EjzUpLs+nw4om4yGtII7TePA6ddhS8xXFlPz96XI
	km2hjaZ1twmFQrlQ3h4UP04Gf7yPgQJwpK8NrvbzVldg8+Boo3t9yuv1TQFRt6me/0WOO3C/3dq
	rUwhBshKIVMpdYH68z9aMb7hlwUWhMliBqqVw+A==
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr12104535wrb.329.1630094182742; 
	Fri, 27 Aug 2021 12:56:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydEhO4+TbNABovpa3HgGNECXB3WhRpPNdamPW7spcpayLjxbNmB0mkBEQta0WVv1DaGiTw07KdhCXl6aFWwBE=
X-Received: by 2002:a5d:47a4:: with SMTP id 4mr12104517wrb.329.1630094182497; 
	Fri, 27 Aug 2021 12:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-19-agruenba@redhat.com>
	<YSkzSHSp8lld6dwW@zeniv-ca.linux.org.uk>
In-Reply-To: <YSkzSHSp8lld6dwW@zeniv-ca.linux.org.uk>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 27 Aug 2021 21:56:10 +0200
Message-ID: <CAHc6FU47cApVzAcVrkCLfoV7AGzs7T-cBGejVXRtfHWVdhXfxA@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 mlxscore=0
	phishscore=0 mlxlogscore=485 suspectscore=0 adultscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270116
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 18/19] iov_iter: Introduce nofault flag
	to disable page faults
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270116
X-Proofpoint-GUID: XsXhRAmIwQEYyj_NjLa1dqDz88CqP9fa
X-Proofpoint-ORIG-GUID: XsXhRAmIwQEYyj_NjLa1dqDz88CqP9fa

On Fri, Aug 27, 2021 at 8:47 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Aug 27, 2021 at 06:49:25PM +0200, Andreas Gruenbacher wrote:
> > Introduce a new nofault flag to indicate to get_user_pages to use the
> > FOLL_NOFAULT flag.  This will cause get_user_pages to fail when it
> > would otherwise fault in a page.
> >
> > Currently, the noio flag is only checked in iov_iter_get_pages and
> > iov_iter_get_pages_alloc.  This is enough for iomaop_dio_rw, but it
> > may make sense to check in other contexts as well.
>
> I can live with that, but
>         * direct assignments (as in the next patch) are fucking hard to
> grep for.  Is it intended to be "we set it for duration of primitive",
> or...?

It's for this kind of pattern:

       pagefault_disable();
       to->nofault = true;
       ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL,
                          IOMAP_DIO_PARTIAL, written);
       to->nofault = false;
       pagefault_enable();

Clearing the flag at the end isn't strictly necessary, but it kind of
documents that the flag pertains to iomap_dio_rw and not something
else.

>         * it would be nice to have a description of intended semantics
> for that thing.  This "may make sense to check in other contexts" really
> needs to be elaborated (and agreed) upon.  Details, please.

Maybe the description should just be something like:

"Introduce a new nofault flag to indicate to iov_iter_get_pages not to
fault in user pages.

This is implemented by passing the FOLL_NOFAULT flag to get_user_pages,
which causes get_user_pages to fail when it would otherwise fault in a
page. We'll use the ->nofault flag to prevent iomap_dio_rw from faulting
in pages when page faults are not allowed."

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
