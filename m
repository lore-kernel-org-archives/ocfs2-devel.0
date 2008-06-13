From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 13 Jun 2008 11:28:55 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] Add extent tree operation for xattr
 value.v1
In-Reply-To: <20080613025622.GV28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>
	<20080605073437.GA19797@tma-pc2.cn.oracle.com>
	<20080612234412.GR28100@wotan.suse.de>
	<4851D1E8.7020609@oracle.com>
	<20080613025622.GV28100@wotan.suse.de>
Message-ID: <4851E977.4030802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Fri, Jun 13, 2008 at 09:48:24AM +0800, Tao Ma wrote:
>>> Hmm, at this point, wouldn't it make sense to have a couple high-level
>>> "ocfs2_foo_insert_extent" functions whcih build up anm ocfs2_extent_tree 
>>> and
>>> then pass it down to the common ocfs2_insert_extent?
>> Why do we need that? Just to reduce the parameter to one 
>> "ocfs2_extent_tree *"? ;) Any other benefit?
> 
> No, that's mostly what I was concerned with. Well, that and type-checking -
> we don't have to have a void * in ocfs2_insert_extent any more.
Then how about add 3 functions: ocfs2_inode_insert_extent, 
ocfs2_xattr_value_insert_extent and ocfs2_xattr_tree_insert_extent(for 
xattr index btree, and it will show up in the last patch). All the old 
callers in file.c etc will call ocfs2_dinode_insert_extent, while the 
other two handle the xattr issue. And the init of extent tree are 
handled by these functions?

Regards,
Tao
