Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E78C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 21:35:58 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 082056056B
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 21:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 082056056B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RKiEOM024915;
	Fri, 27 Aug 2021 21:35:57 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4xv4j1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 21:35:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RLZc5U069429;
	Fri, 27 Aug 2021 21:35:55 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb92tv73-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 21:35:55 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJjSv-0000Sy-QX; Fri, 27 Aug 2021 14:32:45 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1mJjSs-0000SX-J1
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 14:32:42 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RLFPKu020419
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:32:42 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3aq5yy5fuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:32:42 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RFk1PZ019530
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:32:41 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq2ymk8t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:32:40 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EB3C60F58;
	Fri, 27 Aug 2021 21:32:39 +0000 (UTC)
Date: Fri, 27 Aug 2021 14:32:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <20210827213239.GH12597@magnolia>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-17-agruenba@redhat.com>
	<20210827183018.GJ12664@magnolia>
	<CAHc6FU44mGza=G4prXh08=RJZ0Wu7i6rBf53BjURj8oyX5Q8iA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU44mGza=G4prXh08=RJZ0Wu7i6rBf53BjURj8oyX5Q8iA@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 mlxscore=0
	phishscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270126
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 16/19] iomap: Add done_before argument
	to iomap_dio_rw
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270127
X-Proofpoint-ORIG-GUID: msp0hbBiSOrgssIkU8pkavnjCj3HqGma
X-Proofpoint-GUID: msp0hbBiSOrgssIkU8pkavnjCj3HqGma

On Fri, Aug 27, 2021 at 10:15:11PM +0200, Andreas Gruenbacher wrote:
> On Fri, Aug 27, 2021 at 8:30 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > On Fri, Aug 27, 2021 at 06:49:23PM +0200, Andreas Gruenbacher wrote:
> > > Add a done_before argument to iomap_dio_rw that indicates how much of
> > > the request has already been transferred.  When the request succeeds, we
> > > report that done_before additional bytes were tranferred.  This is
> > > useful for finishing a request asynchronously when part of the request
> > > has already been completed synchronously.
> > >
> > > We'll use that to allow iomap_dio_rw to be used with page faults
> > > disabled: when a page fault occurs while submitting a request, we
> > > synchronously complete the part of the request that has already been
> > > submitted.  The caller can then take care of the page fault and call
> > > iomap_dio_rw again for the rest of the request, passing in the number of
> > > bytes already tranferred.
> > >
> > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > ---
> > >  fs/btrfs/file.c       |  5 +++--
> > >  fs/ext4/file.c        |  5 +++--
> > >  fs/gfs2/file.c        |  4 ++--
> > >  fs/iomap/direct-io.c  | 11 ++++++++---
> > >  fs/xfs/xfs_file.c     |  6 +++---
> > >  fs/zonefs/super.c     |  4 ++--
> > >  include/linux/iomap.h |  4 ++--
> > >  7 files changed, 23 insertions(+), 16 deletions(-)
> > >
> >
> > <snip to the interesting parts>
> >
> > > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > > index ba88fe51b77a..dcf9a2b4381f 100644
> > > --- a/fs/iomap/direct-io.c
> > > +++ b/fs/iomap/direct-io.c
> > > @@ -31,6 +31,7 @@ struct iomap_dio {
> > >       atomic_t                ref;
> > >       unsigned                flags;
> > >       int                     error;
> > > +     size_t                  done_before;
> > >       bool                    wait_for_completion;
> > >
> > >       union {
> > > @@ -126,6 +127,9 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
> > >       if (ret > 0 && (dio->flags & IOMAP_DIO_NEED_SYNC))
> > >               ret = generic_write_sync(iocb, ret);
> > >
> > > +     if (ret > 0)
> > > +             ret += dio->done_before;
> >
> > Pardon my ignorance since this is the first time I've had a crack at
> > this patchset, but why is it necessary to carry the "bytes copied"
> > count from the /previous/ iomap_dio_rw call all the way through to dio
> > completion of the current call?
> 
> Consider the following situation:
> 
>  * A user submits an asynchronous read request.
> 
>  * The first page of the buffer is in memory, but the following
>    pages are not. This isn't uncommon for consecutive reads
>    into freshly allocated memory.
> 
>  * iomap_dio_rw writes into the first page. Then it
>    hits the next page which is missing, so it returns a partial
>    result, synchronously.
> 
>  * We then fault in the remaining pages and call iomap_dio_rw
>    for the rest of the request.
> 
>  * The rest of the request completes asynchronously.
> 
> Does that answer your question?

No, because you totally ignored the second question:

If the directio operation succeeds even partially and the PARTIAL flag
is set, won't that push the iov iter ahead by however many bytes
completed?

We already finished the IO for the first page, so the second attempt
should pick up where it left off, i.e. the second page.

--D

> Thanks,
> Andreas
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
