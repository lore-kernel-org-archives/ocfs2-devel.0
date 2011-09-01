From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 1 Sep 2011 09:00:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock open_lock immediately
In-Reply-To: <4E5E712E.1000600@oracle.com>
References: <201108260250.p7Q2oQH9017484@acsmt357.oracle.com>
	<4E5D949A.4040802@oracle.com>
	<20110831025154.GA5342@laptop.jp.oracle.com>
	<4E5E712E.1000600@oracle.com>
Message-ID: <20110901010051.GA3623@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-08-31 10:36, Sunil Mushran wrote:
> On 08/30/2011 07:51 PM, Wengang Wang wrote:
> >The test case is simple:
> >in a three-node cluster,
> >1) node A copies kernel tree to ocfs2 volume
> >2) node B and C keeps "ls -R" the tree which is under copying
> >3) after the copy finished, remove the whole tree by "rm -rf xxx" while
> >    Node B and C are still "ls -R"ing.
> >4) stop the "ls -R" on node B/C when "rm" on node A is finished.
> >5) umount all three nodes.
> >There are entries left in orphandirs(could for all slots).
> >Actually copying whole is time consuming, I can hit the problem when copied part
> >of the kernel tree.
> >
> >I confirmed that the cause is "remotely opened" by printing logs.
> >log showed that all the three nodes think "there is other node(s) still opening the inode",
> >so they don't do dinode deletion.
> 
> 
> Fair enough.
> 
> What needs investigating is whether this approach will work in 1.4/1.6
> too. evict_inode() was added later.

The relavent code in 1.4 and 1.6 are the same.
The difference between mainline and 1.4/1.6 is that:

For 1.4/1.6 code, clear_inode(), which calls ocfs2_clear_inode(), is called
inside ocfs2_delete_inode() directly in the end.
For mainline code, function clear_inode() is removed.
ocfs2_clear_inode() is called in ocfs2_evict_inode() after just after ocfs2_delete_inode().

There is no essential difference. So I think it also work for 1.4/1.6 too.

Additionally, I confirmed it works on 1.6 too by testing.

> 
> 
> >Yes, I have also checked into the two functions.
> >I found there is no bad effect to call ocfs2_open_unlock() and
> >ocfs2_simple_drop_lockres() on openlock twice.
> >
> >when ocfs2_inode_unlock() is called in ocfs2_clear_inode again, the holders
> >should be zero already(in the first call), so no confusing to dlm unlock.
> >when ocfs2_mark_lockres_freeing() is called for the second time, the openlock
> >should be with OCFS2_LOCK_FREEING flag already, I don't see problem here.
> >when ocfs2_drop_lock() is called for the second time, flag OCFS2_LOCK_ATTACHED
> >should be cleared already(in first call), so no problem either.
> >Maybe I missed something?
> >
> >Simply removing ocfs2_open_unlock/ocfs2_mark_lockres_freeing from
> >ocfs2_clear_inode() and ocfs2_drop_lock from ocfs2_drop_inode_locks()
> >respectively can introduce problem:
> >
> >For ((inode->i_nlink&&
> >      !(OCFS2_I(inode)->ip_flags&OCFS2_INODE_MAYBE_ORPHANED))
> >case, we still need to call ocfs2_open_unlock() and
> >ocfs2_mark_lockres_freeing() against openlock in ocfs2_clear_inode()
> >and call ocfs2_drop_lock() in ocfs2_drop_inode_locks().
> 
> Good point. No need to add another flag. We may need to add
> some comments to explain this.

Ok. I will do in next drop.

thanks,
wengang.
