From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 22 Dec 2014 09:04:25 +0800
Subject: [Ocfs2-devel] [patch 09/15] ocfs2: add functions to add and
 remove inode in orphan dir
In-Reply-To: <20141219203352.GY7238@wotan.suse.de>
References: <548f65e2.GaTIVhOoT5YiOhC8%akpm@linux-foundation.org>
	<20141218231859.GV7238@wotan.suse.de> <54939D94.7040308@huawei.com>
	<20141219203352.GY7238@wotan.suse.de>
Message-ID: <54976E19.6000202@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/12/20 4:33, Mark Fasheh wrote:
> On Fri, Dec 19, 2014 at 11:37:56AM +0800, Joseph Qi wrote:
>> Hi Mark,
>> I much appreciate your pertinent comments on this feature.
>>
>> The reason we use orphan dir is to make sure allocating blocks and
>> updating inode size consistent, and this will result an entry in orphan
>> is not truly deleted one.
> 
> Right, I got that from the patch. Good idea by the way.
> 
> 
>> To distinguish dio from unlink, we introduce a new dinode flag
>> OCFS2_DIO_ORPHANED_FL.
> 
> Ok, that's also good.
> 
> 
>> So after this change, once unlink and dio happen concurrently, there
>> may be two kinds of results:
>> 1. On the same node, only one entry will be added with flag
>> OCFS2_ORPHANED_FL, and flag OCFS2_DIO_ORPHANED_FL will be set and clear
>> during dio.
>> 2. On different nodes, two entries will be added with each flag
>> OCFS2_ORPHANED_FL or OCFS2_DIO_ORPHANED_FL.
>>
>> Since entry name is stringified from blkno and the length is fixed
>> OCFS2_ORPHAN_NAMELEN, so adding a prefix as you suggested may affect
>> too much.
> 
> No, adding the prefix is much more preferable to intentionally corrupting
> the conents of a directory. That OCFS2_ORPHAN_NAMELEN is a #define does not
> matter, you are free to make it whatever reasonable value fits the name. The
> directory code naturally handles this, whtether the length is
> OCFS2_ORPHAN_NAMELEN or OCFS2_ORPHAN_NAMELEN + PREFIX_NAMELEN.
> 
> Also if you were to run fsck against the file system it will (should) complain
> about having duplciate entries in the orphan dir.
> 
> Aside from the corruption issue, there are usability issues too. Someone
> running "ls //orphan_dir:0000" will not be able to tell whether a name is
> there for dio or nlink==0. If you prefix it, then debugging becomes much
> easier.
> 
Okay, I will try to take your advice and make a change.

> 
> Btw, did you see my note about a readonly superblock flag for this? We're
> going to need to handle backward compatibility too.
Yes. At my first glance, it may need a lot change to support feature ro compat
at my first glance. I need to investigate on it before do the actual change.
Thanks.

> 	--Mark
> 
> --
> Mark Fasheh
> 
> .
> 
