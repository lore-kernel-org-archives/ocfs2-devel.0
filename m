From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 4 Aug 2008 14:34:04 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add extended attribute support
	v3
In-Reply-To: <489187C8.7030708@oracle.com>
References: <20080725215755.GH28014@wotan.suse.de>
	<489187C8.7030708@oracle.com>
Message-ID: <20080804213404.GO28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 31, 2008 at 05:37:12PM +0800, Tiger Yang wrote:
> Mark Fasheh wrote:
> >The thing is, the locking as you have it here isn't protecting against
> >racing a data write, which is reading l_count on the extent list (or 
> >id_count on
> >inline data) and an xattr write which might want to shrink those. You'll
> >need at least ip_alloc_sem around those, since ocfs2_page_mkwrite() doesn't
> >take i_mutex because it doesn't want to deadlock against the mmap
> >semaphore.
> Thanks, You point out a potential bug in my patch. I didn't protect
> reading/writing xattr against file data.
> 
> My patch check l_count/id_count in ocfs2_xattr_has_space_inline() and
> may change it in ocfs2_xattr_ibody_set().
> is patch attached fix this problem?


In order to protect against mmap changing the inline data state, you should
hold a write lock on ip_alloc_sem across the call to ocfs2_xattr_ibody_find()
and until the return from ocfs2_xattr_set_entry.

So basically, ocfs2_xattr_set() should look like:

...
down_write(&oi->ip_alloc_sem);
ocfs2_ibody_find();
...
ocfs2_xattr_set_entry();
up_write(&oi->ip_alloc_sem);
...


This way mmap can't change inline data state in between the calls to
ibody_find and xattr_set_entry.

By the way, are operations that change or add xattrs protected by i_mutex?
It looks like we might want that too.


> >Or are you trying to protect xattr against itself? If that's the case, you
> >could push this lock up to the top and take it around entire operations.
> Actually I am trying to protect xattr read/write by this semaphore,
> since we found a bug about it.
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=990
> 
> So I need change comment about xattr semaphore.
> /* protects extended attribute change on this inode */

You could, or how about we just take i_mutex at the top of our xattr
operations for now? If we need the extra performance that more complicated
locking gives us, we can add this later.
	--Mark

--
Mark Fasheh
