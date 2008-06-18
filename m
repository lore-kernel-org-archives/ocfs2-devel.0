From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 18 Jun 2008 17:30:21 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
 support. v1
In-Reply-To: <20080617175903.GC28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
	<20080613032230.GW28100@wotan.suse.de>
	<48563EF6.2090203@oracle.com>
	<20080617175903.GC28100@wotan.suse.de>
Message-ID: <4858D5AD.4010405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
>> Go ahead and add a field to record inline xattr size on the inode. For now,
>> if we're going to take some space for inline EA, you will always just set it
>> to osb->s_min_inline_xattr, which is always OCFS2_MIN_XATTR_INLINE_SIZE.
>>
>> So, use osb->s_min_inline_xattr to figure out whether there's enough space
>> in the inode for xattrs and set the initial inode field based on it. But
>> after that, use i_inline_xattr_size (or whatever you call it) to figure out
>> offset to start in the inode from the end of block, how many bytes to scan,
>> etc.
>>
>> The two reasons I think this is a good idea:
>>
>> - The inline xattr data size is explicitely stored on disk, as opposed to
>>   being assumed from a constant stored in memory.
>>
>> - We don't have to rely on the minimum size to stay the same for all inodes on
>>   a file system. If we need to tune defaults, this becomes much easier if
>>   new inodes can just inherit the new value without affecting existing ones.
>>     
Thanks your suggestion, Your idea make me thought more about this.

ocfs2-tools:
1. In mkfs.ocfs2, we set OCFS2_FEATURE_INCOMPAT_XATTR flag in 
ocfs2_super_block->s_feature_incompat.
This flag protect EAs value blocks (clusters) not released by old 
version fsck.ocfs2.
2. In mkfs.ocfs2, we set OCFS2_XATTR_INLINE_SIZE (current is 256) into a 
field in ocfs2_super_block, say s_xattr_inline_size.
3. Tunefs.ocfs2 could set those flag and value on formatted ocfs2 partition.

kernel modules:
OCFS2_FEATURE_INCOMPAT_XATTR flag could prevent old kernel module mount 
ocfs2 file system which already has EAs in it. Because they don't know 
the xattr existed, they may destroy the inline xattr.
We will check OCFS2_FEATURE_INCOMPAT_XATTR flag when we try to set 
xattr. This means we can mount the ocfs2 filesystem which didn't support 
xattr, but can't set xattr in it. Because without 
OCFS2_FEATURE_INCOMPAT_XATTR,  the EAs value blocks could be destroyed 
by fsck.ocfs2.
When we mount the ocfs2 filesystem which formated by new version 
mkfs.ocfs2, our kernel module will set osb->s_xattr_inline_size 
according to the on-disk super block.  I am not sure whether all inode 
in this file system could only use this value for xattr inline? I think 
fixed xattr inline size in one file system can make things simple 
because its convenient for calculate extent record count or inline data 
size. So we can only change this value by tunefs.ocfs2 or mkfs.ocfs2.

Best regards,
tiger
