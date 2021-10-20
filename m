Return-Path: <SRS0=sznG=PI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A97C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 16:26:03 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0CD161260
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 16:26:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D0CD161260
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KG8qQN000775;
	Wed, 20 Oct 2021 16:26:02 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkw4s56h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Oct 2021 16:26:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGBY6O103771;
	Wed, 20 Oct 2021 16:25:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gue5r2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 20 Oct 2021 16:25:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdEPe-0003Xs-Fj; Wed, 20 Oct 2021 09:25:58 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mdEPE-0003X2-Lm
	for ocfs2-devel@oss.oracle.com; Wed, 20 Oct 2021 09:25:32 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGAsxp014727
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 16:25:32 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3bqmsgq7d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 16:25:32 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19KC6RFV018848
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 16:25:31 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bt9gqj5kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 16:25:31 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5849611F2;
	Wed, 20 Oct 2021 16:25:27 +0000 (UTC)
Date: Wed, 20 Oct 2021 17:25:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Message-ID: <YXBC9LRwhgFCHqJA@arm.com>
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<20211019134204.3382645-6-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211019134204.3382645-6-agruenba@redhat.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 05/17] iov_iter: Introduce
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200091
X-Proofpoint-GUID: KihfDBbcNJhzTJmlfJqTwKHqx5A0WCoe
X-Proofpoint-ORIG-GUID: KihfDBbcNJhzTJmlfJqTwKHqx5A0WCoe

On Tue, Oct 19, 2021 at 03:41:52PM +0200, Andreas Gruenbacher wrote:
> diff --git a/mm/gup.c b/mm/gup.c
> index a7efb027d6cf..614b8536b3b6 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1691,6 +1691,69 @@ size_t fault_in_writeable(char __user *uaddr, size_t size)
>  }
>  EXPORT_SYMBOL(fault_in_writeable);
>  
> +/*
> + * fault_in_safe_writeable - fault in an address range for writing
> + * @uaddr: start of address range
> + * @size: length of address range
> + *
> + * Faults in an address range using get_user_pages, i.e., without triggering
> + * hardware page faults.  This is primarily useful when we already know that
> + * some or all of the pages in the address range aren't in memory.
> + *
> + * Other than fault_in_writeable(), this function is non-destructive.
> + *
> + * Note that we don't pin or otherwise hold the pages referenced that we fault
> + * in.  There's no guarantee that they'll stay in memory for any duration of
> + * time.
> + *
> + * Returns the number of bytes not faulted in, like copy_to_user() and
> + * copy_from_user().
> + */
> +size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
> +{
> +	unsigned long start = (unsigned long)uaddr;
> +	unsigned long end, nstart, nend;
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma = NULL;

For arm64 tagged addresses we need the diff below, otherwise the
subsequent find_vma() will fail:

diff --git a/mm/gup.c b/mm/gup.c
index f5f362cb4640..2c51e9748a6a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1713,7 +1713,7 @@ EXPORT_SYMBOL(fault_in_writeable);
  */
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 {
-	unsigned long start = (unsigned long)uaddr;
+	unsigned long start = (unsigned long)untagged_addr(uaddr);
 	unsigned long end, nstart, nend;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
