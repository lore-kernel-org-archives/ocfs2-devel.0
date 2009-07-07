From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 07 Jul 2009 16:46:08 -0400
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <20090622210631.GC3902@mail.oracle.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>	<1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>	<20090622192509.GB3902@mail.oracle.com>
	<4A3FE900.30405@oracle.com> <20090622210631.GC3902@mail.oracle.com>
Message-ID: <4A53B410.3040704@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Jun 22, 2009 at 01:26:40PM -0700, Sunil Mushran wrote:
>> Joel Becker wrote:
>>> On Mon, Jun 22, 2009 at 11:40:07AM -0700, Sunil Mushran wrote:
>>>> Local and Hard-RO mounts do not need orphan scanning.
>>> 	I just realized that we hold the os->os_lock around everything
>>> we do here.  The orphan scan state doesn't need to be atomic_t.
>> No we don't hold it across all ops. In ocfs2_orphan_scan_stop(), we set
>> it inactive before taking the mutex. This allows ocfs2_queue_orphan_scan()
>> to bail out without queuing the tasks. The idea is to prevent umount 
>> slowdown
>> - as much as possible.
> 
> 	It still strikes me as over-optimized, but it was a criticism
> better leveled at the initial patch.  This patch is about local and
> hard-readonly, and it's ready to go.

Hi guys -

There's a problem with this patch that I ran into while testing
2.6.31-rc2. ocfs2_orphan_scan_stop expects that ocfs2_orphan_scan_init
was called. If the mount fails for any reason, ocfs2_dismount_volume
calls ocfs2_orphan_scan_stop. The thing is that ocfs2_dismount_volume
will never get called in that path after ocfs2_orphan_scan_init is
called, so we oops when calling cancel_delayed_work on an uninitialized
work queue.

The attached patch fixes it up.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: ocfs2-orphan-scan-fixup
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090707/92aae00b/attachment.pl 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 257 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090707/92aae00b/attachment.bin 
