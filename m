Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323FEC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:29:03 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DADC160F44
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:29:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DADC160F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESwv6019331;
	Mon, 13 Sep 2021 14:29:02 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1jkjavaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:29:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DED8QL133798;
	Mon, 13 Sep 2021 14:28:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b0hjtjvsg-1;
	Mon, 13 Sep 2021 14:28:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwz-0004gB-IT; Mon, 13 Sep 2021 07:28:49 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mL4E6-0008D5-LM
	for ocfs2-devel@oss.oracle.com; Tue, 31 Aug 2021 06:54:58 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17VDjrMS173792
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 13:54:58 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3aqxwthtfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 13:54:58 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17VDkjJF032625
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 13:54:57 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3asnm0035p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 31 Aug 2021 13:54:57 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6989E6056B;
	Tue, 31 Aug 2021 13:54:53 +0000 (UTC)
Date: Tue, 31 Aug 2021 14:54:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <YS40qqmXL7CMFLGq@arm.com>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Will Deacon <will@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-GUID: yCgIO1t3ueA_LzRuq6KBMlETMzm8kZiq
X-Proofpoint-ORIG-GUID: yCgIO1t3ueA_LzRuq6KBMlETMzm8kZiq

On Sat, Aug 28, 2021 at 08:28:17PM +0100, Al Viro wrote:
> 	AFAICS, a48b73eca4ce "btrfs: fix potential deadlock in the search ioctl"
> has introduced a bug at least on arm64.
> 
> Relevant bits: in search_ioctl() we have
>         while (1) {
>                 ret = fault_in_pages_writeable(ubuf + sk_offset,
>                                                *buf_size - sk_offset);
>                 if (ret)
>                         break;
> 
>                 ret = btrfs_search_forward(root, &key, path, sk->min_transid);
>                 if (ret != 0) {
>                         if (ret > 0)
>                                 ret = 0;
>                         goto err;
>                 }
>                 ret = copy_to_sk(path, &key, sk, buf_size, ubuf,
>                                  &sk_offset, &num_found);
>                 btrfs_release_path(path);
>                 if (ret)
>                         break;
> 
>         }
> and in copy_to_sk() -
>                 sh.objectid = key->objectid;
>                 sh.offset = key->offset;
>                 sh.type = key->type;
>                 sh.len = item_len;
>                 sh.transid = found_transid;
> 
>                 /*
>                  * Copy search result header. If we fault then loop again so we
>                  * can fault in the pages and -EFAULT there if there's a
>                  * problem. Otherwise we'll fault and then copy the buffer in
>                  * properly this next time through
>                  */
>                 if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
>                         ret = 0;
>                         goto out;
>                 }
> with sk_offset left unchanged if the very first copy_to_user_nofault() fails.
> 
> Now, consider a situation on arm64 where ubuf points to the beginning of page,
> ubuf[0] can be accessed, but ubuf[16] can not (possible with MTE, AFAICS).  We do
> fault_in_pages_writeable(), which succeeds.  When we get to copy_to_user_nofault()
> we fail as soon as it gets past the first 16 bytes.  And we repeat everything from
> scratch, with no progress made, since short copies are treated as "discard and
> repeat" here.

So if copy_to_user_nofault() returns -EFAULT, copy_to_sk() returns 0
(following commit a48b73eca4ce). I think you are right, search_ioctl()
can get into an infinite loop attempting to write to user if the
architecture can trigger faults at smaller granularity than the page
boundary. fault_in_pages_writeable() won't fix it if ubuf[0] is
writable and doesn't trigger an MTE tag check fault.

An arm64-specific workaround would be for pagefault_disable() to disable
tag checking. It's a pretty big hammer, weakening the out of bounds
access detection of MTE. My preference would be a fix in the btrfs code.

A btrfs option would be for copy_to_sk() to return an indication of
where the fault occurred and get fault_in_pages_writeable() to check
that location, even if the copying would restart from an earlier offset
(this requires open-coding copy_to_user_nofault()). An attempt below,
untested and does not cover read_extent_buffer_to_user_nofault():

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ba98e08a029..9e74ba1c955d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2079,6 +2079,7 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 			       size_t *buf_size,
 			       char __user *ubuf,
 			       unsigned long *sk_offset,
+			       unsigned long *fault_offset,
 			       int *num_found)
 {
 	u64 found_transid;
@@ -2143,7 +2144,11 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 		 * problem. Otherwise we'll fault and then copy the buffer in
 		 * properly this next time through
 		 */
-		if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
+		pagefault_disable();
+		ret = __copy_to_user_inatomic(ubuf + *sk_offset, &sh, sizeof(sh));
+		pagefault_enable();
+		*fault_offset = *sk_offset + sizeof(sh) - ret;
+		if (ret) {
 			ret = 0;
 			goto out;
 		}
@@ -2218,6 +2223,7 @@ static noinline int search_ioctl(struct inode *inode,
 	int ret;
 	int num_found = 0;
 	unsigned long sk_offset = 0;
+	unsigned long fault_offset = 0;

 	if (*buf_size < sizeof(struct btrfs_ioctl_search_header)) {
 		*buf_size = sizeof(struct btrfs_ioctl_search_header);
@@ -2244,8 +2250,8 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;

 	while (1) {
-		ret = fault_in_pages_writeable(ubuf + sk_offset,
-					       *buf_size - sk_offset);
+		ret = fault_in_pages_writeable(ubuf + fault_offset,
+					       *buf_size - fault_offset);
 		if (ret)
 			break;

@@ -2256,7 +2262,7 @@ static noinline int search_ioctl(struct inode *inode,
 			goto err;
 		}
 		ret = copy_to_sk(path, &key, sk, buf_size, ubuf,
-				 &sk_offset, &num_found);
+				 &sk_offset, &fault_offset, &num_found);
 		btrfs_release_path(path);
 		if (ret)
 			break;

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
