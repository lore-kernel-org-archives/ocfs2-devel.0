From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 06 Aug 2008 10:34:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add extended attribute support
	v3
In-Reply-To: <20080804213404.GO28014@wotan.suse.de>
References: <20080725215755.GH28014@wotan.suse.de>
	<489187C8.7030708@oracle.com>
	<20080804213404.GO28014@wotan.suse.de>
Message-ID: <48990DCD.7090804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Mark Fasheh wrote:
> In order to protect against mmap changing the inline data state, you should
> hold a write lock on ip_alloc_sem across the call to ocfs2_xattr_ibody_find()
> and until the return from ocfs2_xattr_set_entry.
> 
> So basically, ocfs2_xattr_set() should look like:
> 
> ...
> down_write(&oi->ip_alloc_sem);
> ocfs2_ibody_find();
> ...
> ocfs2_xattr_set_entry();
> up_write(&oi->ip_alloc_sem);
> ...
> 
> This way mmap can't change inline data state in between the calls to
> ibody_find and xattr_set_entry.

Thanks the guide. I think I have done what your said.
In ocfs2_ibody_find(), I checked the l_count/id_count with readable 
semaphore. And in ocfs2_xattr_set_ibody, I checked it again and follow 
by ocfs2_xattr_set_entry() with writable semaphore. If mmap change 
l_count/id_count between those two function, I still have chance to know 
it. And data in struct ocfs2_xattr_search which filled in 
ocfs2_ibody_find() are not affected by mmap operations.

Best regards,
tiger
