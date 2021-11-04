Return-Path: <SRS0=dHVp=PX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFFEC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Nov 2021 18:23:00 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2273261212
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Nov 2021 18:23:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2273261212
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4H9aHc001563;
	Thu, 4 Nov 2021 18:22:59 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c3n8p9hb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Nov 2021 18:22:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IAORi065104;
	Thu, 4 Nov 2021 18:22:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c1khxm6em-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 04 Nov 2021 18:22:57 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mihO4-0003ZW-3I; Thu, 04 Nov 2021 11:22:56 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mihO1-0003Z9-UU
	for ocfs2-devel@oss.oracle.com; Thu, 04 Nov 2021 11:22:54 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4IB75c183734
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Nov 2021 18:22:53 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3c27k92js7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Nov 2021 18:22:53 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A4EvvLw013326
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Nov 2021 18:22:52 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c4hr2jw82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Nov 2021 18:22:51 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A5C161212;
	Thu,  4 Nov 2021 18:22:47 +0000 (UTC)
Date: Thu, 4 Nov 2021 18:22:44 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YYQk9L0D57QHc0gE@arm.com>
References: <20211102122945.117744-1-agruenba@redhat.com>
	<20211102122945.117744-5-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211102122945.117744-5-agruenba@redhat.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, joey.gouly@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@ozlabs.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
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
 definitions=main-2111040071
X-Proofpoint-ORIG-GUID: 783YuOGKFYoug53r1oRtZtBiPjq_jKDH
X-Proofpoint-GUID: 783YuOGKFYoug53r1oRtZtBiPjq_jKDH

On Tue, Nov 02, 2021 at 01:29:32PM +0100, Andreas Gruenbacher wrote:
> Turn iov_iter_fault_in_readable into a function that returns the number
> of bytes not faulted in, similar to copy_to_user, instead of returning a
> non-zero value when any of the requested pages couldn't be faulted in.
> This supports the existing users that require all pages to be faulted in
> as well as new users that are happy if any pages can be faulted in.
> 
> Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
> sure this change doesn't silently break things.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[...]
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ff34f4087f87..4dd5edcd39fd 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3757,7 +3757,7 @@ ssize_t generic_perform_write(struct file *file,
>  		 * same page as we're writing to, without it being marked
>  		 * up-to-date.
>  		 */
> -		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
> +		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
>  			status = -EFAULT;
>  			break;
>  		}

Now that fault_in_iov_iter_readable() returns the number of bytes, we
could change the above test to:

		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {

Assuming we have a pointer 'a', accessible, and 'a + PAGE_SIZE' unmapped:

	write(fd, a + PAGE_SIZE - 1, 2);

can still copy one byte but it returns -EFAULT instead since the second
page is not accessible.

While writing some test-cases for MTE (sub-page faults, 16-byte
granularity), we noticed that reading 2 bytes from 'a + 15' with
'a + 16' tagged for faulting:

	write(fd, a + 15, 2);

succeeds as long as 'a + 16' is not at a page boundary. Checking against
'bytes' above makes this consistent.

The downside is that it's an ABI change though not sure anyone is
relying on it.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
