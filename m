Return-Path: <SRS0=89/6=MT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0186CC4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Jul 2021 09:34:05 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9906260F90
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Jul 2021 09:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9906260F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R9We51021768;
	Tue, 27 Jul 2021 09:34:02 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a23589agf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 09:34:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R9UpsT108957;
	Tue, 27 Jul 2021 09:33:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a234v59e4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 27 Jul 2021 09:33:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m8JQG-0006ca-7s; Tue, 27 Jul 2021 02:30:48 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <david.laight@aculab.com>) id 1m8JPg-0006bS-OA
	for ocfs2-devel@oss.oracle.com; Tue, 27 Jul 2021 02:30:12 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16R9Fhes108846
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 09:30:12 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3a234a39bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 09:30:09 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16R9HsBl029693
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 09:30:08 GMT
Received: from eu-smtp-delivery-151.mimecast.com
	(eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a2367xygf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 27 Jul 2021 09:30:08 +0000
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	uk-mta-70-ms7TCF98MzyTiP7ml5G1wg-1; Tue, 27 Jul 2021 10:30:03 +0100
X-MC-Unique: ms7TCF98MzyTiP7ml5G1wg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
	AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft
	SMTP Server (TLS) id 15.0.1497.23; Tue, 27 Jul 2021 10:30:02 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
	AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
	15.00.1497.023; Tue, 27 Jul 2021 10:30:02 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Linus Torvalds' <torvalds@linux-foundation.org>,
        Andreas Gruenbacher
	<agruenba@redhat.com>
Thread-Topic: [PATCH v4 1/8] iov_iter: Introduce iov_iter_fault_in_writeable
	helper
Thread-Index: AQHXgMWAppW/hO87w0mGvb576BwgJqtWjhtg
Date: Tue, 27 Jul 2021 09:30:02 +0000
Message-ID: <03e0541400e946cf87bc285198b82491@AcuMS.aculab.com>
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
In-Reply-To: <CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
X-Source-IP: 185.58.85.151
X-ServerName: eu-smtp-delivery-151.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:eu._netblocks.mimecast.com
	include:servers.mcsv.net
	include:_spf.act-on.net include:aculabcloud.net -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	mlxlogscore=999
	clxscore=270 priorityscore=0 adultscore=0 lowpriorityscore=0
	impostorscore=0 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107270054
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	phishscore=0
	suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107270054
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270055
X-Proofpoint-GUID: hQAfcnpfZOQ2tMI0G0Zb9wdpzdbrFVIG
X-Proofpoint-ORIG-GUID: hQAfcnpfZOQ2tMI0G0Zb9wdpzdbrFVIG

From: Linus Torvalds
> Sent: 24 July 2021 20:53
> 
> On Sat, Jul 24, 2021 at 12:35 PM Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
> >
> > +int iov_iter_fault_in_writeable(const struct iov_iter *i, size_t bytes)
> > +{
> ...
> > +                       if (fault_in_user_pages(start, len, true) != len)
> > +                               return -EFAULT;
> 
> Looking at this once more, I think this is likely wrong.
> 
> Why?
> 
> Because any user can/should only care about at least *part* of the
> area being writable.
> 
> Imagine that you're doing a large read. If the *first* page is
> writable, you should still return the partial read, not -EFAULT.

My 2c...

Is it actually worth doing any more than ensuring the first byte
of the buffer is paged in before entering the block that has
to disable page faults?

Most of the all the pages are present so the IO completes.

The pages can always get unmapped (due to page pressure or
another application thread unmapping them) so there needs
to be a retry loop.
Given the cost of actually faulting in a page going around
the outer loop may not matter.
Indeed, if an application has just mmap()ed in a very large
file and is then doing a write() from it then it is quite
likely that the pages got unmapped!

Clearly there needs to be extra code to ensure progress is made.
This might actually require the use of 'bounce buffers'
for really problematic user requests.

I also wonder what actually happens for pipes and fifos.
IIRC reads and write of up to PIPE_MAX (typically 4096)
are expected to be atomic.
This should be true even if there are page faults part way
through the copy_to/from_user().

It has to be said I can't see any reference to PIPE_MAX
in the linux man pages, but I'm sure it is in the POSIX/TOG
spec.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
