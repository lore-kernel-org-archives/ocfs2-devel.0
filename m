From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 25 Jul 2008 16:56:04 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2-tools: Add extended attribute
 support in fsck.ocfs2
In-Reply-To: <48898644.9090307@oracle.com>
References: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
	<1216969599-9280-2-git-send-email-tiger.yang@oracle.com>
	<48898644.9090307@oracle.com>
Message-ID: <48899524.3050805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Tao Ma wrote:

>> +static inline int ocfs2_xattr_extent_recs_per_inode(int blocksize)
>> +{
>> +    int size;
>> +
>> +    size = blocksize - offsetof(struct ocfs2_xattr_block,
>> +                    xb_attrs.xb_root.xt_list.l_recs);
>> +
>> +    return (size / sizeof(struct ocfs2_extent_rec));
>> +}
> I remember with 512, there is no xattr in inode.

This function only used in index block, it's not for inode block.

>> +    for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
> no le16_to_cpu in tools. there are also some below, please remove them.

ok.

>> +        ret = io_read_block(ost->ost_fs->fs_io, blkno, block_num, bhs);
> bucket size isn't block size. So you can't just read and handle the 
> first block for a bucket. the same for the write.

So I read block_num blocks not first block.


>> +    if (di->i_dyn_features & OCFS2_HAS_XATTR_FL) {
> you mean inline_xattr here?

my fault. I mean OCFS2_INLINE_XATTR_FL.


>> +    if (!(xb->xb_flags & OCFS2_XATTR_INDEXED)) {
> you should handle xb_flags swap first.
ok.

Thanks for review.

tiger
