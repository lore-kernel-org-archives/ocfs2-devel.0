From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Sat Mar 13 12:44:35 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
In-Reply-To: <20040313183959.GA16181@penguin.co.intel.com>
References: <200403110449.i2B4ncDw032388@penguin.co.intel.com>
	<20040311215300.GA7623@penguin.co.intel.com>
	<20040312204747.GA20057@ca-server1.us.oracle.com>
	<20040312210701.GA12754@penguin.co.intel.com>
	<20040313000913.GB20057@ca-server1.us.oracle.com>
	<20040313183959.GA16181@penguin.co.intel.com>
Message-ID: <20040313184429.GD1618@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

just the main distributions

rhel3 rhas21 suse sp3

and forward rhel4 sles9

nothing else planned really.


hope you get better soon !

On Sat, Mar 13, 2004 at 10:39:59AM -0800, Rusty Lynch wrote:
> On Fri, Mar 12, 2004 at 04:09:13PM -0800, Mark Fasheh wrote:
> > On Fri, Mar 12, 2004 at 01:07:01PM -0800, Rusty Lynch wrote:
> > > This is what I wanted to do, but I was attempting to leave no trail on the
> > > 2.4 code.  I am also running my changes on a 2.4 kernel, but not doing much 
> > > testing other then mounting a volume, unpackaging a bunch stuff, moving it
> > > around, ... and what ever else strikes me as significant.
> > That should work for a basic test, I'll put it through the rest of it's
> > paces :)
> >  
> > > I'll make another pass that makes the 2.4 and 2.6 code store the inode private
> > > data in the way suggested in 2.6.
> > Is it even possible to handle this in the way suggested in 2.6? It's a
> > slightly different mechanism for 2.4, right? For 2.4, what I was thinking
> > was along the lines of:
> > 
> 
> Ah... I had only looked at the source for one of the newer 2.4 kernels
> and noticed the addition of the allocation/destroy hooks in the 
> super_operations.  After seeing your response I dug a little deeper and
> found that this is a fairly new addition to 2.4, so it would not be possible
> to do since ocfs is required to support some older distribution releases 
> that probobly do not have the new hooks. 
> 
> (BTW, is there a quick reference handy for each of the kernel versions that
> ocfs2 needs to work on?  The oldest is probobly all that would be needed.)
> 
> > <near the top of ocfs_populate_inode, prolly after the fe sanity check>
> > 
> > if (!inode->u.generic_ip)
> > 	inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, 
> > 					       GFP_NOFS);
> 
> easy enough
> 
> > 
> > Of course, with proper error checking and whatnot.
> > Then in ocfs_clear_inode, we could just do:
> > 
> > ocfs_destroy_inode(inode);
> > inode->u.generic_ip = NULL;
> > 
> > Again, cleaned up and bugchecked and whatnot.
> > What do you think?
> >
> 
> there is no ocfs_destroy_inode()... but I get the picture.
> hmm... looking at all the places where we ocfs_release_oin(),
> I need to look a little deeper at exactly how we do cleanup.
> 
> I'm stuck at home all weekend sick as a dog and kicking myself
> for choosing the most sunny weekend of the year to get sick! :-<
> 
> I'm also bored out of my mind so I think I'll be hacking between
> hacking.  (ok, I can see where that wouldn't be all that funny 
> if you were not flying high on cough medication, but it was funny
> to me :->) 
> 
>  
> > > As to the use of upper case for MACROS... I agree.  I was just trying to sneak
> > > in some macro genocide without having to touch all the code that calls the
> > > macros.
> > Well, it's a good cause :)
> > 
> > > So just curious, when do you feel a macro is better then an inline function?
> > Umm, I have no strong opinions really. I think mostly my rule is if it's
> > only a line or two that doesn't necessarily require any typechecking, then a
> > macro is fine. Otherwise, an inline's the better choice.
> >  
> > > Either way I'll generate a patch that just does the minimal about to move the
> > > inode private data, and seperate the macro question to another patch (or series
> > > of patches.)
> > That'd be nice actually, rather than having more than one change in a patch
> > -- it's easier to review them that way.
> > 	--Mark
> > 
> > --
> > Mark Fasheh
> > Software Developer, Oracle Corp
> > mark.fasheh@oracle.com
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
