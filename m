Return-Path: <SRS0=S1qZ=ML=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57EB3C07E95
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 19:30:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB131610D2
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 19:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB131610D2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JJRGc2006035;
	Mon, 19 Jul 2021 19:30:01 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39w83cs1tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jul 2021 19:30:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JJAPsQ106510;
	Mon, 19 Jul 2021 19:29:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39umaxjr5n-1;
	Mon, 19 Jul 2021 19:29:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m5Yxi-0007Fj-O3; Mon, 19 Jul 2021 12:29:58 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m5Yxg-0007FU-SM
	for ocfs2-devel@oss.oracle.com; Mon, 19 Jul 2021 12:29:56 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16JJBECb157830
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:29:56 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 39upe8uee5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:29:56 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16JJS3pI009736
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:29:55 GMT
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
	[209.85.208.175])
	by mx0b-00069f01.pphosted.com with ESMTP id 39w4k7x05k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:29:54 +0000
Received: by mail-lj1-f175.google.com with SMTP id d17so7806704ljq.12
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 12:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=cvseTVwISQQYVhM74Otk0kHaj1gV421l1SCA3Nj6+8A=;
	b=G2+Zi0zFbhX/UDGXaHgn45YoACiWVzInm6jAqLNPgepLpQL07SLfhd/hvQLvXBF4kD
	iNPuJwWWSPFlXY666qF5iXrbmhKfIRmiB7OMaSCL5FlThcToIGKEW6HC95qXXvFnuwkW
	G0anl69rezpDGGV2VSoY/c7y/N15bMUDmSnPQkVb1Ra+rk7PDCcuoolxbL0NSYGXwZ4t
	ScMWSKDtlaQ8mrqmgkX+rNs9fX4jWjpMJsGuEVITFv7j6anzjZdPhGeYv2dTZ3Ony3qg
	mBUsCoaDBEL3Euz155Q1dPHC42xGzQjwdC0x7dTPtPogATjRRK4fYgUvSqxz8VvUkTSy
	tVZQ==
X-Gm-Message-State: AOAM530D5z7JO+lCrCxfqn2qPveH1nagpwwJNuMRtRWPeFGC+DtcbhU+
	ZfhSbrg1lVrozG4dmJdcAZ3pvSp4otCz9DQg
X-Google-Smtp-Source: ABdhPJzIoKHUQczBDX7AhY3BcLC52g9geXmycTtjMIvK4ttUn3IgcgPdfKG+YpJ4Xfhq7cg0dJCv6Q==
X-Received: by 2002:a2e:b00f:: with SMTP id y15mr24300143ljk.258.1626722992477;
	Mon, 19 Jul 2021 12:29:52 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com.
	[209.85.167.53]) by smtp.gmail.com with ESMTPSA id
	t10sm2102900ljk.56.2021.07.19.12.29.51
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 19 Jul 2021 12:29:51 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id i5so32109603lfe.2
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 12:29:51 -0700 (PDT)
X-Received: by 2002:a05:6512:404:: with SMTP id
	u4mr18798424lfk.40.1626722990987; 
	Mon, 19 Jul 2021 12:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210718223932.2703330-1-agruenba@redhat.com>
	<20210718223932.2703330-6-agruenba@redhat.com>
In-Reply-To: <20210718223932.2703330-6-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Jul 2021 12:29:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh3p41a-=7FFf36sYBQP750ys6CKi0S7JNiCSatY5-7og@mail.gmail.com>
Message-ID: <CAHk-=wh3p41a-=7FFf36sYBQP750ys6CKi0S7JNiCSatY5-7og@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.208.175
X-ServerName: mail-lj1-f175.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	adultscore=0
	mlxlogscore=999 mlxscore=0 priorityscore=30 malwarescore=0
	lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=350 phishscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190111
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0 bulkscore=0
	malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190110
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 5/6] iov_iter: Introduce
	ITER_FLAG_FAST_ONLY flag
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190110
X-Proofpoint-GUID: CmpHzirxA_z22MpJXq4J1YqHElM8yvni
X-Proofpoint-ORIG-GUID: CmpHzirxA_z22MpJXq4J1YqHElM8yvni

On Sun, Jul 18, 2021 at 3:40 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> Introduce a new ITER_FLAG_FAST_ONLY flag

I think the code is fine, but I think it might be best to call this
"ITER_FLAG_NOIO" or something like that.

The "FAST_ONLY" name makes sense in the context of
"get_user_pages_fast()" where we have that "fast" naming (and the long
history too). But I don't think it makes much sense as a name in the
context of iov_iter.

                   Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
