Return-Path: <SRS0=89/6=MT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238BCC4320A
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Jul 2021 17:52:11 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C30F260F4F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Jul 2021 17:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C30F260F4F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RHq55u032551;
	Tue, 27 Jul 2021 17:52:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2358ag5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 17:52:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16RHonaM117123;
	Tue, 27 Jul 2021 17:52:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a234vxfrm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 27 Jul 2021 17:52:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m8RFN-00054O-M3; Tue, 27 Jul 2021 10:52:05 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m8RFH-00053v-IY
	for ocfs2-devel@oss.oracle.com; Tue, 27 Jul 2021 10:51:59 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16RHpYso086633
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 17:51:59 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3a2348ka30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 17:51:58 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16RHSKw1004321
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 17:51:58 GMT
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
	[209.85.208.172])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a235k3rj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 17:51:57 +0000
Received: by mail-lj1-f172.google.com with SMTP id q2so17026766ljq.5
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 10:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=OBk5RRCD2iLIhOK5co1TZE5o+SAQV6EEDJtV9mSx3y4=;
	b=gvAnFpgOQfWYGCVlXhyZS5rVHU27eU3dK5B2aJLqqkd0sGEzEhZADvDuVbG2Y7afIQ
	Xs8sAPMg1/qzVQAx/JmLdiO06EPfINS5YVRl39oXURKrzzUnV6MEbN91pPZS+DdNkBHj
	yA3mIF/kOj7I3QyMqSlj8b5a0Fb7Cacs4d4Z1cuBSv8Q1cYgiO2oNJMv4TrAEsco14P7
	L1us2RPfPBXZQYiJIZuKWWOYStbNTuT98d8vIaCsVfQPZZQiOjsUIh7EYv/VFZyrS9n8
	U14HCIXEtMWfL8wCfx/+OE76E2ZfgwOcTqnZMqTOJNeuKDPZtkNpuwOepzaKRSc9YkMz
	AM9g==
X-Gm-Message-State: AOAM5324fZKjyhkK015Q3Iv6TRoW9WxBPLfwQt1bCxLBk/LozRScg9GS
	2E7w81bOtS6yrth58WdtcXHd7t0uUIwlFGQb99I=
X-Google-Smtp-Source: ABdhPJyhPVtkKqYPpOhTiK4aOYMjyV9H4s3aD3BaG9YlJOvHfzlT0/ADZSysOYCnwJllJZ/I6s5L6Q==
X-Received: by 2002:a2e:868c:: with SMTP id l12mr16651358lji.134.1627408315422;
	Tue, 27 Jul 2021 10:51:55 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com.
	[209.85.208.181])
	by smtp.gmail.com with ESMTPSA id l11sm332561ljc.71.2021.07.27.10.51.54
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 27 Jul 2021 10:51:54 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id x7so16977536ljn.10
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 10:51:54 -0700 (PDT)
X-Received: by 2002:a2e:81c4:: with SMTP id s4mr15961914ljg.251.1627408314168; 
	Tue, 27 Jul 2021 10:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
	<03e0541400e946cf87bc285198b82491@AcuMS.aculab.com>
	<CAHc6FU4N7vz+jfoUSa45Mr_F0Ht0_PXroWoc5UNkMgFmpKLaNw@mail.gmail.com>
In-Reply-To: <CAHc6FU4N7vz+jfoUSa45Mr_F0Ht0_PXroWoc5UNkMgFmpKLaNw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Jul 2021 10:51:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whemWRZRDDvHnesBbTo1hO2qkWkMtGUSfPvEOq7kAfouQ@mail.gmail.com>
Message-ID: <CAHk-=whemWRZRDDvHnesBbTo1hO2qkWkMtGUSfPvEOq7kAfouQ@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.208.172
X-ServerName: mail-lj1-f172.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 priorityscore=0
	suspectscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
	malwarescore=0
	adultscore=0 spamscore=0 clxscore=361 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107270105
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	adultscore=0 suspectscore=0
	malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107270106
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270106
X-Proofpoint-GUID: z1bmoVKxRqVA5IwFoOecqqZHDSm5Fc2j
X-Proofpoint-ORIG-GUID: z1bmoVKxRqVA5IwFoOecqqZHDSm5Fc2j

On Tue, Jul 27, 2021 at 4:14 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> On Tue, Jul 27, 2021 at 11:30 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > Is it actually worth doing any more than ensuring the first byte
> > of the buffer is paged in before entering the block that has
> > to disable page faults?
>
> We definitely do want to process as many pages as we can, especially
> if allocations are involved during a write.

Yeah, from an efficiency standpoint, once you start walking page
tables, it's probably best to just handle as much as you can.

But once you get an error, I don't think it should be "everything is bad".

This is a bit annoying, because while *most* users really just want
that "everything is good", *some* users might just want to handle the
partial success case.

It's why "copy_to/from_user()" returns the number of bytes *not*
written, rather than -EFAULT like get/put_user(). 99% of all users
just want to know "did I write all bytes" (and then checking for a
zero return is a simple and cheap verification of "everything was
ok").

But then very occasionally, you hit a case where you actually want to
know how much of a copy worked. It's rare, but it happens, and the
read/write system calls tend to be the main user of it.

And yes, the fact that "copy_to/from_user()" doesn't return an error
(like get/put_user() does) has confused people many times over the
years. It's annoying, but it's required by those (few) users that
really do want to handle that partial case.

I think this iov_iter_fault_in_readable/writeable() case should do the same.

And no, it's not new to Andreas' patch. iov_iter_fault_in_readable()
is doing the "everything has to be good" thing already.

Which maybe implies that nobody cares about partial reads/writes. Or
it's very very rare - I've seen code that handles page faults in user
space, but it's admittedly been some very special CPU
simulator/emulator checkpointing stuff.

               Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
