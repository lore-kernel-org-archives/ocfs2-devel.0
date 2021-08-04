Return-Path: <SRS0=OBPb=M3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5F3C4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed,  4 Aug 2021 15:25:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F97D60EEA
	for <ocfs2-devel@archiver.kernel.org>; Wed,  4 Aug 2021 15:25:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F97D60EEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FLMRG010484;
	Wed, 4 Aug 2021 15:25:39 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7cxn1xub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Aug 2021 15:25:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 174FPPDW154418;
	Wed, 4 Aug 2021 15:25:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a5g9xc5g1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 04 Aug 2021 15:25:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mBIm0-0002s2-UL; Wed, 04 Aug 2021 08:25:36 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mBIlb-0002rC-NN
	for ocfs2-devel@oss.oracle.com; Wed, 04 Aug 2021 08:25:11 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	174FLSTr137394
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 15:25:11 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3a5g9xc4xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 15:25:11 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	174FHh6Z004957
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 15:25:10 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a75yb6gd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 15:25:09 +0000
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
	[209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-496-gLtXxaBOPnujZED8HdIglA-1; Wed, 04 Aug 2021 11:25:07 -0400
X-MC-Unique: gLtXxaBOPnujZED8HdIglA-1
Received: by mail-wm1-f69.google.com with SMTP id
	o67-20020a1ca5460000b0290223be6fd23dso401481wme.1
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 08:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=gYL7WTiLrXdvlISyfYPUBkceFpd6GfwZ8nIKez1uy+s=;
	b=T7oYsPt65OSAfno4phGabGC5Aka88seWxeuR0vYLTldxVQ1t8T60vvHE4xoj8VhGWZ
	89DQndj8YLZ7onSWw5h4/JmY880przibR6U/0jeLeeLY8uMCKXTzedlrpdeHSzpdS5WX
	NkXzL/vrgcm1DHUWnGYyo2ryP5dtx4NkdDjfXhtzmo/+o/HxI0mQwb2sJjB6Bojjc8sM
	xyZ+enw71M3bVuGip6SXE6tbhYprwUe7RSz3c0UueHiHb99pnXNQDKV4gh0NSNb12bhX
	CqXjWWpxWBMcxDEYJwqglQ5cgwQtu2/mGpoWDK4aO3/jRN66UqkL6zigyXdFuIjZ8mzA
	242A==
X-Gm-Message-State: AOAM530FIcO1n2ozXH+28MffcivgCB5kNoK6BWk4PqNkRzS9vugsMl+i
	Mh6YdATgSt3vooMEvKfuA3AmJjpI9Oe5uq4PROnUOBJ2MDcJhdyp30QYGyRnEy8ZaiUhTLL50ms
	m9AOs4luvCwmuE2IsCWBq1yG+m0wKB1xB2AwzoA==
X-Received: by 2002:a05:600c:5108:: with SMTP id
	o8mr146220wms.97.1628090706485; 
	Wed, 04 Aug 2021 08:25:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGPp6F/pqnoLzgNlPa34lpo9Fxz5ei5sfxO6QxFSlOC9E6qS0pKNJg4a4S7jUPOSWKzwWMmB1rxcCP3pTCg+4=
X-Received: by 2002:a05:600c:5108:: with SMTP id
	o8mr146202wms.97.1628090706302; 
	Wed, 04 Aug 2021 08:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<20210803191818.993968-6-agruenba@redhat.com>
In-Reply-To: <20210803191818.993968-6-agruenba@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 4 Aug 2021 17:24:55 +0200
Message-ID: <CAHc6FU7YLUivXXa00dX1=DC1XaYLnh_j3QDvYcRoAji14WAyAQ@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
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
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0 phishscore=0
	spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108040087
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 05/12] iov_iter: Introduce
	fault_in_iov_iter_writeable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040088
X-Proofpoint-GUID: wkDWzn-1y8Zm0thzM5cToYv7BGG8OkKU
X-Proofpoint-ORIG-GUID: wkDWzn-1y8Zm0thzM5cToYv7BGG8OkKU

On Tue, Aug 3, 2021 at 9:18 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> Introduce a new fault_in_iov_iter_writeable helper for safely faulting in an
> iterator for writing.  Uses get_user_pages() to fault in the pages without
> actually writing to them, which would be destructive.
>
> We'll use fault_in_iov_iter_writeable in gfs2 once we've determined that the
> iterator passed to .read_iter isn't in memory.
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  include/linux/pagemap.h |  1 +
>  include/linux/uio.h     |  1 +
>  lib/iov_iter.c          | 41 +++++++++++++++++++++++++++
>  mm/gup.c                | 61 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 104 insertions(+)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 7c9edc9694d9..a629807edb8c 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -737,6 +737,7 @@ extern void add_page_wait_queue(struct page *page, wait_queue_entry_t *waiter);
>   * Fault in userspace address range.
>   */
>  size_t fault_in_writeable(char __user *uaddr, size_t size);
> +size_t fault_in_safe_writeable(const char __user *uaddr, size_t size);
>  size_t fault_in_readable(const char __user *uaddr, size_t size);
>
>  int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 12d30246c2e9..ffa431aeb067 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -120,6 +120,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
>  void iov_iter_advance(struct iov_iter *i, size_t bytes);
>  void iov_iter_revert(struct iov_iter *i, size_t bytes);
>  size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
> +size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t bytes);
>  size_t iov_iter_single_seg_count(const struct iov_iter *i);
>  size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
>                          struct iov_iter *i);
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index c0fa1618561c..4ffc76801eaa 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -471,6 +471,47 @@ size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
>  }
>  EXPORT_SYMBOL(fault_in_iov_iter_readable);
>
> +/*
> + * fault_in_iov_iter_writeable - fault in iov iterator for writing
> + * @i: iterator
> + * @size: maximum length
> + *
> + * Faults in the iterator using get_user_pages(), i.e., without triggering
> + * hardware page faults.  This is primarily useful when we know that some or
> + * all of the pages in @i aren't in memory.
> + *
> + * Returns the number of bytes faulted in, or 0 if no bytes could be faulted in
> + * (i.e., because the address is invalid).
> + *
> + * Always returns the number of avaliable bytes for non-user space iterators.
> + */
> +size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t size)
> +{
> +       if (size > i->count)
> +               size = i->count;
> +
> +       if (iter_is_iovec(i)) {
> +               const struct iovec *p;
> +               size_t bytes = size;
> +               size_t skip;
> +
> +               for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
> +                       size_t len = min(bytes, p->iov_len - skip);
> +                       size_t ret;
> +
> +                       if (unlikely(!len))
> +                               continue;
> +                       ret = fault_in_safe_writeable(p->iov_base + skip, len);
> +                       bytes -= ret;
> +                       if (ret != len)
> +                               break;
> +               }
> +               return size - bytes;
> +       }
> +       return size;
> +}
> +EXPORT_SYMBOL(fault_in_iov_iter_writeable);
> +
>  void iov_iter_init(struct iov_iter *i, unsigned int direction,
>                         const struct iovec *iov, unsigned long nr_segs,
>                         size_t count)
> diff --git a/mm/gup.c b/mm/gup.c
> index d04984d5d93c..7218e27c2481 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1694,6 +1694,67 @@ size_t fault_in_writeable(char __user *uaddr, size_t size)
>  }
>  EXPORT_SYMBOL(fault_in_writeable);
>
> +/**
> + * fault_in_safe_writeable - fault in an address range for writing
> + * @uaddr: start of address range
> + * @size: length of address range
> + *
> + * Faults in an address range using get_user_pages, i.e., without triggering
> + * hardware page faults.  This is primarily useful when we know that some or
> + * all of the pages in the address range aren't in memory.
> + *
> + * Other than fault_in_writeable(), this function is non-destructive.
> + *
> + * Note that we don't pin or otherwise hold the pages referenced that we fault
> + * in.  There's no guarantee that they'll stay in memory for any duration of
> + * time.
> + *
> + * Returns the number of bytes faulted in from @uaddr.
> + */
> +size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
> +{
> +       unsigned long start = (unsigned long)uaddr;
> +       unsigned long end, nstart, nend;
> +       struct mm_struct *mm = current->mm;
> +       struct vm_area_struct *vma = NULL;
> +       int locked = 0;
> +
> +       /* FIXME: Protect against overflow! */
> +
> +       end = PAGE_ALIGN(start + size);
> +       for (nstart = start & PAGE_MASK; nstart < end; nstart = nend) {
> +               unsigned long nr_pages;
> +               long ret;
> +
> +               if (!locked) {
> +                       locked = 1;
> +                       mmap_read_lock(mm);
> +                       vma = find_vma(mm, nstart);
> +               } else if (nstart >= vma->vm_end)
> +                       vma = vma->vm_next;
> +               if (!vma || vma->vm_start >= end)
> +                       break;
> +               nend = min(end, vma->vm_end);
> +               if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> +                       continue;

Shouldn't we disallow read()ing into those kinds of vmas? If we skip
over them here and then the actual write results in -EFAULT, we'll end
up in a loop.

> +               if (nstart < vma->vm_start)
> +                       nstart = vma->vm_start;

Likewise, shouldn't we fail for memory ranges not covered by a vma?

> +               nr_pages = (nend - nstart) / PAGE_SIZE;
> +               ret = __get_user_pages_locked(mm, nstart, nr_pages,
> +                                             NULL, NULL, &locked,
> +                                             FOLL_TOUCH | FOLL_WRITE);
> +               if (ret <= 0)
> +                       break;
> +               nend = nstart + ret * PAGE_SIZE;
> +       }
> +       if (locked)
> +               mmap_read_unlock(mm);
> +       if (nstart > start)
> +               return min(nstart - start, size);
> +       return 0;
> +}
> +EXPORT_SYMBOL(fault_in_safe_writeable);
> +
>  size_t fault_in_readable(const char __user *uaddr, size_t size)
>  {
>         const char __user *start = uaddr, *end;
> --
> 2.26.3
>

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
