From: Tiger Yang <tiger.yang@oracle.com>
Date: Sat, 20 Feb 2010 17:26:59 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-1.4: add extent block stealing
In-Reply-To: <4B7F8DC1.4030107@oracle.com>
References: <12666493991177-git-send-email-tiger.yang@oracle.com>
	<4B7F8DC1.4030107@oracle.com>
Message-ID: <4B7FAAE3.5070304@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Tao,

The big difference is in suballoc.c,  I modified 
ocfs2_reserve_new_metadata() in 1.4 but 
ocfs2_reserve_new_metadata_blocks() in 1.6.
And in 1.4,  no changes in dir.c, xattr.c and refcounttree.c.  Others 
they are the same.

regards,
tiger

Tao Ma wrote:
> Hi Tiger,
>     Could you please describe whether there is some difference between 
> 1.4 and the codes in the kernel. If none, I guess we can go through it 
> quickly. It seems so, but I just want to make sure. Thanks.
>
> Regards,
> Tao
