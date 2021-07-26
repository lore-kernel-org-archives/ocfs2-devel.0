Return-Path: <SRS0=4BH1=MS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D19C432BE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 18:00:53 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B7EE060F6C
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 18:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B7EE060F6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QHphD3001047;
	Mon, 26 Jul 2021 18:00:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a18nftatn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jul 2021 18:00:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QHuhLD004226;
	Mon, 26 Jul 2021 18:00:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a0vmtf8cd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Jul 2021 18:00:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m84uH-0004wT-8j; Mon, 26 Jul 2021 11:00:49 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1m84uF-0004w6-Rs
	for ocfs2-devel@oss.oracle.com; Mon, 26 Jul 2021 11:00:47 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16QHuotq084675
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:00:47 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3a07yvye3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:00:47 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QHqoGI001396
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:00:45 GMT
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a1s3t5b0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 18:00:45 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id DB9711FECC;
	Mon, 26 Jul 2021 18:00:42 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.100.200.198])
	by relay2.suse.de (Postfix) with ESMTP id 9C371A3B84;
	Mon, 26 Jul 2021 18:00:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 67F161E3B13; Mon, 26 Jul 2021 20:00:42 +0200 (CEST)
Date: Mon, 26 Jul 2021 20:00:42 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Message-ID: <20210726180042.GN20621@quack2.suse.cz>
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-8-agruenba@redhat.com>
	<20210726170250.GL20621@quack2.suse.cz>
	<CAHpGcMLOZhZ7tGrY7rcYWUwx12sY884T=eC-Ckna63PBmF=zwA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHpGcMLOZhZ7tGrY7rcYWUwx12sY884T=eC-Ckna63PBmF=zwA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 195.135.220.29
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	lowpriorityscore=0
	clxscore=282 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
	spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=154
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260104
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	bulkscore=0 phishscore=0
	malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260105
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	16QHuotq084675
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260105
X-Proofpoint-GUID: QEPj0C38CXO884jU1kHnhF0lngaRjuXU
X-Proofpoint-ORIG-GUID: QEPj0C38CXO884jU1kHnhF0lngaRjuXU

On Mon 26-07-21 19:50:23, Andreas Gr=FCnbacher wrote:
> Jan Kara <jack@suse.cz> schrieb am Mo., 26. Juli 2021, 19:10:
> =

> > On Fri 23-07-21 22:58:40, Andreas Gruenbacher wrote:
> > > Also disable page faults during direct I/O requests and implement the
> > same kind
> > > of retry logic as in the buffered I/O case.
> > >
> > > Direct I/O requests differ from buffered I/O requests in that they use
> > > bio_iov_iter_get_pages for grabbing page references and faulting in p=
ages
> > > instead of triggering real page faults.  Those manual page faults can=
 be
> > > disabled with the iocb->noio flag.
> > >
> > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > ---
> > >  fs/gfs2/file.c | 34 +++++++++++++++++++++++++++++++++-
> > >  1 file changed, 33 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> > > index f66ac7f56f6d..7986f3be69d2 100644
> > > --- a/fs/gfs2/file.c
> > > +++ b/fs/gfs2/file.c
> > > @@ -782,21 +782,41 @@ static ssize_t gfs2_file_direct_read(struct kio=
cb
> > *iocb, struct iov_iter *to,
> > >       struct file *file =3D iocb->ki_filp;
> > >       struct gfs2_inode *ip =3D GFS2_I(file->f_mapping->host);
> > >       size_t count =3D iov_iter_count(to);
> > > +     size_t written =3D 0;
> > >       ssize_t ret;
> > >
> > > +     /*
> > > +      * In this function, we disable page faults when we're holding =
the
> > > +      * inode glock while doing I/O.  If a page fault occurs, we drop
> > the
> > > +      * inode glock, fault in the pages manually, and then we retry.
> > Other
> > > +      * than in gfs2_file_read_iter, iomap_dio_rw can trigger implic=
it
> > as
> > > +      * well as manual page faults, and we need to disable both kinds
> > > +      * separately.
> > > +      */
> > > +
> > >       if (!count)
> > >               return 0; /* skip atime */
> > >
> > >       gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
> > > +retry:
> > >       ret =3D gfs2_glock_nq(gh);
> > >       if (ret)
> > >               goto out_uninit;
> > >
> > > +     pagefault_disable();
> >
> > Is there any use in pagefault_disable() here? iomap_dio_rw() should not
> > trigger any page faults anyway, should it?
> >
> =

> It can trigger physical page faults when reading from holes.

Aha, good point. Maybe even worth a comment at this site? Thanks for
explanation!

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
