Return-Path: <SRS0=mf1/=N7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94ECFC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 17:23:28 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DAB56103E
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Sep 2021 17:23:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3DAB56103E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189GUS4d023507;
	Thu, 9 Sep 2021 17:23:27 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aydrshxhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Sep 2021 17:23:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189H0tGq011141;
	Thu, 9 Sep 2021 17:23:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3axst5rhjx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 09 Sep 2021 17:23:25 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mONlf-0005fy-9y; Thu, 09 Sep 2021 10:23:19 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mONle-0005fj-56
	for ocfs2-devel@oss.oracle.com; Thu, 09 Sep 2021 10:23:18 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	189H10ka176974
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 17:23:17 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3axcq39j3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 17:23:17 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	189EL5QX024886
	for <ocfs2-devel@oss.oracle.com>; Thu, 9 Sep 2021 17:23:16 GMT
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
	[209.85.167.50])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ay6pnbtr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 17:23:16 +0000
Received: by mail-lf1-f50.google.com with SMTP id h16so5111265lfk.10
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 10:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=p6IJpdyTV9RM1+HAVghvZCBeKL8NDMdT8/thsJ+vYl0=;
	b=kEFKk0z7M+WuYFamn1tG+1/W0iRg3oJRENRdrni9hsypiCd0OZa0GZoFNQANNwA9jd
	5Un8XIcCd8//MC0GdN9iVElXh/7VamiTkbVzFjaqpWTtZUCx41CvsZ7pkX4wTBp5r2m2
	yAQAJ4KElV7YXOknS2SByd/FYWjH96bezHiBkcl+LOaQBsc6+wk+MdoVaXucaLjjrg7R
	9Ekq0IdgM2LNoV4I+gh3e81Ut5EaO5tlsD4es9bI1I9xYS9hoJzv2aSf2PcOjxGXEMuU
	I9cqJ4z4YgwxEUHGMBLUYo+q4N422nTSpqoG2EhythsGNfw+GXzu51FtN6r/yYx+RJSe
	agCw==
X-Gm-Message-State: AOAM530taivzJQK+fTXB6YXNaVqht2CS3jCeAQ9p034ft69duL9/9mSo
	AWqZiGqkomRo+q+aGBedmPjXrnsfReZAV2tseSo=
X-Google-Smtp-Source: ABdhPJyhkkkrD+mWBzfE8u62lCO6bKrZuBkCdQ0Oj+sB37m4H4BcCJyG9zeBGbku8M2hZzda7DxrqA==
X-Received: by 2002:ac2:5d49:: with SMTP id w9mr722710lfd.450.1631208193169;
	Thu, 09 Sep 2021 10:23:13 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com.
	[209.85.208.171])
	by smtp.gmail.com with ESMTPSA id q26sm71740lfb.271.2021.09.09.10.23.12
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 09 Sep 2021 10:23:12 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id q21so4145974ljj.6
	for <ocfs2-devel@oss.oracle.com>; Thu, 09 Sep 2021 10:23:12 -0700 (PDT)
X-Received: by 2002:a2e:a363:: with SMTP id i3mr806608ljn.56.1631208192152;
	Thu, 09 Sep 2021 10:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-17-agruenba@redhat.com>
	<YTnwZU8Q0eqBccmM@infradead.org>
In-Reply-To: <YTnwZU8Q0eqBccmM@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Sep 2021 10:22:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgF7TPaumMU6HjBjawjFWjvEg=116=gtnzsxAcfdP4wAw@mail.gmail.com>
Message-ID: <CAHk-=wgF7TPaumMU6HjBjawjFWjvEg=116=gtnzsxAcfdP4wAw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Source-IP: 209.85.167.50
X-ServerName: mail-lf1-f50.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	mlxlogscore=979
	suspectscore=0 phishscore=0 clxscore=357 mlxscore=0 lowpriorityscore=0
	adultscore=0 malwarescore=0 bulkscore=0 priorityscore=217 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001
	definitions=main-2109090107 domainage_hfrom=5378
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 16/19] iomap: Add done_before argument
	to iomap_dio_rw
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
X-Proofpoint-GUID: U9rWfCzo3DDokJzzfDgayf2mcpFTvNh-
X-Proofpoint-ORIG-GUID: U9rWfCzo3DDokJzzfDgayf2mcpFTvNh-

On Thu, Sep 9, 2021 at 4:31 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> What about just passing done_before as an argument to
> iomap_dio_complete? gfs2 would have to switch to __iomap_dio_rw +
> iomap_dio_complete instead of iomap_dio_rw for that, and it obviously
> won't work for async completions, but you force sync in this case
> anyway, right?

I think you misunderstand.

Or maybe I do.

It very much doesn't force sync in this case. It did the *first* part
of it synchronously, but then it wants to continue with that async
part for the rest, and very much do that async completion.

And that's why it wants to add that "I already did X much of the
work", exactly so that the async completion can report the full end
result.

But maybe now it's me who is misunderstanding.

          Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
