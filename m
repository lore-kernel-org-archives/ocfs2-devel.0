Return-Path: <SRS0=dHVp=PX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C69C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:31:31 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4EBCF61052
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4EBCF61052
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4KOSKI009207;
	Thu, 4 Nov 2021 20:31:30 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8paag8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Nov 2021 20:31:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4KUOYI090718;
	Thu, 4 Nov 2021 20:31:29 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c1khxt5y6-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 04 Nov 2021 20:31:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mijOR-0002Eg-Td; Thu, 04 Nov 2021 13:31:27 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mijOQ-0002EH-8T
	for ocfs2-devel@oss.oracle.com; Thu, 04 Nov 2021 13:31:26 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4KV8kn004212
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Nov 2021 20:31:25 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3c27k987k7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Nov 2021 20:31:25 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A4JRABT008601
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Nov 2021 20:31:24 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c4n3j9cmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Nov 2021 20:31:24 +0000
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
	[209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-407-uWBUItMMO0iEtODx_2VWJQ-1; Thu, 04 Nov 2021 16:31:19 -0400
X-MC-Unique: uWBUItMMO0iEtODx_2VWJQ-1
Received: by mail-wr1-f71.google.com with SMTP id
	w14-20020adfbace000000b001884bf6e902so736330wrg.3
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Nov 2021 13:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=HlUyb94lQB0YUSrmRZ31/WYJ0OQFpRSOr5iyyx2CB+I=;
	b=u4f/DiVzlW5KGa5RMUYCdwvO+2zAHuIDrrxbepxH0Y9St/alErGKLjHvGTSpsgvQx4
	iS5HW+/DE9xafvEjw54YWRmBFq7gbrjZdHsoxy1ZQKgP0unXvwz9M0a2B/z1tpOfNO2p
	YWw7GMcu4U3h2fat/13vBMXAqpRRx4lIrYG6VkQMcpBalSp/DWjh87VluLn7YQPLm8iS
	1rctUZeNgAXMfbwWmdvcj2MLsimpuENj5IUceJY3JRX8QSKv+rn2nmOuxSXo3AoAp2RU
	vCrg07RwkX1T3k5hQ+SE17t8t51k0ixyS6CTF2okXVWoCCyYCS6V8Dm28HzzIczLss7v
	FOYQ==
X-Gm-Message-State: AOAM533HPio5UofmyWpSRsEdTIAy+LVxBgcRzJJXNYlvpcTjl0WDYkvs
	KO/kgitTVFupECU+q5teTy6ey/4cq1SbCVRqyOdIohJ85awC3oYRsZmn8hE8UFQ2DQgaiVDKFRn
	4EhafBvc6BebQ355qD7XyJdE8eCVO5IRUM+l59A==
X-Received: by 2002:a5d:628f:: with SMTP id k15mr55558375wru.363.1636057878438;
	Thu, 04 Nov 2021 13:31:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy1DT2zp9sqf5BtrQx4eQL+9Qk0WkCFqWYvRSY0pAibZ7MAIDeuCyzWc0voG6eZ/QZ2qH8hnGM3VUV2a9qxnY=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr55558351wru.363.1636057878260;
	Thu, 04 Nov 2021 13:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211102122945.117744-1-agruenba@redhat.com>
	<20211102122945.117744-5-agruenba@redhat.com>
	<YYQk9L0D57QHc0gE@arm.com>
In-Reply-To: <YYQk9L0D57QHc0gE@arm.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 4 Nov 2021 21:31:07 +0100
Message-ID: <CAHc6FU5DsC5C+aOTPX+MV+_49-V_RvyOWKNzcjoVfY=OzEVuAw@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>, joey.gouly@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@ozlabs.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v9 04/17] iov_iter: Turn
	iov_iter_fault_in_readable into fault_in_iov_iter_readable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040080
X-Proofpoint-ORIG-GUID: ZTs38huoi3pW700smJPrllkpMNSv_V-b
X-Proofpoint-GUID: ZTs38huoi3pW700smJPrllkpMNSv_V-b

On Thu, Nov 4, 2021 at 7:22 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, Nov 02, 2021 at 01:29:32PM +0100, Andreas Gruenbacher wrote:
> > Turn iov_iter_fault_in_readable into a function that returns the number
> > of bytes not faulted in, similar to copy_to_user, instead of returning a
> > non-zero value when any of the requested pages couldn't be faulted in.
> > This supports the existing users that require all pages to be faulted in
> > as well as new users that are happy if any pages can be faulted in.
> >
> > Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
> > sure this change doesn't silently break things.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> [...]
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index ff34f4087f87..4dd5edcd39fd 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3757,7 +3757,7 @@ ssize_t generic_perform_write(struct file *file,
> >                * same page as we're writing to, without it being marked
> >                * up-to-date.
> >                */
> > -             if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> > +             if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
> >                       status = -EFAULT;
> >                       break;
> >               }
>
> Now that fault_in_iov_iter_readable() returns the number of bytes, we
> could change the above test to:
>
>                 if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
>
> Assuming we have a pointer 'a', accessible, and 'a + PAGE_SIZE' unmapped:
>
>         write(fd, a + PAGE_SIZE - 1, 2);
>
> can still copy one byte but it returns -EFAULT instead since the second
> page is not accessible.
>
> While writing some test-cases for MTE (sub-page faults, 16-byte
> granularity), we noticed that reading 2 bytes from 'a + 15' with
> 'a + 16' tagged for faulting:
>
>         write(fd, a + 15, 2);
>
> succeeds as long as 'a + 16' is not at a page boundary. Checking against
> 'bytes' above makes this consistent.
>
> The downside is that it's an ABI change though not sure anyone is
> relying on it.

The same pattern exists in iomap_write_iter too, of course. In the
very light testing I did for eliminating the pre-faulting, this kind
of change was working fine. I have no performance numbers though.

  https://lore.kernel.org/linux-fsdevel/20211026094430.3669156-1-agruenba@redhat.com/
  https://lore.kernel.org/linux-fsdevel/20211027212138.3722977-1-agruenba@redhat.com/

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
