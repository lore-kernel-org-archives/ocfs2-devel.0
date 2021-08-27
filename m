Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F97C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 21:54:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE5C860F91
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 21:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE5C860F91
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLmtOD025438;
	Fri, 27 Aug 2021 21:54:39 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvgxcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 21:54:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RLnrIw141303;
	Fri, 27 Aug 2021 21:54:37 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm5dhrt-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 21:54:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJjl1-0001Qw-7r; Fri, 27 Aug 2021 14:51:27 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1mJjkq-0001NL-VR
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 14:51:16 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RLjXBA083757
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:51:16 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3aq2hv0qnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:51:16 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RGjwE3018523
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:51:16 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq3up2xdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 21:51:15 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mJjiZ-00GbUU-Au; Fri, 27 Aug 2021 21:48:55 +0000
Date: Fri, 27 Aug 2021 21:48:55 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	lowpriorityscore=0
	phishscore=0 impostorscore=0 spamscore=0 adultscore=0 bulkscore=0
	clxscore=246 suspectscore=0 priorityscore=100 malwarescore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270128
	domainage_hfrom=9157
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	adultscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270128
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 05/19] iov_iter: Introduce
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270129
X-Proofpoint-GUID: giNaINBb3yu_qVcsEhXRlVgZlFSsMvkx
X-Proofpoint-ORIG-GUID: giNaINBb3yu_qVcsEhXRlVgZlFSsMvkx

On Fri, Aug 27, 2021 at 07:37:25PM +0000, Al Viro wrote:
> On Fri, Aug 27, 2021 at 12:33:00PM -0700, Linus Torvalds wrote:
> > On Fri, Aug 27, 2021 at 12:23 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Could you show the cases where "partial copy, so it's OK" behaviour would
> > > break anything?
> > 
> > Absolutely.
> > 
> > For example, i t would cause an infinite loop in
> > restore_fpregs_from_user() if the "buf" argument is a situation where
> > the first page is fine, but the next page is not.
> > 
> > Why? Because __restore_fpregs_from_user() would take a fault, but then
> > fault_in_pages_readable() (renamed) would succeed, so you'd just do
> > that "retry" forever and ever.
> > 
> > Probably there are a number of other places too. That was literally
> > the *first* place I looked at.
> 
> OK...
> 
> Let me dig out the notes from the last time I looked through that area
> and grep around a bit.  Should be about an hour or two.

OK, I've dug it out and rechecked the current mainline.

Call trees:

fault_in_pages_readable()
	kvm_use_magic_page()

Broken, as per mpe.  Relevant part (see <87eeeqa7ng.fsf@mpe.ellerman.id.au> in
your mailbox back in early May for the full story):
|The current code is confused, ie. broken.
...
|We want to check that the mapping succeeded, that the address is
|readable (& writeable as well actually).
...
|diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
...
|-       if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
|+       if (get_kernel_nofault(c, (const char *)KVM_MAGIC_PAGE)) {

	[ppc32]swapcontext()
	[ppc32]debug_setcontext()
	[ppc64]swapcontext()

Same situation in all three - it's going to kill the process if copy-in
fails, so it tries to be gentler about it and treat fault-in failures
as -EFAULT from syscall.  AFAICS, it's pointless, but I would like
comments from ppc folks.  Note that bogus *contents* of the
struct ucontext passed by user is almost certainly going to end up
with segfault; trying to catch the cases when bogus address happens
to point someplace unreadable is rather useless in that situation.

	restore_fpregs_from_user()
The one you've caught; hadn't been there last time I'd checked (back in
April).  Its counterpart in copy_fpstate_to_sigframe() had been, though.

	armada_gem_pwrite_ioctl()
Pointless, along with the access_ok() there - it does copy_from_user()
on that area shortly afterwards and failure of either is not a fast path.
	copy_page_from_iter_iovec()
Will do the right thing on short copy of any kind; we are fine with either
semantics.
	iov_iter_fault_in_readable()
		generic_perform_write()
Any short copy that had not lead to progress (== rejected by ->write_end())
will lead to next chunk shortened accordingly, so ->write_begin() would be
asked to prepare for the amount we expect to be able to copy; ->write_end()
should be fine with that.  Failure to copy anything at all (possible due to
eviction on memory pressure, etc.) leads to retry of the same chunk as the
last time, and that's where we rely on fault-in rejecting "nothing could be
faulted in" case.  That one is fine with partial fault-in reported as success.
		f2fs_file_write_iter()
Odd prealloc-related stuff.  AFAICS, from the correctness POV either variant
of semantics would do, but I'm not sure how if either is the right match
to what they are trying to do there.
		fuse_fill_write_pages()
Similar to generic_perform_write() situation, only simpler (no ->write_end()
counterpart there).  All we care about is failure if nothing could be faulted
in.
		btrfs_buffered_write()
Again, similar to generic_perform_write().  More convoluted (after a short
copy it switches to going page-by-page and getting destination pages uptodate,
which will be equivalent to ->write_end() always accepting everything it's
given from that point on), but it's the same "we care only about failure
to fault in the first page" situation.
		ntfs_perform_write()
Another generic_perform_write() analogue.  Same situation wrt fault-in
semantics.
		iomap_write_actor()
Another generic_perform_write() relative.  Same situation.


fault_in_pages_writeable()
        copy_fpstate_to_sigframe()
Same kind of "retry everything from scratch on short copy" as in the other
fpu/signal.c case.
	[btrfs]search_ioctl()
Broken with memory poisoning, for either variant of semantics.  Same for
arm64 sub-page permission differences, I think.
	copy_page_to_iter_iovec()
Will do the right thing on short copy of any kind; we are fine with either
semantics.

So we have 3 callers where we want all-or-nothing semantics - two in
arch/x86/kernel/fpu/signal.c and one in btrfs.  HWPOISON will be a problem
for all 3, AFAICS...

IOW, it looks like we have two different things mixed here - one that wants
to try and fault stuff in, with callers caring only about having _something_
faulted in (most of the users) and one that wants to make sure we *can* do
stores or loads on each byte in the affected area.

Just accessing a byte in each page really won't suffice for the second kind.
Neither will g-u-p use, unless we teach it about HWPOISON and other fun
beasts...  Looks like we want that thing to be a separate primitive; for
btrfs I'd probably replace fault_in_pages_writeable() with clear_user()
as a quick fix for now...

Comments?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
