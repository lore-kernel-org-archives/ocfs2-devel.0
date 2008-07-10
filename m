From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 10 Jul 2008 12:30:25 +0800
Subject: [Ocfs2-devel] [PATCH 06/15] Add extent tree operation for xattr
 value.v2
In-Reply-To: <20080709231014.GL28100@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<20080627070127.GA20352@tma-pc2.cn.oracle.com>
	<20080709231014.GL28100@wotan.suse.de>
Message-ID: <48759061.9090706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Fri, Jun 27, 2008 at 03:01:27PM +0800, Tao Ma wrote:
>> In Mark's review, he said "wouldn't it make sense to have a couple high-level
>> "ocfs2_foo_insert_extent" functions whcih build up anm ocfs2_extent_tree and
>> then pass it down to the common ocfs2_insert_extent?". But in this patch, I
>> still don't remove the "private" from the parameter. because there are too
>> many functions use "private". So if we use an "ocfs2_extent_tree" in
>> ocfs2_insert_extent, we should also modify ocfs2_lock_allocators,
>> ocfs2_num_free_extents etc. They are spread widely in ocfs2 source code, and I
>> don't want to let ocfs2_extent_tree known by every caller since it should be
>> totally limited to the tree code itself. Mark, any suggestions here?
> 
> I kind of liked what you had come to already:
> 
> http://oss.oracle.com/pipermail/ocfs2-devel/2008-June/002332.html
> 
> 
> I only meant that we should have some thin wrappers around
> ocfs2_insert_extent. We can leave the other functions as-is for now until we
> have time to figure out how to make it nicer.
> 
> Does that make sense to you?
OK, a deal.

Regards,
Tao
