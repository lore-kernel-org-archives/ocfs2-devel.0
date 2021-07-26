Return-Path: <SRS0=4BH1=MS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC1FC4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:34:09 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 47E1D60234
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:34:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 47E1D60234
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QGUdrt032451;
	Mon, 26 Jul 2021 16:34:08 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a1cmb1yp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jul 2021 16:34:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QGUpQx093647;
	Mon, 26 Jul 2021 16:34:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07yvtrgu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Jul 2021 16:34:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m83YL-0000FH-Lh; Mon, 26 Jul 2021 09:34:05 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1m83Xm-0000Dx-BZ
	for ocfs2-devel@oss.oracle.com; Mon, 26 Jul 2021 09:33:30 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16QGVQdk168892
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 16:33:30 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3a0n2gase5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 16:33:30 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16QGWtKL029233
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 16:33:29 GMT
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a1qj5d9yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Jul 2021 16:33:29 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id CC6FE21EE9;
	Mon, 26 Jul 2021 16:33:26 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.100.200.198])
	by relay2.suse.de (Postfix) with ESMTP id B17B5A3C0E;
	Mon, 26 Jul 2021 16:33:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 8CBD81E3B13; Mon, 26 Jul 2021 18:33:26 +0200 (CEST)
Date: Mon, 26 Jul 2021 18:33:26 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <20210726163326.GK20621@quack2.suse.cz>
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-2-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210723205840.299280-2-agruenba@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 195.135.220.28
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	priorityscore=100
	bulkscore=0 mlxlogscore=999 adultscore=0 clxscore=233 mlxscore=0
	spamscore=0 impostorscore=0 malwarescore=0 phishscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260095
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=953
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107260095
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 1/7] iov_iter: Introduce
	fault_in_iov_iter helper
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260095
X-Proofpoint-GUID: 2GXfDHaV4DPovVtTcB4Frr8D5rNunY3i
X-Proofpoint-ORIG-GUID: 2GXfDHaV4DPovVtTcB4Frr8D5rNunY3i

On Fri 23-07-21 22:58:34, Andreas Gruenbacher wrote:
> Introduce a new fault_in_iov_iter helper for manually faulting in an iterator.
> Other than fault_in_pages_writeable(), this function is non-destructive.
> 
> We'll use fault_in_iov_iter in gfs2 once we've determined that the iterator
> passed to .read_iter or .write_iter isn't in memory.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
...
> +unsigned long fault_in_user_pages(unsigned long start, unsigned long len,
> +				  bool write)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma = NULL;
> +	unsigned long end, nstart, nend;
> +	int locked = 0;
> +	int gup_flags;
> +
> +	/*
> +	 * FIXME: Make sure this function doesn't succeed for pages that cannot
> +	 * be accessed; otherwise we could end up in a loop trying to fault in
> +	 * and then access the pages.  (It's okay if a page gets evicted and we
> +	 * need more than one retry.)
> +	 */
> +
> +	/*
> +	 * FIXME: Are these the right FOLL_* flags?
> +	 */

How about the FIXMEs here? I guess we should answer these questions before
merging and remove the comments. Regarding the first FIXME I tend to agree
that if we cannot fault in the first page, we should return the error
rather than returning 0 as you do now. OTOH the caller can check for 0 and
understand there's something wrong going on as well. But the error would be
probably a bit clearer.

> +
> +	gup_flags = FOLL_TOUCH | FOLL_POPULATE;

I don't think FOLL_POPULATE makes sense here. It makes sense only with
FOLL_MLOCK and determines whether mlock(2) should fault in missing pages or
not.

								Honza

> +	if (write)
> +		gup_flags |= FOLL_WRITE;
> +
> +	end = PAGE_ALIGN(start + len);
> +	for (nstart = start & PAGE_MASK; nstart < end; nstart = nend) {
> +		unsigned long nr_pages;
> +		long ret;
> +
> +		if (!locked) {
> +			locked = 1;
> +			mmap_read_lock(mm);
> +			vma = find_vma(mm, nstart);
> +		} else if (nstart >= vma->vm_end)
> +			vma = vma->vm_next;
> +		if (!vma || vma->vm_start >= end)
> +			break;
> +		nend = min(end, vma->vm_end);
> +		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
> +			continue;
> +		if (nstart < vma->vm_start)
> +			nstart = vma->vm_start;
> +		nr_pages = (nend - nstart) / PAGE_SIZE;
> +		ret = __get_user_pages_locked(mm, nstart, nr_pages,
> +					      NULL, NULL, &locked, gup_flags);
> +		if (ret <= 0)
> +			break;
> +		nend = nstart + ret * PAGE_SIZE;
> +	}
> +	if (locked)
> +		mmap_read_unlock(mm);
> +	if (nstart > start)
> +		return min(nstart - start, len);
> +	return 0;
> +}
> +
>  /**
>   * get_dump_page() - pin user page in memory while writing it to core dump
>   * @addr: user address
> -- 
> 2.26.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
