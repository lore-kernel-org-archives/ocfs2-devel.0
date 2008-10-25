From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 11:32:16 +0200
Subject: [Ocfs2-devel] mkfs patch for creating filesystem with quota
	files
In-Reply-To: <20081024221022.GB10038@duck.suse.cz>
References: <20081024221022.GB10038@duck.suse.cz>
Message-ID: <20081025093216.GB11804@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat 25-10-08 00:10:22, Jan Kara wrote:
>   Hello,
> 
>   attached is a patch which implements necessary support for
> mkfs so that quota files can be created.
  As Mark pointed to me, the patch missed the libocfs2/quota.c
file. So a fixed patch is attached.
							Honza
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-Implement-quota-support-to-mkfs-and-add-a-few-auxili.patch
Type: text/x-patch
Size: 25685 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081025/480790ed/attachment-0001.bin 
