Return-Path: <SRS0=CWw2=NZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CE8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 19:55:25 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5884D60FD7
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 19:55:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5884D60FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183Ix8ik026104;
	Fri, 3 Sep 2021 19:55:24 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aug2psvnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Sep 2021 19:55:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183Je1jb057139;
	Fri, 3 Sep 2021 19:55:23 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3ate020cxd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 03 Sep 2021 19:55:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mMFES-0001SX-TK; Fri, 03 Sep 2021 12:52:12 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1mMFER-0001SA-7T
	for ocfs2-devel@oss.oracle.com; Fri, 03 Sep 2021 12:52:11 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	183JfnJQ194105
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 19:52:11 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3aufp3r6ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 19:52:11 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	183H1eIK005648
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 19:52:10 GMT
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
	[209.85.166.172])
	by mx0b-00069f01.pphosted.com with ESMTP id 3au5r0nbsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 19:52:09 +0000
Received: by mail-il1-f172.google.com with SMTP id v2so102575ilg.12
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 12:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=JAQwIaNrcj0cnJzSYIM4xoGBJDQtqjvHaX1OMGcrhaI=;
	b=FSFYrSCw6q3N1f/Nsh5OT3Dk6CiCPxZWxVSH44VRqbRbHwfJJy2Pq8+2NwbyFm6Qik
	a71kqUXv7l4Ospav9cKSvnj8AC8JX40TCzDUHoSYDl5zT6kV9rR13M4+KAAmn2XQK+Jb
	7/U0atKjxmCj0coSkVdN3KIpIgf3Hjt4uBt1iygzuCujyIVYYG26bE6xaBOxvNhVi38w
	jbGhIFhuzobBUw/WNJZf8g7AfE+E/pxwD3yjFAF9TIdNew0xh8LgX8cJUZa/8Kl5yA+i
	lY/FSyZPZOkO39NXmdlJx9R3Mq8p+wkNksxwSj+DF6eZLiYixv0pr7+Fp89dtb3RLIy3
	cw9A==
X-Gm-Message-State: AOAM531JNhVZxC8gkXnBNNwVz0jFIEpYE2SQ02K5i6jnaODZFXHg/Swi
	apRFvqnb021PDgBQ5KrRjJH2yRVfUav3h5PO5MM=
X-Google-Smtp-Source: ABdhPJxg0vpZtt5/kAqsmHWcdUOrNEqv2hlMjkG3oqd+ff0a4tQP2bqnb+RfhjFnLpBElRtlUYVJ0RZntSRxiOo862Q=
X-Received: by 2002:a92:c5a7:: with SMTP id r7mr441940ilt.11.1630698728033;
	Fri, 03 Sep 2021 12:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<CAHk-=wiUtyoTWuzroNJQwQDM9GHRXvq4974VL=y8T_3tUxDbkA@mail.gmail.com>
	<CAHc6FU7K0Ho=nH6fCK+Amc7zEg2G31v+gE3920ric3NE4MfH=A@mail.gmail.com>
	<CAHk-=wjUs8qy3hTEy-7QX4L=SyS85jF58eiT2Yq2YMUdTFAgvA@mail.gmail.com>
In-Reply-To: <CAHk-=wjUs8qy3hTEy-7QX4L=SyS85jF58eiT2Yq2YMUdTFAgvA@mail.gmail.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Fri, 3 Sep 2021 21:51:57 +0200
Message-ID: <CAHpGcMJuCRoVU79_fLFCWJ0Yp38A3Uvmnj5_pRtzGyCDro-avg@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Source-IP: 209.85.166.172
X-ServerName: mail-il1-f172.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=358 lowpriorityscore=0
	bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
	clxscore=216 impostorscore=0 adultscore=0 mlxlogscore=999
	suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000 definitions=main-2109030115
X-Spam: Clean
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
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
Content-Type: multipart/mixed; boundary="===============8704846040532488042=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030115
X-Proofpoint-ORIG-GUID: eLPuCzgwgLEWPXt7zrexSCvojuZHQ_RA
X-Proofpoint-GUID: eLPuCzgwgLEWPXt7zrexSCvojuZHQ_RA

--===============8704846040532488042==
Content-Type: multipart/alternative; boundary="0000000000006bac0e05cb1ca288"

--0000000000006bac0e05cb1ca288
Content-Type: text/plain; charset="UTF-8"

Sorry for the HTML post: I'm travelling for the next two weeks and I'll
mostly be in read-only mode. Bob can help out during that time if
necessary, though.

Linus Torvalds <torvalds@linux-foundation.org> schrieb am Fr., 3. Sep.
2021, 18:20:

> On Wed, Sep 1, 2021 at 12:53 PM Andreas Gruenbacher <agruenba@redhat.com>
> wrote:
> >
> > So there's a minor merge conflict between Christoph's iomap_iter
> > conversion and this patch queue now, and I should probably clarify the
> > description of "iomap: Add done_before argument to iomap_dio_rw" that
> > Darrick ran into. Then there are the user copy issues that Al has
> > pointed out. Fixing those will create superficial conflicts with this
> > patch queue, but probably nothing serious.
> >
> > So how should I proceed: do you expect a v8 of this patch queue on top
> > of the current mainline?
>
> So if you rebase for fixes, it's going to be a "next merge window" thing
> again.
>
> Personally, I'm ok with the series as is, and the conflict isn't an
> issue. So I'd take it as is, and then people can fix up niggling
> issues later.
>

That sounds fine to me. We can clarify things as Darrick has suggested in a
separate commit.

Thanks,
Andreas

--0000000000006bac0e05cb1ca288
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>Sorry for the HTML post: I&#39;m travelling for the =
next two weeks and I&#39;ll mostly be in read-only mode. Bob can help out d=
uring that time if necessary, though.<br><br><div class=3D"gmail_quote"><di=
v dir=3D"ltr" class=3D"gmail_attr">Linus Torvalds &lt;<a href=3D"mailto:tor=
valds@linux-foundation.org">torvalds@linux-foundation.org</a>&gt; schrieb a=
m Fr., 3. Sep. 2021, 18:20:<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Wed,=
 Sep 1, 2021 at 12:53 PM Andreas Gruenbacher &lt;<a href=3D"mailto:agruenba=
@redhat.com" target=3D"_blank" rel=3D"noreferrer">agruenba@redhat.com</a>&g=
t; wrote:<br>
&gt;<br>
&gt; So there&#39;s a minor merge conflict between Christoph&#39;s iomap_it=
er<br>
&gt; conversion and this patch queue now, and I should probably clarify the=
<br>
&gt; description of &quot;iomap: Add done_before argument to iomap_dio_rw&q=
uot; that<br>
&gt; Darrick ran into. Then there are the user copy issues that Al has<br>
&gt; pointed out. Fixing those will create superficial conflicts with this<=
br>
&gt; patch queue, but probably nothing serious.<br>
&gt;<br>
&gt; So how should I proceed: do you expect a v8 of this patch queue on top=
<br>
&gt; of the current mainline?<br>
<br>
So if you rebase for fixes, it&#39;s going to be a &quot;next merge window&=
quot; thing again.<br>
<br>
Personally, I&#39;m ok with the series as is, and the conflict isn&#39;t an=
<br>
issue. So I&#39;d take it as is, and then people can fix up niggling<br>
issues later.<br></blockquote></div></div><div dir=3D"auto"><br></div><div =
dir=3D"auto">That sounds fine to me. We can clarify things as Darrick has s=
uggested in a separate commit.</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">Thanks,</div><div dir=3D"auto">Andreas</div></div>

--0000000000006bac0e05cb1ca288--


--===============8704846040532488042==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============8704846040532488042==--

