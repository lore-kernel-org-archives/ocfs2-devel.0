From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 29 17:06:15 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <20040329223754.GA15877@penguin.co.intel.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
	<20040326143454.GG18020@ca-server1.us.oracle.com>
	<20040326204638.GA7147@penguin.co.intel.com>
	<20040329212947.GW10672@ca-server1.us.oracle.com>
	<20040329213158.GA12840@penguin.co.intel.com>
	<20040329223754.GA15877@penguin.co.intel.com>
Message-ID: <20040329230609.GY10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 29, 2004 at 02:37:54PM -0800, Rusty Lynch wrote:
> ah... first of all, s/I should be inline/It should be inlined/
> hey, it's not like englihs is first (and only) language or anything :->
heh, i dont' now wat your taking abuot

> The only thing left in __ocfs_read_super that requires #if LINUX.../#endif's
> is the ocfs_iget/iget4 stuff, which is one of those areas that I have been meaning
> to deal with...  ocfs_iget() should be what get's called regardless of 2.4/2.6, 
> and then deal with 2.4 verses 2.6 specifics in that function instead of sprinkled
> over super/namei/hash.
> 
> You mind if I tackle this in the same patch, or do you want two patches?  (It's just
> that ocfs_iget needs to be fixed before __ocfs_read_super can be made clean.)
Actually, two patches please. I don't mind the extra over #ifdef, and it'll
give us time to run with the new read_super while you deal with the inode
stuff (which I'd like to test seperately anyway).

While we're on the topic of iget, here's a thought. Theoretically we don't
need iget4/iget5 anymore, as our inode numbers are no longer tied to 64 bit
disk offsets and instead are taken from iunique, which, as the name
indicates, gives you a unique inode number. We should be able to just always
use iget instead, which is much simpler.

Of course, eliminating the #ifdef ... iget4 #else ocfs_iget #endif stuff is
a step in a good direction. However, if you want to give moving to iget a
shot, I'd be more than happy to help out with at least the 2.4 side of
things (testing, etc)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
