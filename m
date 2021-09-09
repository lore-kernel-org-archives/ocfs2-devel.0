Return-Path: <SRS0=mf1/=N7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAC0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 17:20:55 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B13161104
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 17:20:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B13161104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189FbA3C016944;
	Thu, 9 Sep 2021 17:20:54 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ayf8a9fnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Sep 2021 17:20:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189H0svx011069;
	Thu, 9 Sep 2021 17:20:53 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3axst5rd3f-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 09 Sep 2021 17:20:53 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mONgF-0005Su-4p; Thu, 09 Sep 2021 10:17:43 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mONg9-0005SS-Pg
	for ocfs2-devel@oss.oracle.com; Thu, 09 Sep 2021 10:17:37 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	189H0IjH080523
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 17:17:37 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3axcpqgwt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 17:17:37 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	189EKxeW030067
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 17:17:36 GMT
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
	[209.85.167.49])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ay92mhnxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 17:17:35 +0000
Received: by mail-lf1-f49.google.com with SMTP id n2so5194927lfk.0
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 10:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=jlWzkECk20+XqmMBmmlhgHERfUmOY5RNnADt8Z36qog=;
	b=6kvqHwhWgQNZ/iOQvAYsHgWlAHVUq3y9vKbE+vmgbO4zcwGNJAXtd2bg1A+939bRCu
	Bid8QGCyssvXnXInj1hjnP1Rkc50y9s0SntfkE3svgnjPVgsxyFUuqSltQy3RVHFiUO4
	pIOdhxhhQATshHX6NW97NfJlMD8kZ/c5PGZWbt5O2eSE64c7iP14Zt5wlo1rygellSKM
	xqBsBfyYwy7bs6zbo85NLMXHrpbv/2QZZG8kSPEWG2L4BQ39YyI6hJeJH9mTe/DCCQiH
	N9mbJHC4zuRvmboVaa5wzvrP+HmyjGTqOp4SAsaYSre6G0me4WkgHRl+vJeniMlAGeLZ
	aw2A==
X-Gm-Message-State: AOAM530tPI3UqgSy6XY518IQL93AjYTs7IW8IdjhZxDVTwAGhA/dj2d9
	u42TTFfTWz7AaLjfrHRJHmOHkpLs+TzGaWTztbY=
X-Google-Smtp-Source: ABdhPJzI178oKWk2eQaAUJsRUzCGzjdz1T5S0P8qAU2IrGv+1xYbOqO2qjGuKObtMdzZKqQdTFtVUQ==
X-Received: by 2002:a05:6512:234e:: with SMTP id
	p14mr720401lfu.324.1631207851309; 
	Thu, 09 Sep 2021 10:17:31 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com.
	[209.85.208.172])
	by smtp.gmail.com with ESMTPSA id y1sm256760lfb.297.2021.09.09.10.17.30
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 09 Sep 2021 10:17:30 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id r3so4127356ljc.4
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 10:17:30 -0700 (PDT)
X-Received: by 2002:a2e:8185:: with SMTP id e5mr734988ljg.31.1631207850194;
	Thu, 09 Sep 2021 10:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-18-agruenba@redhat.com>
	<YTnxruxm/xA/BBmQ@infradead.org>
In-Reply-To: <YTnxruxm/xA/BBmQ@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Sep 2021 10:17:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4RER3XeG34nLH2PgvuRuj_NRgDx=wLTKv=jYaQnFe+Q@mail.gmail.com>
Message-ID: <CAHk-=wj4RER3XeG34nLH2PgvuRuj_NRgDx=wLTKv=jYaQnFe+Q@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Source-IP: 209.85.167.49
X-ServerName: mail-lf1-f49.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	phishscore=0
	mlxlogscore=816 bulkscore=0 lowpriorityscore=0 impostorscore=0
	mlxscore=0
	malwarescore=0 adultscore=0 priorityscore=238 spamscore=0 clxscore=360
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109090106 domainage_hfrom=5378
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 17/19] gup: Introduce FOLL_NOFAULT flag
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090106
X-Proofpoint-ORIG-GUID: 1nVsbkAclG9jTA6EwOXPyXuWyajcmWi8
X-Proofpoint-GUID: 1nVsbkAclG9jTA6EwOXPyXuWyajcmWi8

On Thu, Sep 9, 2021 at 4:36 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Aug 27, 2021 at 06:49:24PM +0200, Andreas Gruenbacher wrote:
> > Introduce a new FOLL_NOFAULT flag that causes get_user_pages to return
> > -EFAULT when it would otherwise trigger a page fault.  This is roughly
> > similar to FOLL_FAST_ONLY but available on all architectures, and less
> > fragile.
>
> So, FOLL_FAST_ONLY only has one single user through
> get_user_pages_fast_only (pin_user_pages_fast_only is entirely unused,
> which makes totally sense given that give up on fault and pin are not
> exactly useful semantics).

So I think we should treat FOLL_FAST_ONLY as a special "internal to
gup.c" flag, and perhaps not really compare it to the new
FOLL_NOFAULT.

In fact, maybe we could even just make FOLL_FAST_ONLY be the high bit,
and not expose it in <linux/mm.h> and make it entirely private as a
name in gup.c.

Because FOLL_FAST_ONLY really is meant more as a "this way we can
share code easily inside gup.c, by having the internal helpers that
*can* do everything, but not do it all when the user is one of the
limited interfaces".

Because we don't really expect people to use FOLL_FAST_ONLY externally
- they'll use the explicit interfaces we have instead (ie
"get_user_pages_fast()"). Those use-cases that want that fast-only
thing really are so special that they need to be very explicitly so.

FOLL_NOFAULT is different, in that that is something an external user
_would_ use.

Admittedly we'd only have one single case for now, but I think we may
end up with other filesystems - or other cases entirely - having that
same kind of "I am holding locks, so I can't fault into the MM, but
I'm otherwise ok with the immediate mmap_sem lock usage and sleeping".

End result: FOLL_FAST_ONLY and FOLL_NOFAULT have some similarities,
but at the same time I think they are fundamentally different.

The FAST_ONLY is the very very special "I can't sleep, I can't even
take the fundamental MM lock, and we export special interfaces because
it's _so_ special and can be used in interrupts etc".

In contrast, NOFAULT is not _that_ special. It's just another flag,
and has generic use.

               Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
