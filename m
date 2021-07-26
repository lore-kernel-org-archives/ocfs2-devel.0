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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58602C4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 17:50:58 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0758E60F6C
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 17:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0758E60F6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QHfoLr029611;
	Mon, 26 Jul 2021 17:50:57 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a1ktv1wqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jul 2021 17:50:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QHohcc181804;
	Mon, 26 Jul 2021 17:50:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a0vmteqcf-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Jul 2021 17:50:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m84kf-0003oP-0u; Mon, 26 Jul 2021 10:50:53 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <andreas.gruenbacher@gmail.com>) id 1m84ka-0003mp-J7
	for ocfs2-devel@oss.oracle.com; Mon, 26 Jul 2021 10:50:48 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16QHojNH182014
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:50:48 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3a0vmteq25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:50:45 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QHhsc4019246
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:50:36 GMT
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
	[209.85.166.48])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a1teu4fhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 17:50:35 +0000
Received: by mail-io1-f48.google.com with SMTP id y200so13012889iof.1
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 10:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=4wIaZbvL5v7hGiTdfNjMKfL2dbvhUT7p38wFt6cldfc=;
	b=h0EKRjG22+OjQdjZoDktcX1ZB+CSMPfcvqYDEApOAJlkqftgdp5uCFuIJaUSIaPWEV
	Tbo/m2J67fAD1ARQZ2xAJLx99W7JKdpT8JRNohd8CwBn0fs01i7ngKAz/7UQ5mnOe/gE
	09pyczNjtc+7aBEYfhgPEnlXZ3a8tctUgclEFue4fm8SENJfJ8QgM+6vkkmigzkJcaY8
	2geugzaKqIPWRVskuzexPTetWwKJ/rY04ekm1m+IaP96ZG3qqiYykAzvE1oAkWSMlZMO
	rtYnpZxjIryNi9hO3eqF67XJk0pl7akV5OLTllqhzdwpImTxBRYGZBp0DUlHfU9J/JOE
	9nEQ==
X-Gm-Message-State: AOAM531zLYPyRStJSWBNWdmfcmH3Okj/hmoLjMRk0+qjGwBHWFPAfPuU
	sIYigVWchLM9meodKAxQ86wuuLipVMEtjJBhhJ8=
X-Google-Smtp-Source: ABdhPJxJ/w8fZYt2WaXmNWNE8rNuGGfoW5+TMf+djruWRNbSbdyE/XK3mS9eyYkyf9NQoPnT7YwU9BMIejtf2VXE0lo=
X-Received: by 2002:a05:6638:240c:: with SMTP id
	z12mr17383142jat.41.1627321834539; 
	Mon, 26 Jul 2021 10:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-8-agruenba@redhat.com>
	<20210726170250.GL20621@quack2.suse.cz>
In-Reply-To: <20210726170250.GL20621@quack2.suse.cz>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Mon, 26 Jul 2021 19:50:23 +0200
Message-ID: <CAHpGcMLOZhZ7tGrY7rcYWUwx12sY884T=eC-Ckna63PBmF=zwA@mail.gmail.com>
To: Jan Kara <jack@suse.cz>
X-Source-IP: 209.85.166.48
X-ServerName: mail-io1-f48.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	lowpriorityscore=0
	bulkscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
	priorityscore=335 malwarescore=0 clxscore=303 mlxscore=0 spamscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260103
	domainage_hfrom=9479
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 suspectscore=0
	adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260104
Cc: cluster-devel <cluster-devel@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 7/7] gfs2: Fix mmap + page fault
	deadlocks for direct I/O
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
Content-Type: multipart/mixed; boundary="===============8860331939794970429=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260104
X-Proofpoint-ORIG-GUID: CcFyWr6uSI5WD5suXBeEdYS1njq2OHH6
X-Proofpoint-GUID: CcFyWr6uSI5WD5suXBeEdYS1njq2OHH6

--===============8860331939794970429==
Content-Type: multipart/alternative; boundary="000000000000e2111505c80a63de"

--000000000000e2111505c80a63de
Content-Type: text/plain; charset="UTF-8"

Jan Kara <jack@suse.cz> schrieb am Mo., 26. Juli 2021, 19:10:

> On Fri 23-07-21 22:58:40, Andreas Gruenbacher wrote:
> > Also disable page faults during direct I/O requests and implement the
> same kind
> > of retry logic as in the buffered I/O case.
> >
> > Direct I/O requests differ from buffered I/O requests in that they use
> > bio_iov_iter_get_pages for grabbing page references and faulting in pages
> > instead of triggering real page faults.  Those manual page faults can be
> > disabled with the iocb->noio flag.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/gfs2/file.c | 34 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 33 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> > index f66ac7f56f6d..7986f3be69d2 100644
> > --- a/fs/gfs2/file.c
> > +++ b/fs/gfs2/file.c
> > @@ -782,21 +782,41 @@ static ssize_t gfs2_file_direct_read(struct kiocb
> *iocb, struct iov_iter *to,
> >       struct file *file = iocb->ki_filp;
> >       struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
> >       size_t count = iov_iter_count(to);
> > +     size_t written = 0;
> >       ssize_t ret;
> >
> > +     /*
> > +      * In this function, we disable page faults when we're holding the
> > +      * inode glock while doing I/O.  If a page fault occurs, we drop
> the
> > +      * inode glock, fault in the pages manually, and then we retry.
> Other
> > +      * than in gfs2_file_read_iter, iomap_dio_rw can trigger implicit
> as
> > +      * well as manual page faults, and we need to disable both kinds
> > +      * separately.
> > +      */
> > +
> >       if (!count)
> >               return 0; /* skip atime */
> >
> >       gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
> > +retry:
> >       ret = gfs2_glock_nq(gh);
> >       if (ret)
> >               goto out_uninit;
> >
> > +     pagefault_disable();
>
> Is there any use in pagefault_disable() here? iomap_dio_rw() should not
> trigger any page faults anyway, should it?
>

It can trigger physical page faults when reading from holes.

Andreas


>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>

--000000000000e2111505c80a63de
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D=
"gmail_attr">Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&=
gt; schrieb am Mo., 26. Juli 2021, 19:10:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">On Fri 23-07-21 22:58:40, Andreas Gruenbacher wrote:<br>
&gt; Also disable page faults during direct I/O requests and implement the =
same kind<br>
&gt; of retry logic as in the buffered I/O case.<br>
&gt; <br>
&gt; Direct I/O requests differ from buffered I/O requests in that they use=
<br>
&gt; bio_iov_iter_get_pages for grabbing page references and faulting in pa=
ges<br>
&gt; instead of triggering real page faults.=C2=A0 Those manual page faults=
 can be<br>
&gt; disabled with the iocb-&gt;noio flag.<br>
&gt; <br>
&gt; Signed-off-by: Andreas Gruenbacher &lt;<a href=3D"mailto:agruenba@redh=
at.com" target=3D"_blank" rel=3D"noreferrer">agruenba@redhat.com</a>&gt;<br=
>
&gt; ---<br>
&gt;=C2=A0 fs/gfs2/file.c | 34 +++++++++++++++++++++++++++++++++-<br>
&gt;=C2=A0 1 file changed, 33 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c<br>
&gt; index f66ac7f56f6d..7986f3be69d2 100644<br>
&gt; --- a/fs/gfs2/file.c<br>
&gt; +++ b/fs/gfs2/file.c<br>
&gt; @@ -782,21 +782,41 @@ static ssize_t gfs2_file_direct_read(struct kioc=
b *iocb, struct iov_iter *to,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct file *file =3D iocb-&gt;ki_filp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct gfs2_inode *ip =3D GFS2_I(file-&gt;f_=
mapping-&gt;host);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D iov_iter_count(to);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0size_t written =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * In this function, we disable page faults when =
we&#39;re holding the<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * inode glock while doing I/O.=C2=A0 If a page f=
ault occurs, we drop the<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * inode glock, fault in the pages manually, and =
then we retry.=C2=A0 Other<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * than in gfs2_file_read_iter, iomap_dio_rw can =
trigger implicit as<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * well as manual page faults, and we need to dis=
able both kinds<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * separately.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0; /* ski=
p atime */<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0gfs2_holder_init(ip-&gt;i_gl, LM_ST_DEFERRED=
, 0, gh);<br>
&gt; +retry:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D gfs2_glock_nq(gh);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_uninit;=
<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0pagefault_disable();<br>
<br>
Is there any use in pagefault_disable() here? iomap_dio_rw() should not<br>
trigger any page faults anyway, should it?<br></blockquote></div></div><div=
 dir=3D"auto"><br></div><div dir=3D"auto">It can trigger physical page faul=
ts when reading from holes.</div><div dir=3D"auto"><br></div><div dir=3D"au=
to">Andreas</div><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=
=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Honza<br>
-- <br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.com" target=3D"_blank" rel=3D"nore=
ferrer">jack@suse.com</a>&gt;<br>
SUSE Labs, CR<br>
</blockquote></div></div></div>

--000000000000e2111505c80a63de--


--===============8860331939794970429==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============8860331939794970429==--

