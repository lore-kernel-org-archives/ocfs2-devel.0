Return-Path: <SRS0=4BH1=MS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDEEC4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 17:16:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E778A6056C
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 17:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E778A6056C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QHG1W6020282;
	Mon, 26 Jul 2021 17:16:01 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a1qkqsk9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jul 2021 17:16:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QHAhBe005157;
	Mon, 26 Jul 2021 17:15:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a0vmtcyft-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Jul 2021 17:15:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m84Cq-0002EU-UB; Mon, 26 Jul 2021 10:15:56 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m84Co-0002DS-St
	for ocfs2-devel@oss.oracle.com; Mon, 26 Jul 2021 10:15:54 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16QHFdbD061862
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:15:54 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3a08wex10d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:15:54 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QH7kbW009376
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:15:53 GMT
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
	[209.85.208.170])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a1mv8pj5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:15:52 +0000
Received: by mail-lj1-f170.google.com with SMTP id h9so12171542ljq.8
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 10:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=9nCFSPU1gol0E4rDrQO0oADKpQ2235snVgYBEAYRF9Y=;
	b=VP9R/xDiBJHwThturgBcNNFLqbeSmNaMPYyFNRQ3/Yx0ZEFHjcNydmTQe6OiY7z5LQ
	vw99ELhbclkJJrUt7XBg5/JfrXmO+L6bZxhPtUdikqFTp1krZKRMlrVGHD14JJPvqQkd
	+vRxTXy/KU2WrvrTJE0UEMmNM2lMjhbC7LKYVkRr2HPGNSonj2BYkUMjnNuytdXoxO5G
	vyZWOnjyWaETlaCtgEIzyHd8Q7WqvVTbPPJ4bqEw9RFCK+QI8tAe1oFoy23uZH52l3W/
	yl9lPHwNdul4P0WG6H4lIceNW/ypzwSUPnwigLviNaIJdjDsWkaDcOQE7g/we+fA5zyo
	PmQg==
X-Gm-Message-State: AOAM533GTVKIt3bmeuDWCabO2FOQ3r8D0AjU3/X0iX926oWPhLg17Psy
	QlgJmuJgN3RDU59yaPnI5GBxTWrcnIiKKMR6
X-Google-Smtp-Source: ABdhPJxPzgbgzMyvxq3fX9A4rPDhGagdxV93ioxi0ZLXPFn6rSGVq+H6bmpBBbUOOOsBMWJTwDPmsA==
X-Received: by 2002:a05:651c:110:: with SMTP id
	a16mr12076927ljb.241.1627319748775; 
	Mon, 26 Jul 2021 10:15:48 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com.
	[209.85.208.175])
	by smtp.gmail.com with ESMTPSA id t30sm20365ljo.124.2021.07.26.10.15.47
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 26 Jul 2021 10:15:47 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id x7so12148341ljn.10
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 10:15:47 -0700 (PDT)
X-Received: by 2002:a2e:3212:: with SMTP id y18mr12834084ljy.220.1627319747365;
	Mon, 26 Jul 2021 10:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-2-agruenba@redhat.com>
	<20210726163326.GK20621@quack2.suse.cz>
In-Reply-To: <20210726163326.GK20621@quack2.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Jul 2021 10:15:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgqOZmRT_gmAS+K9sA7EYCKM9BYzvJMhy1_P6JaaVGvfA@mail.gmail.com>
Message-ID: <CAHk-=wgqOZmRT_gmAS+K9sA7EYCKM9BYzvJMhy1_P6JaaVGvfA@mail.gmail.com>
To: Jan Kara <jack@suse.cz>
X-Source-IP: 209.85.208.170
X-ServerName: mail-lj1-f170.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	lowpriorityscore=0
	impostorscore=0 spamscore=0 bulkscore=0 clxscore=395 suspectscore=0
	adultscore=0 priorityscore=213 phishscore=0 mlxscore=0 mlxlogscore=880
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260100
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 adultscore=0
	bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260101
Cc: cluster-devel <cluster-devel@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 1/7] iov_iter: Introduce
	fault_in_iov_iter helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260100
X-Proofpoint-GUID: ctwQ0u-8Ir19fg3hp8YbkUWnQRQcNI43
X-Proofpoint-ORIG-GUID: ctwQ0u-8Ir19fg3hp8YbkUWnQRQcNI43

On Mon, Jul 26, 2021 at 9:33 AM Jan Kara <jack@suse.cz> wrote:
>
> On Fri 23-07-21 22:58:34, Andreas Gruenbacher wrote:
> > +     gup_flags = FOLL_TOUCH | FOLL_POPULATE;
>
> I don't think FOLL_POPULATE makes sense here. It makes sense only with
> FOLL_MLOCK and determines whether mlock(2) should fault in missing pages or
> not.

Yeah, it won't hurt, but FOLL_POPULATE doesn't actually do anything
unless FOLL_MLOCK is set. It is, as you say, a magic flag just for
mlock.

The only ones that should matter are FOLL_WRITE (for obvious reasons)
and FOLL_TOUCH (to set the accessed and dirty bits, rather than just
th protection bits)

                   Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
