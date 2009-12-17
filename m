From: Jun Yang <tiger.yang@oracle.com>
Date: Thu, 17 Dec 2009 17:48:53 +0800
Subject: [Ocfs2-devel] ocfs2: add extent block stealing for ocfs2 v1
In-Reply-To: <4B274325.1050505@oracle.com>
References: <4B2617D0.7060504@oracle.com> <4B274325.1050505@oracle.com>
Message-ID: <4B29FE85.1070704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/15/2009 04:04 PM, Tao Ma wrote:
> alloc_group = osb->osb_inode_alloc_group;
> here, you use the alloc_group which is only used in inode alloc and
> reset it
> after the reservation succeed. I am afraid extent alloc shouldn't use and
> change it?
Yes, It's a mistake. It seems I would better not merge those two functions.

> I am also curious about one thing. Have you written the test script for
> it to see whether it works?
> You can take ocfs2-tests/programs/inode_stealing/inode_stealing.sh for
> reference.
thanks for your advice. I will make a similar test for extent block 
stealing patches.

Thanks,
tiger
