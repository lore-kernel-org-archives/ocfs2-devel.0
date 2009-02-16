From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 16 Feb 2009 15:38:58 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two fixes for xattr  -v2
Message-ID: <49991812.3090005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I have fixed the problems in version 1 patches. These two patches based 
on the latest main line kernel.

Thanks,
tiger

> For EAs data structure in inode/block are little different from them in
> bucket. These two patches try to make them same for the most part.
> 
> The first patch set xh_free_start and xh_name_value_len when EAs in
> inode/block. xh_free_start is useful to keep the minimum offset of the
> xattr name/value. But xh_name_value_len is not very useful because we 
> don't have "hole" when EAs in inode/block, we just calculate and set it 
> here, maybe it's useful for fsck.
> 
> The second patch reserve a blank space between xattr entry and 
> name/value when EAs in bucket. This is same as EAs in inode/block and is 
> useful in fsck.
