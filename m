From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 25 Jul 2008 17:08:03 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2-tools: Add extended attribute
 support in fsck.ocfs2
In-Reply-To: <48899524.3050805@oracle.com>
References: <1216969599-9280-1-git-send-email-tiger.yang@oracle.com>
	<1216969599-9280-2-git-send-email-tiger.yang@oracle.com>
	<48898644.9090307@oracle.com> <48899524.3050805@oracle.com>
Message-ID: <488997F3.9010408@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Tiger Yang wrote:
> 
> Tao Ma wrote:
> 
>>> +static inline int ocfs2_xattr_extent_recs_per_inode(int blocksize)
>>> +{
>>> +    int size;
>>> +
>>> +    size = blocksize - offsetof(struct ocfs2_xattr_block,
>>> +                    xb_attrs.xb_root.xt_list.l_recs);
>>> +
>>> +    return (size / sizeof(struct ocfs2_extent_rec));
>>> +}
>> I remember with 512, there is no xattr in inode.
> 
> This function only used in index block, it's not for inode block.
So could you please rename it as it isn't concerned with inode?

btw, next time please send your patch to ocfs2-tools-devel since it is 
tools' patches.

Regards,
Tao
