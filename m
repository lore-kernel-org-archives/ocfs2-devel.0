From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Mar 12 14:47:51 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
In-Reply-To: <20040311215300.GA7623@penguin.co.intel.com>
References: <200403110449.i2B4ncDw032388@penguin.co.intel.com>
	<20040311215300.GA7623@penguin.co.intel.com>
Message-ID: <20040312204747.GA20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, I finally got a chance to sit down and check this one out. So far so
good, but a couple comments below:

On Thu, Mar 11, 2004 at 01:53:00PM -0800, Rusty Lynch wrote:
<snip>
> > So... struct inode changed in 2.6 such that the union on the end of the
> > struct now only contains "void *generic_ip", and therefore only adds
> > on sizeof(void *) to the end of the structure.  Our 2.6 code is still
> > attempting to read/write private data at the end of the inode struct,
> > and therefore writing past the end of the object.
> > 
> > The suggested new way of storing private data is to define a new
> > struct that contains your private data and has an inode imbedded inside.
> > Then the private data can be reached from an inode by doing a simple
> > container_of on the inode.  This is possible by hooking into inode
> > allocation/deallocation via the alloc_inode/destroy_inode function 
> > pointers in the super operations.
> > 
> > (See linux/Documentation/filesystems/port)
Can we please somehow try to do the similar thing with our 2.4 code?
Obviously it's slightly different, but allocating the inode private data
and in 2.4, putting it in inode->u->generic_ip is The Right Thing (TM). 
You can use a kmem_cache for both.

Also, please feel free to change our own "void * generic_ip" to an 
"ocfs_inode *oin" as that's the only type of structure that ever gets put
there.

If you're so setup for 2.6 that testing on a 2.4 kernel is difficult, I'd be
happy to help out by testing on my 2.4 setup :)

> > 
> > The following patch does this and also takes the liberty to convert the 
> > macros for getting/setting private data into inline functions (mainly
> > because stared at OCFS_GENERIC_IP and friends for way to long before
> > I realized what they were actually doing, and why that was freezing my
> > 2.6 build.)
I know earlier that I said we wanted to get rid of our macros, but most of
these are one liners. Could you please just keep them in macro form? Also,
if we make things inline, I think we'd want to drop the all-caps as that
should be reserved for macros. Obviously, we break this rule ourselves in
many places, but much of that is old cruft which we are slowly changing :)
Speaking of which, i noticed that inode_data_is_oin should be upper case as
a macro, so feel free to change that too.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
