Return-Path: <SRS0=7twz=NT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F709C432BE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 28 Aug 2021 17:17:17 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E6B6D60C41
	for <ocfs2-devel@archiver.kernel.org>; Sat, 28 Aug 2021 17:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E6B6D60C41
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17SCnQql032040;
	Sat, 28 Aug 2021 17:17:16 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aqbx20rgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Aug 2021 17:17:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17SHFr7F012441;
	Sat, 28 Aug 2021 17:17:14 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aqa8uga0x-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 28 Aug 2021 17:17:14 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mK1u8-0006Ac-L9; Sat, 28 Aug 2021 10:14:04 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mK1tf-00069h-As
	for ocfs2-devel@oss.oracle.com; Sat, 28 Aug 2021 10:13:35 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17SH5s8D186443
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 17:13:35 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3aqa8ug72s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 17:13:34 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17SGfOsk029452
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 17:13:33 GMT
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
	[209.85.208.177])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqrvp06bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 17:13:32 +0000
Received: by mail-lj1-f177.google.com with SMTP id i28so17451710ljm.7
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 10:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=PG8z+XIonuWGdu3czEMXRzaWItNuzacbk0dZJgvuswY=;
	b=BHPn5mv/52Iw5AwgpEpwoRgX1fyPpGSuTdFL6amFhuNRA0Onj4OX9v7Nh7vfXl4oDZ
	W3addY8QDvpJanRYJ29wLxPtVpJLQyZHF/AG1JIB/nGxow54aayoOips//ugNKZpgNyv
	fZqEz17kw9SgvCWFyPRcdcwPmIEa53VMXOIYWDBHDdl5Lkmxcvgz56TK0XdDvRMWFbd3
	vvyxN9yiuDXj93pjU8P9Ma83OJqXeR8Oqfei6gRXqWtJrPywMY7UdkmvPuM9NhSYUI5e
	DgtTbDp6GhzCv78mk/iV4N8JmAmjxB0n9P785p/UH1hB0VjHkYZ1fRmxLQuyIQ2HRWuK
	G3xA==
X-Gm-Message-State: AOAM532HQdMQKR9Wu6dBG22HeYCLq3VL00b2RDT5wNXb3ZkCpjKlClaH
	qsIzB08Aj5MkcIXq7MtD1KheqD1b4CCZ+QRC
X-Google-Smtp-Source: ABdhPJwEhj08hGiVm3PmFGgJ1JTP/qIF6zlS0VBbmhTk6fB/tsaDtvQLNY1f94/q6npDjKPh1oHxlw==
X-Received: by 2002:a2e:9881:: with SMTP id b1mr12824627ljj.53.1630170809320; 
	Sat, 28 Aug 2021 10:13:29 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com.
	[209.85.208.175])
	by smtp.gmail.com with ESMTPSA id p3sm918214lfg.33.2021.08.28.10.13.27
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 28 Aug 2021 10:13:27 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id h1so17426087ljl.9
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 10:13:27 -0700 (PDT)
X-Received: by 2002:a2e:7d0e:: with SMTP id y14mr12752568ljc.251.1630170807239;
	Sat, 28 Aug 2021 10:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-5-agruenba@redhat.com>
	<20210827205644.lkihrypv27er5km3@kari-VirtualBox>
In-Reply-To: <20210827205644.lkihrypv27er5km3@kari-VirtualBox>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Aug 2021 10:13:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh-TeAeraYo9jM7FsAVDtfCji_5ao=B3eoO10Sf2SdeTA@mail.gmail.com>
Message-ID: <CAHk-=wh-TeAeraYo9jM7FsAVDtfCji_5ao=B3eoO10Sf2SdeTA@mail.gmail.com>
To: Kari Argillander <kari.argillander@gmail.com>
X-Source-IP: 209.85.208.177
X-ServerName: mail-lj1-f177.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
	impostorscore=0
	lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
	spamscore=0 clxscore=384 mlxscore=0 suspectscore=0 priorityscore=30
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108280113 domainage_hfrom=5366
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108280112
Cc: Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 04/19] iov_iter: Turn
	iov_iter_fault_in_readable into fault_in_iov_iter_readable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280113
X-Proofpoint-GUID: W9IDDkrKu_miF-4tu7AWFCFAM0cgil9n
X-Proofpoint-ORIG-GUID: W9IDDkrKu_miF-4tu7AWFCFAM0cgil9n

On Fri, Aug 27, 2021 at 1:56 PM Kari Argillander
<kari.argillander@gmail.com> wrote:
>
> At least this patch will break ntfs3 which is in next. It has been there
> just couple weeks so I understand. I added Konstantin and ntfs3 list so
> that we know what is going on. Can you please info if and when do we
> need rebase.

No need to rebase. It just makes it harder for me to pick one pull
over another, since it would mix the two things together.

I'll notice the semantic conflict as I do my merge build test, and
it's easy for me to fix as part of the merge - whichever one I merge
later.

It's good if both sides remind me about the issue, but these kinds of
conflicts are not a problem.

And yes, it does happen that I miss conflicts like this if I merge
while on the road and don't do my full build tests, or if it's some
architecture-specific thing or a problem that doesn't happen on my
usual allmodconfig testing.  But neither of those cases should be
present in this situation.

                    Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
