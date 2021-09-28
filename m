Return-Path: <SRS0=SdAF=OS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C39C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 16:46:14 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0FE761262
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Sep 2021 16:46:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E0FE761262
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SGUiSW002402;
	Tue, 28 Sep 2021 16:46:13 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bbejejrmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Sep 2021 16:46:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SGe9mu105383;
	Tue, 28 Sep 2021 16:46:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bc3ccuq3g-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 28 Sep 2021 16:46:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVGC3-0000ac-F6; Tue, 28 Sep 2021 09:42:59 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <willy@infradead.org>) id 1mVGBz-0000aC-Sh
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 09:42:55 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18SGe8Go105310
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 16:42:55 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3bc3ccujw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 16:42:51 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18SECCpv015115
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 16:42:49 GMT
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bc4kdtnyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 16:42:49 +0000
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mVG76-00B1nC-Up; Tue, 28 Sep 2021 16:38:06 +0000
Date: Tue, 28 Sep 2021 17:37:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YVNE4HGKPb7bw+En@casper.infradead.org>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-4-agruenba@redhat.com>
	<CAL3q7H7PdBTuK28tN=3fGUyTP9wJU8Ydrq35YtNsfA_3xRQhzQ@mail.gmail.com>
	<CAHc6FU7rbdJxeuvoz0jov5y_GH_B4AtjkDnbNyOxeeNc1Zw5+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7rbdJxeuvoz0jov5y_GH_B4AtjkDnbNyOxeeNc1Zw5+A@mail.gmail.com>
X-Source-IP: 90.155.50.34
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	spamscore=0 mlxscore=0
	phishscore=0 priorityscore=158 clxscore=322 lowpriorityscore=0
	suspectscore=0 bulkscore=0 mlxlogscore=598 impostorscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109280097
X-Spam: Clean
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        fdmanana@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 03/19] gup: Turn
 fault_in_pages_{readable, writeable} into fault_in_{readable, writeable}
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280097
X-Proofpoint-GUID: _8Y7FS8kRZ86ml38m6zFACWWylcji_HH
X-Proofpoint-ORIG-GUID: _8Y7FS8kRZ86ml38m6zFACWWylcji_HH

On Tue, Sep 28, 2021 at 05:02:43PM +0200, Andreas Gruenbacher wrote:
> On Fri, Sep 3, 2021 at 4:57 PM Filipe Manana <fdmanana@gmail.com> wrote:
> > On Fri, Aug 27, 2021 at 5:52 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> > > +size_t fault_in_writeable(char __user *uaddr, size_t size)
> > > +{
> > > +       char __user *start = uaddr, *end;
> > > +
> > > +       if (unlikely(size == 0))
> > > +               return 0;
> > > +       if (!PAGE_ALIGNED(uaddr)) {
> > > +               if (unlikely(__put_user(0, uaddr) != 0))
> > > +                       return size;
> > > +               uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
> > > +       }
> > > +       end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
> > > +       if (unlikely(end < start))
> > > +               end = NULL;
> > > +       while (uaddr != end) {
> > > +               if (unlikely(__put_user(0, uaddr) != 0))
> > > +                       goto out;
> > > +               uaddr += PAGE_SIZE;
> >
> > Won't we loop endlessly or corrupt some unwanted page when 'end' was
> > set to NULL?
> 
> What do you mean? We set 'end' to NULL when start + size < start
> exactly so that the loop will stop when uaddr wraps around.

But think about x86-64.  The virtual address space (unless you have 5
level PTs) looks like:

[0, 2^47)		userspace
[2^47, 2^64 - 2^47)	hole
[2^64 - 2^47, 2^64)	kernel space

If we try to copy from the hole we'll get some kind of fault (I forget
the details).  We have to stop at the top of userspace.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
