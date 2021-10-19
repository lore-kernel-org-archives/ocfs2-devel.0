Return-Path: <SRS0=T5gl=PH=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1807C433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:54:25 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 60E58610E7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60E58610E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JEpS7N024422;
	Tue, 19 Oct 2021 15:54:24 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsn7kkmrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 15:54:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFjWYh163552;
	Tue, 19 Oct 2021 15:54:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gsm2bh-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 19 Oct 2021 15:54:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mcrOS-0008TV-0u; Tue, 19 Oct 2021 08:51:12 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mcrOP-0008Sa-3M
	for ocfs2-devel@oss.oracle.com; Tue, 19 Oct 2021 08:51:09 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFjWEs036794
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:08 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bqkuxhvk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:08 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19JFmsET014855
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:07 GMT
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
	[209.85.208.48])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bsd7ket0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 15:51:07 +0000
Received: by mail-ed1-f48.google.com with SMTP id r18so14809981edv.12
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 08:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=M5qLpGOaG+oQiwUY6IZoloZawU2xGFjPWL0KZDD5Sqk=;
	b=LvYwENKOF0zjmXRqEuRh2JXQ3qIlOEBK7IhX37AVpq/XqBBPugqzSgqkAbMU+JMii8
	KI+fjb1xrvk3Z5rgr8dZ2+qa+5+a6N7RrwLR9AHKQ+H18CYy+vUCd5cz8Cr3UlYq7EB3
	mazDewGmVH/ED2Jk6VWwgERw5Ez10eJD0aMps2rUauXAYRnQ0cK6x95nFGkwzVjBDEUj
	LCJGbTd+5590Bcbf2HV76emjZK47Y4GcCrtqFOSRH+EcUD8WpJeASEw0sknMKQE0VeT5
	8isJoTX0FkM7rdCpYURYh/GvpkQLGehP6z2PavGLw+LcXOuFLgmknirzeVen/BL5ft6B
	bqcg==
X-Gm-Message-State: AOAM531shL2p8zHC9Syh3Iwrc+ahsSbUxt+G+Hm1d7Rk3dLACrqIPYf0
	oi33dpg11uJantDuOuQey/SVLLxss9nusDnxYnB36Q==
X-Google-Smtp-Source: ABdhPJw0YazaEogb0JdD+n85z/1zRXjJjdHr6TwzrPYVNPGQWY+3tZHg/Rc68NlFCrcANrgkEVtpFw==
X-Received: by 2002:a17:907:8a27:: with SMTP id
	sc39mr38340418ejc.567.1634658530816; 
	Tue, 19 Oct 2021 08:48:50 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com.
	[209.85.128.54]) by smtp.gmail.com with ESMTPSA id
	h10sm11318551edf.85.2021.10.19.08.48.50
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 19 Oct 2021 08:48:50 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id v127so12566171wme.5
	for <ocfs2-devel@oss.oracle.com>; Tue, 19 Oct 2021 08:48:50 -0700 (PDT)
X-Received: by 2002:a05:6512:398a:: with SMTP id
	j10mr6559053lfu.402.1634658028835; 
	Tue, 19 Oct 2021 08:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
In-Reply-To: <20211019134204.3382645-1-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Oct 2021 05:40:13 -1000
X-Gmail-Original-Message-ID: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
Message-ID: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.208.48
X-ServerName: mail-ed1-f48.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 clxscore=384
	mlxlogscore=999 bulkscore=0 priorityscore=108 adultscore=0
	suspectscore=0
	impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110190094 domainage_hfrom=5418
X-Spam: Clean
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190094
X-Proofpoint-ORIG-GUID: yKT25G8c-V8PGebTtKxhdVaZQUnLpOHV
X-Proofpoint-GUID: yKT25G8c-V8PGebTtKxhdVaZQUnLpOHV

On Tue, Oct 19, 2021 at 3:42 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> From my point of view, the following questions remain:
>
>  * I hope these patches will be merged for v5.16, but what process
>    should I follow for that?  The patch queue contains mm and iomap
>    changes, so a pull request from the gfs2 tree would be unusual.

Oh, I'd much rather get these as one pull request from the author and
from the person that actually ended up testing this.

It might be "unusual", but it's certainly not unheard of, and trying
to push different parts of the series through different maintainers
would just cause lots of extra churn.

Yes, normally I'd expect filesystem changes to have a diffstat that
clearly shows that "yes, it's all local to this filesystem", and when
I see anything else it raises red flags.

But it raises red flags not because it would be wrong to have changes
to other parts, but simply because when cross-subsystem development
happens, it needs to be discussed and cleared with people. And you've
done that.

So I'd take this as one pull request from you. You've been doing the
work, you get the questionable glory of being in charge of it all.
You'll get the blame too ;)

>  * Will Catalin Marinas's work for supporting arm64 sub-page faults
>    be queued behind these patches?  We have an overlap in
>    fault_in_[pages_]readable fault_in_[pages_]writeable, so one of
>    the two patch queues will need some adjustments.

I think that on the whole they should be developed separately, I don't
think it's going to be a particularly difficult conflict.

That whole discussion does mean that I suspect that we'll have to
change fault_in_iov_iter_writeable() to do the "every 16 bytes" or
whatever thing, and make it use an actual atomic "add zero" or
whatever rather than walk the page tables. But that's a conceptually
separate discussion from this one, I wouldn't actually want to mix up
the two issues too much.

Sure, they touch the same code, so there is _that_ overlap, but one is
about "the hardware rules are a-changing" and the other is about
filesystem use of - and expansion of - the things we do. Let's keep
them separate until ready, and then fix up the fallout at that point
(either as a merge resolution, or even partly after-the-fact).

                     Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
