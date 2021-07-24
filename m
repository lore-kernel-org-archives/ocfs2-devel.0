Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55BBC4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 07:51:46 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A2BC60E95
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 07:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3A2BC60E95
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O7pjSU004964;
	Sat, 24 Jul 2021 07:51:45 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a099c070w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 07:51:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O7ofiL152635;
	Sat, 24 Jul 2021 07:51:44 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07ys063n-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 07:51:44 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7CRj-0001DI-3o; Sat, 24 Jul 2021 00:51:43 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1m7CRg-0001Bv-2C
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 00:51:40 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16O7pSRX067243
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 07:51:39 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3a08wbc2mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 07:51:39 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16O7i2wF008605
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 07:51:38 GMT
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
	[209.85.166.52])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0c4e8vnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 07:51:38 +0000
Received: by mail-io1-f52.google.com with SMTP id h1so5253064iol.9
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 00:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=y2QQPVpY5Yk4Ahbva/fAslyPabEv5/WNks/0wpOIAes=;
	b=GylG9fCd3XAZkjA4WpNoNlnRb3KiFQcfakQbSJ0NRw0TQGWMm4pP7rq2blZzRZ+sJx
	AGKRgz653T1fETwV3nuLGAIWVi1jkq1C6h/w6XjBvznPcE4zvaKVgfbDXp8VzlGhqJG9
	NCkhHNEilLgaw8arzghiIbpej4FrW9+bbNqZwtUsJhSHTlpuI5USCksiQJ1fRjTr3Erb
	psftGgjiCiMhzxtqWtRTnsMa00a+MOVhZWQRGzSbHG8tglAgTlrG3rjUJzpl6zRRiM0F
	onJU8Cl86LtcvW9nJ9vtYQQNLRhnSk4UL3G0/D6effiiynkNFQA+tv/BmdZdqmTjgafl
	nmdA==
X-Gm-Message-State: AOAM533wScYSUCqs0iirUr3JTKGpsHWqxXRCfDiHgA8M32kQ5bO1xcHC
	pmiQE/JGJIdaepMonlBqG6uRDCsUYIr0xafcmt0=
X-Google-Smtp-Source: ABdhPJzDdEnxvONgCmtty5Tezj88xyF1uFQQzt9Gfef9fX5MDhIGXPXu7+QsRQ7ua/GZtyyXWjULBqOJosu+Nt5XcBM=
X-Received: by 2002:a02:85a5:: with SMTP id d34mr7400013jai.132.1627113097425; 
	Sat, 24 Jul 2021 00:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-2-agruenba@redhat.com>
	<CAHk-=wg1n8yVeKABgfx7itM5o1jXVx6WXRF5PxHx+uqeFBmsmQ@mail.gmail.com>
In-Reply-To: <CAHk-=wg1n8yVeKABgfx7itM5o1jXVx6WXRF5PxHx+uqeFBmsmQ@mail.gmail.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Sat, 24 Jul 2021 09:51:26 +0200
Message-ID: <CAHpGcMK7mT+QuDJZ-Aqq+gWgT2HZUkD_JkVgabEyOR1gOebUjA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Source-IP: 209.85.166.52
X-ServerName: mail-io1-f52.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	bulkscore=0 phishscore=0
	mlxscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
	impostorscore=0
	priorityscore=354 mlxlogscore=955 spamscore=0 clxscore=285
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
	definitions=main-2107240048 domainage_hfrom=9477
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 adultscore=0
	bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240049
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240049
X-Proofpoint-GUID: vqR2WUeCkTV3iM35FDNLbaMzlskQEutB
X-Proofpoint-ORIG-GUID: vqR2WUeCkTV3iM35FDNLbaMzlskQEutB

Am Sa., 24. Juli 2021 um 01:41 Uhr schrieb Linus Torvalds
<torvalds@linux-foundation.org>:
> On Fri, Jul 23, 2021 at 1:58 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> >
> > Introduce a new fault_in_iov_iter helper for manually faulting in an iterator.
> > Other than fault_in_pages_writeable(), this function is non-destructive.
>
> Again, as I pointed out in the previous version, "Other than" is not
> sensible language.

Thanks for pointing this out a second time. I have no idea how I
screwed up fixing that.

Andreas

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
