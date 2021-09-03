Return-Path: <SRS0=CWw2=NZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60586C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 18:50:53 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 04D0E6054E
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 18:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 04D0E6054E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183ITXrq024306;
	Fri, 3 Sep 2021 18:50:52 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aug2psr03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Sep 2021 18:50:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183IUaZn147708;
	Fri, 3 Sep 2021 18:50:49 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ate07vrre-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 03 Sep 2021 18:50:49 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mMEDz-0006Hu-Af; Fri, 03 Sep 2021 11:47:39 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mMEDv-0006HU-2K
	for ocfs2-devel@oss.oracle.com; Fri, 03 Sep 2021 11:47:35 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	183ITomF175229
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 18:47:34 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3aufp3p4rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 18:47:34 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	183GAaXl027719
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 18:47:33 GMT
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
	[209.85.208.172])
	by mx0b-00069f01.pphosted.com with ESMTP id 3au37rf530-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 18:47:33 +0000
Received: by mail-lj1-f172.google.com with SMTP id j12so250497ljg.10
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 11:47:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=DxQ+Qr7YPaLGE685i8Qhsb70C5/CP3uq+dG10rbYZ70=;
	b=SKa3SzUUDp11wS2kE+p7ngO3AHn2EZ3b+XVS3bhnAfq0Vb7sD0WKGt8t+hRMZALeGH
	3gN2EqNvirnXVzH2E+X5LYrMJt+nen/WBsXO5FtVMkVu8JMpiUB0bfWZoUA6+VFJu9mT
	cxGnuGebADKhIFSA57ZMJRAlaSibZb4hnL1K6vYkk6WYH1rTaTQmcb2CZfZu0fXhUQIy
	B9PA8sjjJlG0O88KUHfrE59J7+FMztlmMbpEp6FB069EX/zV+iCOgNZySGUa1nZZm1vL
	a68Q9ivX1CxzGA08jKC1fMYN7UIxryfW7zszNhwDbZAVlYRfvZISeXWzqibmE3NKSgAn
	8Sow==
X-Gm-Message-State: AOAM531e12oI19dG0wLL2GwzKd6eTS7P3wf39lS7M/HlOh+3597cM1Zi
	IpOB15IeVOKpuWq+sPYYDhFr97KJr4GgPGE4Hzs=
X-Google-Smtp-Source: ABdhPJxbIoKDtKK8mLDw7Hr6qrzs6idQuPErMK9o/uZxmgZ6po05JThyH0jIBVBCBmQySbHLn2vqGg==
X-Received: by 2002:a2e:804c:: with SMTP id p12mr334096ljg.118.1630694849919; 
	Fri, 03 Sep 2021 11:47:29 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com.
	[209.85.167.47]) by smtp.gmail.com with ESMTPSA id
	bq18sm22309lfb.183.2021.09.03.11.47.28
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 03 Sep 2021 11:47:29 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id z2so172474lft.1
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 11:47:28 -0700 (PDT)
X-Received: by 2002:a05:6512:3987:: with SMTP id
	j7mr269355lfu.280.1630694848707; 
	Fri, 03 Sep 2021 11:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
	<CAHc6FU7K0Ho=nH6fCK+Amc7zEg2G31v+gE3920ric3NE4MfH=A@mail.gmail.com>
	<CAHk-=wjUs8qy3hTEy-7QX4L=SyS85jF58eiT2Yq2YMUdTFAgvA@mail.gmail.com>
	<YTJoqq0fVB+xAB7w@zeniv-ca.linux.org.uk>
In-Reply-To: <YTJoqq0fVB+xAB7w@zeniv-ca.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Sep 2021 11:47:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=whVNs=67KdMg21wxQdKuOJNg2p3d9t6dX-u3Jw+tzxjoQ@mail.gmail.com>
Message-ID: <CAHk-=whVNs=67KdMg21wxQdKuOJNg2p3d9t6dX-u3Jw+tzxjoQ@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Source-IP: 209.85.208.172
X-ServerName: mail-lj1-f172.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=181 mlxscore=0
	adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
	clxscore=313 phishscore=0 malwarescore=0 mlxlogscore=867
	impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000
	definitions=main-2109030110 domainage_hfrom=5372
X-Spam: Clean
Cc: Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, kvm-ppc@vger.kernel.org,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030110
X-Proofpoint-ORIG-GUID: O1Cnqm3i7WXudPFeekycE7nFY1qRowr5
X-Proofpoint-GUID: O1Cnqm3i7WXudPFeekycE7nFY1qRowr5

On Fri, Sep 3, 2021 at 11:28 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, my objections regarding the calling conventions are still there.

So I'm happy to further change the calling conventions, but by now
_that_ part is most definitely a "not this merge window". The need for
that ternary state is still there.

It might go away in the future, but I think that's literally that: a
future cleanup. Not really related to the problem at hand.

              Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
