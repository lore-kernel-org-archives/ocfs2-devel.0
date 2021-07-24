Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF738C4338F
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 08:05:42 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A7F4608FE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 08:05:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A7F4608FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O81PpP003606;
	Sat, 24 Jul 2021 08:05:41 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a09n3070f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 08:05:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O80XXK042205;
	Sat, 24 Jul 2021 08:05:40 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a0a6kucuu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 08:05:40 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7CfD-0002bX-Dj; Sat, 24 Jul 2021 01:05:39 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1m7Cf7-0002b4-CP
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 01:05:33 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16O84e1m181583
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 08:05:33 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3a07ys0kut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 08:05:32 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16O7wbRi016677
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 08:05:30 GMT
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
	[209.85.166.52])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0af1sgkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 08:05:30 +0000
Received: by mail-io1-f52.google.com with SMTP id n19so5413631ioz.0
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 01:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=9SULVsagS4dB16WkbeqR+XAZ1fs3eU5Cq64+TOTbFWY=;
	b=ZK9iOqNQGPqxU5QhbMqEw3J/Jlqqx3SWVINmd06KSkFWkdKBUDfvNoHZT3pfHoDN0W
	RGTFWNlWDuZ57fj0VbxBtt2+dQNnbBFNutGyzBb1Od/RsxuTMJZPMG6oggs9fxNJUSiX
	fOg2UjA/6hdNbLMg5UYzByeq6BPJ/VGW5e9VyNROTdeOoEMqiuHtvKOEskMYxRg6bDLq
	WC0OxxQ/DSvEZ8aAC+eiNyfPmT5UPbiJ2giD/xUHYaSB1k/A+0+RVd4uuq1zDkfro91p
	yRZdSUt0tJrlSdIAgtHXMOmwzfV3C6E+A65+0GujuUGEmuMv/bw+dayodv1AR5VmFO5V
	xNSw==
X-Gm-Message-State: AOAM533p1eElniqMBw8HTBM4ReTnAwsVWCvkqmIiB5zsnOrnTrvoanwU
	iGUaG8cfj9C5ZBD2ly1p6WFf8ETvQjT8rnD4Y/E=
X-Google-Smtp-Source: ABdhPJxujkiDiDqSey8xGa8tGJOhl/wcoSF3auaSX6xq2RVAuE/Dqs2TFuW2iEIVRWFbyuCBwT/HU3fK4Z6wdjYmxSY=
X-Received: by 2002:a6b:c90f:: with SMTP id z15mr6718749iof.183.1627113929048; 
	Sat, 24 Jul 2021 01:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-2-agruenba@redhat.com>
	<YPtyRgyGqJX4Ya/R@zeniv-ca.linux.org.uk>
In-Reply-To: <YPtyRgyGqJX4Ya/R@zeniv-ca.linux.org.uk>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Sat, 24 Jul 2021 10:05:17 +0200
Message-ID: <CAHpGcMJThSqjowuEGCzjNFN8y5tq8kxmxfSivwtuTEMK_xd-cQ@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Source-IP: 209.85.166.52
X-ServerName: mail-io1-f52.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=310 clxscore=274
	phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=901 bulkscore=0
	malwarescore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240050
	domainage_hfrom=9477
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	bulkscore=0 phishscore=0
	malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240051
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107240050
X-Proofpoint-GUID: 2K0h4PYFlDZMhhVGvi-k6PCFRttBVsiI
X-Proofpoint-ORIG-GUID: 2K0h4PYFlDZMhhVGvi-k6PCFRttBVsiI

Am Sa., 24. Juli 2021 um 03:53 Uhr schrieb Al Viro <viro@zeniv.linux.org.uk>:
> On Fri, Jul 23, 2021 at 10:58:34PM +0200, Andreas Gruenbacher wrote:
> > Introduce a new fault_in_iov_iter helper for manually faulting in an iterator.
> > Other than fault_in_pages_writeable(), this function is non-destructive.
> >
> > We'll use fault_in_iov_iter in gfs2 once we've determined that the iterator
> > passed to .read_iter or .write_iter isn't in memory.
>
> Hmm...  I suspect that this is going to be much heavier for read access
> than the existing variant.  Do we ever want it for anything other than
> writes?

I don't know if it actually is slower when pages need to be faulted
in, but I'm fine turning it into a write-only function.

Thanks,
Andreas

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
