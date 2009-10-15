From: TaoMa <tao.ma@oracle.com>
Date: Fri, 16 Oct 2009 06:18:49 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2:  Some patches for reflink. v3
In-Reply-To: <20091015092106.GD14500@mail.oracle.com>
References: <4AD691CD.4080400@oracle.com>
	<20091015092106.GD14500@mail.oracle.com>
Message-ID: <4AD79FC9.4090000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Oct 15, 2009 at 11:06:53AM +0800, Tao Ma wrote:
>   
>> 	This patch set integrate the fix for the bug tristan found.
>>     
>
> 	These both look good.  You know, if an inode is inline and has
> no xattrs, ie:
>
> (oi->i_dyn_flags & (OCFS2_HAS_XATTR_FL | OCFS2_HAS_INLINE_DATA_FL)) ==
>   OCFS2_HAS_INLINE_DATA_FL
>
> you can just skip the refcount tree entirely.  Copy the inode.  Reinit
> the security if !preserve.  Call it a day.
>   
yeah, that is also one of the reason I moved complete_reflink out of 
create_reflink_node and insert it into __ocfs2_reflink(patch 1). So if 
we detect the situation you mentioned above, we will just copy the inode 
and then go directly to ocfs2_complete_reflink, both create_reflink_node 
and ocfs2_reflink_xattrs will be skipped. That would be quite easy.
> 	But this is a later optimization.
>   
agree.

Regards,
Tao
