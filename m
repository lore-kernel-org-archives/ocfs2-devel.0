From: Coly Li <coly.li@suse.de>
Date: Fri, 13 Feb 2009 14:24:16 +0800
Subject: [Ocfs2-devel] mount point is not unique among all nodes
In-Reply-To: <20090212224347.GC12965@mail.oracle.com>
References: <499481EF.40609@suse.de> <20090212221740.GB12965@mail.oracle.com>
	<20090212224347.GC12965@mail.oracle.com>
Message-ID: <49951210.40106@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker Wrote:
> On Thu, Feb 12, 2009 at 02:17:40PM -0800, Joel Becker wrote:
>> On Fri, Feb 13, 2009 at 04:09:19AM +0800, Coly Li wrote:
>>> Hi list,
>>>
>>> Here is a bug report on novell bugzilla (https://bugzilla.novell.com/show_bug.cgi?id=456280) that
>>> mount point inside node A can be removed from node B.
>> 	Can't access the bug.
>>
>>> The problem is, node B does not know an empty dir is be using as mount point on another node. Is
>>> there any solution to return -EBUSY when a dir is be using as mount point on another node ?
>> 	This is a good question.  As of right now, we don't have a way
>> to do it.
> 
> 	Sunil and I took a look.  It would seem we need to mark the
> dentry lock LVB with a mountpoint count.  That way, ocfs2_unlink() could
> check that right before calling ocfs2_remote_dentry_delete().
> 	The problem is that the VFS doesn't notify us when one of our
> directories is mounted over.  Somewhere in do_add_mount() it would need
> to tell ocfs2 about it, so that ocfs2 could take the EX on the dentry
> lock and bump the mount count in the LVB.
> 	So, that's what we'll do when we get around to it.  I don't
> think it's a high priority; we haven't actually run into this until now.
> 
I filed a bug on oracle oss bugzilla, see
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1075

I will continue to follow this issue. Thanks for the feedback.

-- 
Coly Li
SuSE Labs
