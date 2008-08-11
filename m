From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 11 Aug 2008 10:15:31 +0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: reserve inline space for
 extended attribute
In-Reply-To: <20080811011854.GA21187@wotan.suse.de>
References: <489A94F4.90903@oracle.com>
	<1218093073-8585-1-git-send-email-tiger.yang@oracle.com>
	<20080811011854.GA21187@wotan.suse.de>
Message-ID: <489FA0C3.7060803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
>> @@ -1421,6 +1421,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>  
>>  	osb->slot_num = OCFS2_INVALID_SLOT;
>>  
>> +	osb->s_xattr_inline_size = OCFS2_MIN_XATTR_INLINE_SIZE;
> 
> Why not use the value of i_xattr_inline_size off the super-block inode to
> tell the module how large xattrs should be? That way we could allow users to
> change it in the future.

I change it in the fifth patch.

-	osb->s_xattr_inline_size = OCFS2_MIN_XATTR_INLINE_SIZE;
+	osb->s_xattr_inline_size = le16_to_cpu(
+				di->id2.i_super.s_xattr_inline_size);

This is easy to test patches at the very beginning, since the fifth 
patch need new mkfs.ocfs2 support.

> By the way, regarding sizes. I just realized that the sizes chosen for
> xattrs need to be aligned to 16 byte boundaries (sizeof(struct
> ocfs2_extent_rec)) so we don't waste space in the extent list above them.
> 
> Does that make sense to you? I think we're safe - you chose the value of
> OCFS2_MIN_XATTR_INLINE_SIZE well. A comment above it noting this might be nice though
> so that we don't make a mistake in the future.

yes, I knew it. At first I reserve space for xattr just reduce l_count.
I will add comment for this later.

Best regards,
tiger
