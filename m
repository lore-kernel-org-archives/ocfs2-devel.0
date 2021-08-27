Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDA0C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 18:57:50 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 518E660EFF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 18:57:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 518E660EFF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGR5P0002221;
	Fri, 27 Aug 2021 18:57:49 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr1dee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 18:57:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RItnRU055584;
	Fri, 27 Aug 2021 18:57:47 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm56ehk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 18:57:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJh2w-0002BV-M3; Fri, 27 Aug 2021 11:57:46 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mJh2r-0002BC-34
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 11:57:41 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RItWh4004494
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 18:57:40 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3aq2husxy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 18:57:40 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RGkD5a017398
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 18:57:39 GMT
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
	[209.85.208.176])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq3um1a82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 18:57:39 +0000
Received: by mail-lj1-f176.google.com with SMTP id d16so13122757ljq.4
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 11:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=YxxLEk/XSr4w+re4v3pBg80KnJK57H4H8Qpi3MkYDbY=;
	b=Nk+t1WeL50IV3g+ZKUnlXYqFILS8YDF/+bGuh7C4Bn9FFGR89mFUvZHwenmHff01jH
	U+6xAhgfD7xrJ1D38HE0RBKCc45E49LwuqRiXtDd2r6JFYr7WM9uaUAtgpy9AjTREcHy
	vsSsgZw9b4RixzduzzAD0L+8u+4DCoYgEPLkQ09OY4nVlLuahy6D/9sySFk5UFpsV7IP
	HDAehj19qKV7th77JGoGUSfhE4Z15y2uKctxMEVWuUG/ljDNuEtcMYscFb7x4V0wEtX1
	/Z9e5gJU7+EwtlPDKny/enBscW2ZEanPQ4fREnkuMRc//GsSboZqvpTol73wI8EhWLes
	CFEA==
X-Gm-Message-State: AOAM532LKZt/opDQ1FrnC3qCD2YZ+xgZaFnk2YLCKhGmSTP186WMbyKb
	C2AuCqAH1xwhZmpkOcK104KZp54tK3jouwZl
X-Google-Smtp-Source: ABdhPJxrFiVumj+hatg6wDZGxwxIeALt7z8GbwglCEGSW7LxbeTBCj89BFfpWwwnJEJe59y01KEA9g==
X-Received: by 2002:a05:651c:908:: with SMTP id
	e8mr8851913ljq.507.1630090656498; 
	Fri, 27 Aug 2021 11:57:36 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com.
	[209.85.208.177])
	by smtp.gmail.com with ESMTPSA id i21sm666132lfc.92.2021.08.27.11.57.35
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 27 Aug 2021 11:57:35 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id m4so13085094ljq.8
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 11:57:35 -0700 (PDT)
X-Received: by 2002:a2e:944c:: with SMTP id o12mr8723398ljh.411.1630090655578; 
	Fri, 27 Aug 2021 11:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-5-agruenba@redhat.com>
	<YSk0pAWx7xO/39A6@zeniv-ca.linux.org.uk>
In-Reply-To: <YSk0pAWx7xO/39A6@zeniv-ca.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Aug 2021 11:57:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj8Q6PtnQqamACJU1TWpT4+nr2+YGhVwMTuU=-NJEm5Rg@mail.gmail.com>
Message-ID: <CAHk-=wj8Q6PtnQqamACJU1TWpT4+nr2+YGhVwMTuU=-NJEm5Rg@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Source-IP: 209.85.208.176
X-ServerName: mail-lj1-f176.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	priorityscore=60
	adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
	malwarescore=0 clxscore=356 mlxscore=0 impostorscore=0 spamscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270110
	domainage_hfrom=5365
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	adultscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270110
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270110
X-Proofpoint-GUID: 0cRqS-0G1yjBS2E338-hgOQQxZ0PiF_M
X-Proofpoint-ORIG-GUID: 0cRqS-0G1yjBS2E338-hgOQQxZ0PiF_M

On Fri, Aug 27, 2021 at 11:53 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I really disagree with these calling conventions.  "Number not faulted in"
> is bloody useless

It's what we already have for copy_to/from_user(), so it's actually
consistent with that.

And it avoids changing all the existing tests where people really
cared only about the "everything ok" case.

Andreas' first patch did that changed version, and was ugly as hell.

But if you have a version that avoids the ugliness...

             Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
