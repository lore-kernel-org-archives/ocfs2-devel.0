From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Mar 12 17:40:07 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A617804B@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> Ok, I finally got a chance to sit down and check this one 
> out. So far so
> good, but a couple comments below:
> 
> > > The suggested new way of storing private data is to define a new
> > > struct that contains your private data and has an inode 
> imbedded inside.
> > > Then the private data can be reached from an inode by 
> doing a simple
> > > container_of on the inode.  This is possible by hooking into inode
> > > allocation/deallocation via the alloc_inode/destroy_inode 
> function 
> > > pointers in the super operations.
> > > 
> > > (See linux/Documentation/filesystems/port)
> Can we please somehow try to do the similar thing with our 2.4 code?
> Obviously it's slightly different, but allocating the inode 
> private data
> and in 2.4, putting it in inode->u->generic_ip is The Right 
> Thing (TM). 
> You can use a kmem_cache for both.
> 
> Also, please feel free to change our own "void * generic_ip" to an 
> "ocfs_inode *oin" as that's the only type of structure that 
> ever gets put
> there.

Rusty and I will try to work on doing this.  Probably won't get done
until Monday or Tuesday though.

> If you're so setup for 2.6 that testing on a 2.4 kernel is 
> difficult, I'd be
> happy to help out by testing on my 2.4 setup :)

I think we should be able to debug on a 2.4 system.

> I know earlier that I said we wanted to get rid of our 
> macros, but most of 
> these are one liners. Could you please just keep them in 
> macro form? Also,
> if we make things inline, I think we'd want to drop the 
> all-caps as that
> should be reserved for macros. Obviously, we break this rule 
> ourselves in
> many places, but much of that is old cruft which we are 
> slowly changing :)
> Speaking of which, i noticed that inode_data_is_oin should be 
> upper case as
> a macro, so feel free to change that too.


Just curious on why you would ever want to use macros over inline
functions?  I'll be honest and express my prejudice against macros right
here and now :)  Since the compiler will convert an inline function into
the exact same thing as a macro and you get type checking and
predicatable behavior with a inline function.

As Meyers says (
http://www.amazon.com/exec/obidos/tg/detail/-/0201924889/qid=1079134299/
sr=1-2/ref=pd_ka_2/002-2866874-3073608?v=glance&s=books ) it is good to
prefer const and inline to #define.

And some people think "macros are evil" :)
(http://www.parashift.com/c++-faq-lite/inline-functions.html#faq-9.5)

Ok.  I know macros aren't all that bad but for the ones Rusty did I kind
of thought the usage there wasn't bad.

Using macros sounds good if you want to use the __LINE__, __FILE__, and
etc stuff.

But I am sure Rusty and I will go whichever way the wind is blowing :)

John
