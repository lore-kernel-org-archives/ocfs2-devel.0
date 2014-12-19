From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 19 Dec 2014 11:37:56 +0800
Subject: [Ocfs2-devel] [patch 09/15] ocfs2: add functions to add and
 remove inode in orphan dir
In-Reply-To: <20141218231859.GV7238@wotan.suse.de>
References: <548f65e2.GaTIVhOoT5YiOhC8%akpm@linux-foundation.org>
	<20141218231859.GV7238@wotan.suse.de>
Message-ID: <54939D94.7040308@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
I much appreciate your pertinent comments on this feature.

The reason we use orphan dir is to make sure allocating blocks and
updating inode size consistent, and this will result an entry in orphan
is not truly deleted one.
To distinguish dio from unlink, we introduce a new dinode flag
OCFS2_DIO_ORPHANED_FL.
So after this change, once unlink and dio happen concurrently, there
may be two kinds of results:
1. On the same node, only one entry will be added with flag
OCFS2_ORPHANED_FL, and flag OCFS2_DIO_ORPHANED_FL will be set and clear
during dio.
2. On different nodes, two entries will be added with each flag
OCFS2_ORPHANED_FL or OCFS2_DIO_ORPHANED_FL.

Since entry name is stringified from blkno and the length is fixed
OCFS2_ORPHAN_NAMELEN, so adding a prefix as you suggested may affect
too much.

On 2014/12/19 7:18, Mark Fasheh wrote:
> Thanks once again for all of this by the way.
> 
> On Mon, Dec 15, 2014 at 02:51:14PM -0800, Andrew Morton wrote:
>> From: Weiwei Wang <wangww631@huawei.com>
>> Subject: ocfs2: add functions to add and remove inode in orphan dir
>>
>> Add functions to add inode to orphan dir and remove inode in orphan dir. 
>> Here we do not call ocfs2_prepare_orphan_dir and ocfs2_orphan_add
>> directly.  Because append O_DIRECT will add inode to orphan two and may
>> result in more than one orphan entry for the same inode.
> 
> Just so I understand -  your problem is that ocfs2_prepare_orphan_dir() will
> EEXIST when it finds the inode already there.
> 
> The solution you have below has a couple problems, stemming from the fact
> that it uses the same name for an inode that is orphaned because of
> nlink == 0 as that of one that is orphaned because it is undergoing direct
> IO.
> 
> Having identical names in a directory is always considered an error, even
> for system directories like the orphan dir. In my honest opinion we should
> not do that here either.
> 
> Instead you could use a prefix for those entries - something like "dio-".
> 
> If you modify ocfs2_prepare_orphan_dir() and __ocfs2_prepare_orphan_dir()
> to pass down an optional prefix which is prepended to the name you don't need a
> special dio prepare function. Then we don't need ocfs2_dio_prepare_orphan_dir()
> any more.
> 
> In fact, the EEXIST check now becomes valid again and you don't need to
> do all that extra work in ocfs2_dio_orphan_add() to figure out whether the
> name is there because of nlink == 0 or we're doing dio (or both!).
> 
> Actually, it really becomes trivial to special case dio in
> ocfs2_orphan_add() so I would suggest just adding a boolean argument and
> doing the bits for dio there, thus allowing us to drop
> ocfs2_dio_orphan_add() too.
> 
> 
> I hope this all helps.
> 	--Mark
> 
> --
> Mark Fasheh
> 
> .
> 
