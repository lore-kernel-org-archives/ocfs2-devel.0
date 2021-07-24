Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2898C4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 19:53:04 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3641360E96
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 19:53:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3641360E96
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16OJmGVF026560;
	Sat, 24 Jul 2021 19:53:03 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a0arbgrjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 19:53:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16OJoljf073038;
	Sat, 24 Jul 2021 19:53:01 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07yspwbv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 19:53:01 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7Nhk-0001xg-Cz; Sat, 24 Jul 2021 12:53:00 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m7Nhg-0001xF-82
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 12:52:56 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16OJooNh073573
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:52:55 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3a07yspw7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:52:55 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16OJlAB2009495
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:52:54 GMT
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
	[209.85.167.53])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0ae6cq9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 19:52:54 +0000
Received: by mail-lf1-f53.google.com with SMTP id g13so7935385lfj.12
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 12:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=lpee2uSXjqYzurXDPtFtjsJbLcrcS7+O9pSXA980Af4=;
	b=C3A8WbpCO/c45cASC8/B4K6BZCHmA6tKNhWFFXTWQiNObD+DvopITfye2CaIH0c8AI
	trnRxMGtk38y40hdiv0OAK2BME0r+BOafegHrFcv2BpRKnjMYVSJCwhCwYM+j6ZeEu1U
	5YO+ewUxt/lIokAq9wAH6Z8j0GqdDjfayXBLDpzsMC1y6C07NIgfgQm4yeVH3/fJgbQy
	v4+PuZAj6XfcBPn8ba60porJInbcIYRALJfq7CZWyxgRiOpPfzXcJny3YpzoNMsKo2Wc
	LDwlizpSXN+oXQ9VxEYICTcsx9S3xC9GZ1ULJ3DwFSikv7Z07fKtZVy5IQbS0RcRH/90
	KmmA==
X-Gm-Message-State: AOAM532oG5jOSEIbcouXRqAA6Vma372N4IM7nSno1QGjiOCMSwrRyYEZ
	0m6+P8af9mM/rTIk/Jvx4xaz7gHq5LtGlKuP
X-Google-Smtp-Source: ABdhPJx9fLvX0TAz1DIP5Ufhb8pB5D+I6rrpJm71Iihi6K6wRhQJMteq1Ak2Fvr46Tbf19F7hOUNcg==
X-Received: by 2002:a19:5f48:: with SMTP id a8mr7436939lfj.496.1627156371035; 
	Sat, 24 Jul 2021 12:52:51 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com.
	[209.85.167.49]) by smtp.gmail.com with ESMTPSA id
	x19sm2569744lfc.32.2021.07.24.12.52.50
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 24 Jul 2021 12:52:50 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id r17so8015404lfe.2
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 12:52:50 -0700 (PDT)
X-Received: by 2002:a05:6512:3f82:: with SMTP id
	x2mr7023206lfa.421.1627156370007; 
	Sat, 24 Jul 2021 12:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
In-Reply-To: <20210724193449.361667-2-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Jul 2021 12:52:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
Message-ID: <CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.53
X-ServerName: mail-lf1-f53.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 bulkscore=0
	mlxlogscore=999 mlxscore=0 priorityscore=149 spamscore=0 adultscore=0
	impostorscore=0 suspectscore=0 malwarescore=0 clxscore=364 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240119
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	bulkscore=0 phishscore=0
	malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240119
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 1/8] iov_iter: Introduce
	iov_iter_fault_in_writeable helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240119
X-Proofpoint-ORIG-GUID: v8oO3Ofr2ztfJPTak_aldASEn2bqTu5j
X-Proofpoint-GUID: v8oO3Ofr2ztfJPTak_aldASEn2bqTu5j

On Sat, Jul 24, 2021 at 12:35 PM Andreas Gruenbacher
<agruenba@redhat.com> wrote:
>
> +int iov_iter_fault_in_writeable(const struct iov_iter *i, size_t bytes)
> +{
...
> +                       if (fault_in_user_pages(start, len, true) != len)
> +                               return -EFAULT;

Looking at this once more, I think this is likely wrong.

Why?

Because any user can/should only care about at least *part* of the
area being writable.

Imagine that you're doing a large read. If the *first* page is
writable, you should still return the partial read, not -EFAULT.

So I think the code needs to return 0 if _any_ fault was successful.
Or perhaps return how much it was able to fault in. Because returning
-EFAULT if any of it failed seems wrong, and doesn't allow for partial
success being reported.

The other reaction I have is that you now only do the
iov_iter_fault_in_writeable, but then you make fault_in_user_pages()
still have that "bool write" argument.

We already have 'fault_in_pages_readable()', and that one is more
efficient (well, at least if the fault isn't needed it is). So it
would make more sense to just implement fault_in_pages_writable()
instead of that "fault_in_user_pages(, bool write)".

                 Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
