Return-Path: <SRS0=CWw2=NZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC2AC433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 15:52:28 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A1F526108E
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 15:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A1F526108E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183DOVr9000337;
	Fri, 3 Sep 2021 15:52:27 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3audq7hkbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Sep 2021 15:52:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183Fa1Dx080329;
	Fri, 3 Sep 2021 15:52:25 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3ate01r3rq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 03 Sep 2021 15:52:25 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mMBUN-00066A-Vt; Fri, 03 Sep 2021 08:52:23 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mMBUM-000657-BR
	for ocfs2-devel@oss.oracle.com; Fri, 03 Sep 2021 08:52:22 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	183Faau5194971
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 15:52:22 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ate07nvcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 15:52:21 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	18397gLq030887
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 15:52:20 GMT
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
	[209.85.208.175])
	by mx0b-00069f01.pphosted.com with ESMTP id 3au7wc9wc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 15:52:20 +0000
Received: by mail-lj1-f175.google.com with SMTP id j12so10235609ljg.10
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 08:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=Kr5rIfOe6Hwe2+y+jDes91fVUZ+f9S7J89384UtJgA8=;
	b=RF9Tho32IT3To6OC9LHlpPqms+E9zgWJn+BB5Ud925PdvLSaAiWLvIQ7hYBAMdbzK6
	WRmpRVDVGZ0x8hdXKguB4zAcGFJZgcaGKIeJbJkdML424CMhIYTNJ6NQxtxqarQ0Ronf
	bbfbxgX/m4grta4p5MCxMkI0a8Jdyp1fqWkGbp6d2e1dGGxuZLP1eYEfJKEnsOGINy3a
	71lM9hMr089H4ReywYm+3ANS8bRpRdku+t9H25i5nBvl02peeYps8IbmEE/LIyeudZMZ
	z2Z4gl+rYgvzf0WemrC1NPUQ7RUDlcKWOwkklHzgZ++vuLaXICHBJBN4Je/x5yZR+CdK
	BtGg==
X-Gm-Message-State: AOAM533dW1v6aDanZ0Q51jcIXqtaqjcHO4Qt8JA9WWgVAKhC0+W5cYkQ
	CmD7f1kw2lYk+1fMjHEZJ6vEzEevu3LBbjdHBFY=
X-Google-Smtp-Source: ABdhPJzZdz6Fi9pnNBvXGq8XLUoQ46eL5QfvCj6lrCwt1AIVytz3id96wO62Ye3Sz6GW4DXgOoAlsA==
X-Received: by 2002:a2e:bf0d:: with SMTP id c13mr3414968ljr.101.1630684337453; 
	Fri, 03 Sep 2021 08:52:17 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com.
	[209.85.167.51])
	by smtp.gmail.com with ESMTPSA id b18sm622391ljk.24.2021.09.03.08.52.16
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 03 Sep 2021 08:52:16 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id t12so12441605lfg.9
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 08:52:16 -0700 (PDT)
X-Received: by 2002:a05:6512:3da5:: with SMTP id
	k37mr3415205lfv.655.1630684336092; 
	Fri, 03 Sep 2021 08:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
	<CAHc6FU7K0Ho=nH6fCK+Amc7zEg2G31v+gE3920ric3NE4MfH=A@mail.gmail.com>
In-Reply-To: <CAHc6FU7K0Ho=nH6fCK+Amc7zEg2G31v+gE3920ric3NE4MfH=A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Sep 2021 08:52:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjUs8qy3hTEy-7QX4L=SyS85jF58eiT2Yq2YMUdTFAgvA@mail.gmail.com>
Message-ID: <CAHk-=wjUs8qy3hTEy-7QX4L=SyS85jF58eiT2Yq2YMUdTFAgvA@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.208.175
X-ServerName: mail-lj1-f175.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	spamscore=0
	impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
	mlxlogscore=999
	priorityscore=0 clxscore=358 adultscore=0 mlxscore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000
	definitions=main-2109030095 domainage_hfrom=5372
X-Spam: Clean
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030095
X-Proofpoint-ORIG-GUID: vD84y5dUT3eu_ID9vfdeSkdiZPYT6DEb
X-Proofpoint-GUID: vD84y5dUT3eu_ID9vfdeSkdiZPYT6DEb

On Wed, Sep 1, 2021 at 12:53 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> So there's a minor merge conflict between Christoph's iomap_iter
> conversion and this patch queue now, and I should probably clarify the
> description of "iomap: Add done_before argument to iomap_dio_rw" that
> Darrick ran into. Then there are the user copy issues that Al has
> pointed out. Fixing those will create superficial conflicts with this
> patch queue, but probably nothing serious.
>
> So how should I proceed: do you expect a v8 of this patch queue on top
> of the current mainline?

So if you rebase for fixes, it's going to be a "next merge window" thing again.

Personally, I'm ok with the series as is, and the conflict isn't an
issue. So I'd take it as is, and then people can fix up niggling
issues later.

But if somebody screams loudly..

             Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
