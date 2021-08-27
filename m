Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9514FC432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 17:17:10 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 28D0A60EB5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 17:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 28D0A60EB5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGg1Lj024925;
	Fri, 27 Aug 2021 17:17:09 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4xv433n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 17:17:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RHFdEZ072529;
	Fri, 27 Aug 2021 17:17:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb92g10a-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 17:17:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJfTW-0005RJ-PM; Fri, 27 Aug 2021 10:17:06 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mJfTR-0005Qs-Qt
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 10:17:01 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RHFSq2089433
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 17:17:01 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3ajsabhrg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 17:17:01 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RDlAD2004321
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 17:17:00 GMT
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
	[209.85.167.43])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq17y2bm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 17:16:59 +0000
Received: by mail-lf1-f43.google.com with SMTP id j4so15780019lfg.9
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 10:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=j79aTkkV7QWLMRm7gv45CG9ALkTrZZR1j0Lx/8G3d6o=;
	b=bHLpZaySDxNSwnlwVTqbLBCZ7b8/ar6afGDscvEHmUNQl3FKYkrUiLod8nBgW0sSg2
	yrgQ0epPjjdaG+f0Yv0l6X/IM/dy8p2Ejyn64lFwT/Vi9X3gtMFTmc0gX0PLl+riowsJ
	ptc1o7mgaPYkBbWlPUQxc7gP350UlmZRX7mVIl/hCC9ntZjOq/p1BZBu/sDPrZp8Q/rD
	psP4gn2hvMVLrwmUl4nhPSI5fS2lFk7c35SHpn0OWEIrR5S2m1NziGYMwdgfAW6JleZg
	XwXLUa9Isn2r1LHoWSLgLN6o6C5L7dQYOrOM4Jug+hYyKY1zX6ssDIoeVxxuKLTWthIM
	A4mQ==
X-Gm-Message-State: AOAM5323I3my0St4BfMJuemjjUHMpK0Nh8vhAdD68BkU5KaRfqR13aMx
	52/jbILtTk8KtlGZZB2CRpLaXMhift25aciI
X-Google-Smtp-Source: ABdhPJwkc6UipLEqh4GW0/eL4QNgFKZtBZ9Fj6TiwiW0eQ54yWts/9oE1Ale8xUBQ/hzrK16QCIgRA==
X-Received: by 2002:ac2:5470:: with SMTP id e16mr7666911lfn.399.1630084616543; 
	Fri, 27 Aug 2021 10:16:56 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com.
	[209.85.208.178]) by smtp.gmail.com with ESMTPSA id
	t17sm633450lfq.176.2021.08.27.10.16.53
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 27 Aug 2021 10:16:55 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id c12so12660764ljr.5
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 10:16:53 -0700 (PDT)
X-Received: by 2002:a2e:3004:: with SMTP id w4mr8318181ljw.465.1630084613565; 
	Fri, 27 Aug 2021 10:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
In-Reply-To: <20210827164926.1726765-1-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Aug 2021 10:16:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
Message-ID: <CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.43
X-ServerName: mail-lf1-f43.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
	mlxscore=0
	suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
	bulkscore=0
	phishscore=0 priorityscore=120 clxscore=380 spamscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108270104 domainage_hfrom=5365
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	spamscore=0
	mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270104
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270104
X-Proofpoint-ORIG-GUID: c6CmBNhXCZwPcdM4cLmc4d1RR9pb5KAi
X-Proofpoint-GUID: c6CmBNhXCZwPcdM4cLmc4d1RR9pb5KAi

On Fri, Aug 27, 2021 at 9:49 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> here's another update on top of v5.14-rc7.  Changes:
>
>  * Some of the patch descriptions have been improved.
>
>  * Patch "gfs2: Eliminate ip->i_gh" has been moved further to the front.
>
> At this point, I'm not aware of anything that still needs fixing,

>From a quick scan, I didn't see anything that raised my hackles.

But I skipped all the gfs2-specific changes in the series, since
that's all above my paygrade.

                 Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
