Return-Path: <SRS0=4BH1=MS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3911C4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 17:45:42 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FBF260F6E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 17:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4FBF260F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QHgc7a018052;
	Mon, 26 Jul 2021 17:45:41 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a1cmb256m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jul 2021 17:45:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QHeglV139175;
	Mon, 26 Jul 2021 17:45:40 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a0vmteh1j-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Jul 2021 17:45:39 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m84fa-0003RD-Qo; Mon, 26 Jul 2021 10:45:38 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1m84fY-0003Qq-KQ
	for ocfs2-devel@oss.oracle.com; Mon, 26 Jul 2021 10:45:36 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16QHfSi2096231
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:45:36 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3a0n2ge9uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:45:36 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QHgnXH017599
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:45:35 GMT
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
	[209.85.166.47])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a1s3t56y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:45:34 +0000
Received: by mail-io1-f47.google.com with SMTP id l18so12855385ioh.11
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 10:45:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=RXwSnNIQEZmueDh7Hmo0XVa2LB3w/lJjS0RH0OP9oKU=;
	b=gbK2+Wko4oTEFMxPibx1G1BgRQVNAJ57cA1ISdRXcYPcayI3TFx2+hMbCyc8CzLhzp
	L/mjsLnx/eAIMXkp0Ogr+EZpDX0OVS/2zQHSZVjBzB3/tWRMYjYcsYqrY3Cc80fWP0b9
	MPUuxoULcLkJ2TGopZlKW1pIT3VRO2Vuo4Okjyg5J85/MBnyOZo2/lwsCTeNLRhqUv9C
	yTzFhaGLbQJCVwgytonE8Vjl83NF6aMlJNVBzeEgvp9oIPrkMRWms3oDy3ui3Qoai2am
	3ElwuWPeX+KIIVFEu3VEeAI4yQ3OC6fMzfohEAbvWJnOZx1YgyjC9N2T3mA9xg5VAooY
	bHog==
X-Gm-Message-State: AOAM532y8+JI1CEuacccpA3SrZQN7hEnFBKYKTTJkxHBr7t7OLiNvHKW
	d77xacJM0QqJSG8x+XVWrfyLbNrEexy+fi/TJM0=
X-Google-Smtp-Source: ABdhPJz8IoohoapCzTkhjbgN/BUi7JeDolcjB7YBaQfSsACTm0uPZpTNt0o6HSskIOcBuaayDUEcJTzlWZkroUqRut4=
X-Received: by 2002:a05:6638:34aa:: with SMTP id
	t42mr17600011jal.128.1627321533430; 
	Mon, 26 Jul 2021 10:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-6-agruenba@redhat.com>
	<20210726171940.GM20621@quack2.suse.cz>
In-Reply-To: <20210726171940.GM20621@quack2.suse.cz>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Mon, 26 Jul 2021 19:45:22 +0200
Message-ID: <CAHpGcMLtQ1=WOT1mTUS4=iWBwHLQ-EBzY=+XuSGJfu4gVPYTLw@mail.gmail.com>
To: Jan Kara <jack@suse.cz>
X-Source-IP: 209.85.166.47
X-ServerName: mail-io1-f47.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	lowpriorityscore=0
	clxscore=285 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
	spamscore=0 suspectscore=0 mlxlogscore=883 priorityscore=347
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000
	definitions=main-2107260103 domainage_hfrom=9479
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260103
Cc: cluster-devel <cluster-devel@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 5/7] iomap: Support restarting direct
 I/O requests after user copy failures
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
Content-Type: multipart/mixed; boundary="===============5768237351945425914=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260103
X-Proofpoint-GUID: p3j71wDWlNNj8oLOWXLt0WZfsn7uXrY8
X-Proofpoint-ORIG-GUID: p3j71wDWlNNj8oLOWXLt0WZfsn7uXrY8

--===============5768237351945425914==
Content-Type: multipart/alternative; boundary="000000000000ef7d3405c80a51a4"

--000000000000ef7d3405c80a51a4
Content-Type: text/plain; charset="UTF-8"

Jan Kara <jack@suse.cz> schrieb am Mo., 26. Juli 2021, 19:21:

> On Fri 23-07-21 22:58:38, Andreas Gruenbacher wrote:
> > In __iomap_dio_rw, when iomap_apply returns an -EFAULT error, complete
> the
> > request synchronously and reset the iterator to the start position.  This
> > allows callers to deal with the failure and retry the operation.
> >
> > In gfs2, we need to disable page faults while we're holding glocks to
> prevent
> > deadlocks.  This patch is the minimum solution I could find to make
> > iomap_dio_rw work with page faults disabled.  It's still expensive
> because any
> > I/O that was carried out before hitting -EFAULT needs to be retried.
> >
> > A possible improvement would be to add an IOMAP_DIO_FAULT_RETRY or
> similar flag
> > that would allow iomap_dio_rw to return a short result when hitting
> -EFAULT.
> > Callers could then retry only the rest of the request after dealing with
> the
> > page fault.
> >
> > Asynchronous requests turn into synchronous requests up to the point of
> the
> > page fault in any case, but they could be retried asynchronously after
> dealing
> > with the page fault.  To make that work, the completion notification
> would have
> > to include the bytes read or written before the page fault(s) as well,
> and we'd
> > need an additional iomap_dio_rw argument for that.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/iomap/direct-io.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index cc0b4bc8861b..b0a494211bb4 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -561,6 +561,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter
> *iter,
> >               ret = iomap_apply(inode, pos, count, iomap_flags, ops, dio,
> >                               iomap_dio_actor);
> >               if (ret <= 0) {
> > +                     if (ret == -EFAULT) {
> > +                             /*
> > +                              * To allow retrying the request, fail
> > +                              * synchronously and reset the iterator.
> > +                              */
> > +                             wait_for_completion = true;
> > +                             iov_iter_revert(dio->submit.iter,
> dio->size);
> > +                     }
> > +
>
> Hum, OK, but this means that if userspace submits large enough write, GFS2
> will livelock trying to complete it? While other filesystems can just
> submit multiple smaller bios constructed in iomap_apply() (paging in
> different parts of the buffer) and thus complete the write?
>

No. First, this affects reads but not writes. We cannot just blindly repeat
writes; when a page fault occurs in the middle of a write, the result will
be a short write. For reads, the plan is to ads a flag to allow
iomap_dio_rw to return a partial result when a page fault occurs.
(Currently, it fails the entire request.) Then we can handle the page fault
and complete the rest of the request.

The changes needed for that are simple on the iomap side, but we need to go
through some gymnastics for handling the page fault without giving up the
glock in the non-contended case. There will still be the potential for
losing the lock and having to re-acquire it, in which case we'll actually
have to repeat the entire read.

Thanks,
Andreas

                                                                Honza
>
> >                       /* magic error code to fall back to buffered I/O */
> >                       if (ret == -ENOTBLK) {
> >                               wait_for_completion = true;
> > --
> > 2.26.3
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>

--000000000000ef7d3405c80a51a4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D=
"gmail_attr">Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&=
gt; schrieb am Mo., 26. Juli 2021, 19:21:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">On Fri 23-07-21 22:58:38, Andreas Gruenbacher wrote:<br>
&gt; In __iomap_dio_rw, when iomap_apply returns an -EFAULT error, complete=
 the<br>
&gt; request synchronously and reset the iterator to the start position.=C2=
=A0 This<br>
&gt; allows callers to deal with the failure and retry the operation.<br>
&gt; <br>
&gt; In gfs2, we need to disable page faults while we&#39;re holding glocks=
 to prevent<br>
&gt; deadlocks.=C2=A0 This patch is the minimum solution I could find to ma=
ke<br>
&gt; iomap_dio_rw work with page faults disabled.=C2=A0 It&#39;s still expe=
nsive because any<br>
&gt; I/O that was carried out before hitting -EFAULT needs to be retried.<b=
r>
&gt; <br>
&gt; A possible improvement would be to add an IOMAP_DIO_FAULT_RETRY or sim=
ilar flag<br>
&gt; that would allow iomap_dio_rw to return a short result when hitting -E=
FAULT.<br>
&gt; Callers could then retry only the rest of the request after dealing wi=
th the<br>
&gt; page fault.<br>
&gt; <br>
&gt; Asynchronous requests turn into synchronous requests up to the point o=
f the<br>
&gt; page fault in any case, but they could be retried asynchronously after=
 dealing<br>
&gt; with the page fault.=C2=A0 To make that work, the completion notificat=
ion would have<br>
&gt; to include the bytes read or written before the page fault(s) as well,=
 and we&#39;d<br>
&gt; need an additional iomap_dio_rw argument for that.<br>
&gt; <br>
&gt; Signed-off-by: Andreas Gruenbacher &lt;<a href=3D"mailto:agruenba@redh=
at.com" target=3D"_blank" rel=3D"noreferrer">agruenba@redhat.com</a>&gt;<br=
>
&gt; ---<br>
&gt;=C2=A0 fs/iomap/direct-io.c | 9 +++++++++<br>
&gt;=C2=A0 1 file changed, 9 insertions(+)<br>
&gt; <br>
&gt; diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c<br>
&gt; index cc0b4bc8861b..b0a494211bb4 100644<br>
&gt; --- a/fs/iomap/direct-io.c<br>
&gt; +++ b/fs/iomap/direct-io.c<br>
&gt; @@ -561,6 +561,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_ite=
r *iter,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_ap=
ply(inode, pos, count, iomap_flags, ops, dio,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_actor);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &lt;=3D =
0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (ret =3D=3D -EFAULT) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * To allow retrying the request, fail<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * synchronously and reset the iterator.=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_completion =3D true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iov_iter_revert(dio-&gt;submit.iter, dio=
-&gt;size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt; +<br>
<br>
Hum, OK, but this means that if userspace submits large enough write, GFS2<=
br>
will livelock trying to complete it? While other filesystems can just<br>
submit multiple smaller bios constructed in iomap_apply() (paging in<br>
different parts of the buffer) and thus complete the write?<br></blockquote=
></div></div><div dir=3D"auto"><br></div><div dir=3D"auto">No. First, this =
affects reads but not writes. We cannot just blindly repeat writes; when a =
page fault occurs in the middle of a write, the result will be a short writ=
e. For reads, the plan is to ads a flag to allow iomap_dio_rw to return a p=
artial result when a page fault occurs. (Currently, it fails the entire req=
uest.) Then we can handle the page fault and complete the rest of the reque=
st.</div><div dir=3D"auto"><br></div><div dir=3D"auto">The changes needed f=
or that are simple on the iomap side, but we need to go through some gymnas=
tics for handling the page fault without giving up the glock in the non-con=
tended case. There will still be the potential for losing the lock and havi=
ng to re-acquire it, in which case we&#39;ll actually have to repeat the en=
tire read.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks,</div>=
<div dir=3D"auto">Andreas</div><div dir=3D"auto"><br></div><div dir=3D"auto=
"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Honza<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* magic error code to fall back to buffered I/O */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (ret =3D=3D -ENOTBLK) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_completion =3D true;<br>
&gt; -- <br>
&gt; 2.26.3<br>
&gt; <br>
-- <br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.com" target=3D"_blank" rel=3D"nore=
ferrer">jack@suse.com</a>&gt;<br>
SUSE Labs, CR<br>
</blockquote></div></div></div>

--000000000000ef7d3405c80a51a4--


--===============5768237351945425914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============5768237351945425914==--

