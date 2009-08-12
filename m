From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 12 Aug 2009 09:40:41 +0800
Subject: [Ocfs2-devel] Why do we read the blocks in
	__ocfs2_xxattr_set_value_outside()?
In-Reply-To: <20090811220915.GF28478@mail.oracle.com>
References: <20090811220915.GF28478@mail.oracle.com>
Message-ID: <4A821D99.8030102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> 	In __ocfs2_xattr_set_value_outside(), we walk each block of the
> xattr value and read it before we copy the new data on top and dirty it.
> Why are we reading the block from disk if we're just overwriting it?
> Would't "sb_getblk(); ocfs2_set_buffer_uptodate()" work better?
You made it. yeah, we can do like it.

I remembered that when I first try sb_getblk, I used 
ocfs2_set_new_buffer_uptodate and get a BUG_ON(sorry for it, at the time 
I wrote this piece of code, I don't know much about ocfs2 buffer cache :( ).

Regards,
Tao
