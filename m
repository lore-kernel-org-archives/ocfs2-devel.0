From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed Jul  6 13:51:17 2005
Subject: [Ocfs2-devel] 256 node limit
In-Reply-To: <20050706180418.GA21089@ca-server1.us.oracle.com>
References: <200507011649.j61GnMlY022352@oss.oracle.com>
	<20050701170449.GG26608@marowsky-bree.de>
	<42C5899E.2000209@oracle.com>
	<11fa5cce05070116517b7339b5@mail.gmail.com>
	<42CB1689.8040800@oracle.com>
	<11fa5cce050706103855a0470f@mail.gmail.com>
	<20050706180418.GA21089@ca-server1.us.oracle.com>
Message-ID: <20050706185117.GA20310@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Be careful here.  In many structures you will find a node number is
represented by a single u8.  Changing the maximum by modifying
O2NM_MAX_NODES will not affect this storage size.  

If you do make the change in the dlm, you will have to:

  1) seek out all of these single-byte values and change them to
     whatever is appropriate for your new upper bound.  For instance,
     if you choose 65535 as the new max, a u16 will suffice.

  2) make sure to reserve one value at the top of your new (unsigned)
     upper bound.  From the example above, a u16 ranges from 
     0 - 65536, so use 65535 as your new O2NM_MAX_NODES.  This is needed
     for such things as DLM_LOCK_RES_OWNER_UNKNOWN, an unknown nodenum.

  3) properly pad all of your new structs to 64 bit boundaries.

  4) for network structures, modify each of the _to_net and _to_host
     byteordering functions for the new u16.  You will notice that many
     of these functions are empty because they consist only of u8 values
     currently, but they must now be implemented.

  5) change any functions which take a u8 as a parameter.  Fortunately,
     in most cases we're already using a u8, so I think (with
     appropriate gcc pedantic-ness) you can catch those at compile time.

  6) watch out for the dlm_node_iter structure.  These are almost always
     stack-allocated.  At 256 nodes, the node_map portion of these are
     32 bytes wide.  If you do actually bump this to something huge
     (like the example above, 65535), that would be 8k!  So don't just
     go arbitrarily large, or find another way to implement the
     dlm_node_iter functionality.  Keep in mind, the reason for the
     structure we're using is to avoid having to kmalloc in different
     types of ugly codepaths (under spinlock, -ENOMEM too difficult to
     deal with, etc.), so keep an eye out for that.  If you pick 300,
     like you were saying, the size will only go to 38 bytes, up 6 from 
     the current size.

To make a long story even longer, what you're asking for is definitely
do-able and probably even desirable but also painful.  In the dlm
source, *most* of the u8 values in the headers are node numbers, so look
for anything along the lines of "_to", "_from", "_node", "_master", 
"_idx", etc. 

Keep in mind, if you don't make these changes and just bump up the
constant, your node numbers above 255 will likely silently wrap and you
will hit corruptions somewhere down the line.

Thanks!
-kurt



On Wed, Jul 06, 2005 at 11:04:19AM -0700, Wim Coekaerts wrote:
> it would be entertaining to see how it even works... but uhm go ahead.
> would be a good test we sure don't have the hardware to do that
> 
> On Wed, Jul 06, 2005 at 10:38:42AM -0700, Bruce Schwartz wrote:
> > Thanks. From looking at the code it appears that the maximum number of nodes 
> > are controlled by some #defines (OCFS2_NODE_MAP_MAX_NODES, O2NM_MAX_NODES) 
> > and that bumping the number up to something like 300 should be a simple 
> > matter. There is a note in the code that reads: "if we need more, we can do 
> > a kmalloc for the map" which I would guess addresses the case where you'd 
> > want thousands of nodes.
> > 
> > Is my reading correct? And would it be a bad idea to try to set up a 300+ 
> > node OCFS2 system?
> > 
> > Thanks,
> > Bruce
> > 
> > On 7/5/05, Sunil Mushran <Sunil.Mushran@oracle.com> wrote:
> > > 
> > > It's actually 255. Yes, that doc needs to be updated.
> > > 
> > > No, the algorithms did not play much role in setting this limit.
> > > Guess, can say the limit is part arbitrary, part practical.
> > > (That extra byte adds up pretty quickly.)
> > > 
> > > Bruce Schwartz wrote:
> > > 
> > > > Hi all --
> > > >
> > > > In the "what's new in OCFS2" document at
> > > > 
> > > http://oss.oracle.com/projects/ocfs2/dist/documentation/ocfs2-whats-new.txt
> > > > it says that the 256 node limit is a software limit and could be
> > > > lifted. Why is that limit there? Are there some algorithms that
> > > > don't scale nicely with larger number of nodes? I'm guessing that
> > > > there is more to it than saving a byte of RAM in a few data structures.
> > > >
> > > > Thanks,
> > > > Bruce
> > > >
> > > >------------------------------------------------------------------------
> > > >
> > > >_______________________________________________
> > > >Ocfs2-devel mailing list
> > > >Ocfs2-devel@oss.oracle.com
> > > >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> > > >
> > > >
> > >
> 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
