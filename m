From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Wed Mar  3 10:57:31 2004
Subject: [Ocfs2-devel] Updated Patch for 2.6 Make system
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A6178046@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> > Makes sense.  Though would it make sense to distribute your 
> generated
> > configure script in the future?  I thought the purpose of 
> configure was
> > that you could use it to create a configure script that is 
> distributed
> > in the tarball and the people don't need to have autoconf 
> on their end.
> > This way we wouldn't have to worry about which version of 
> autoconf is on
> > a system.
> 
> That's true for released tarballs, but not for svn checkouts. It's not
> really proper to have generated files in source control, 
> since different
> installations can produce different output, which leads to 
> merge confusion.

I agree but you should NOT have to support older versions of autoconf
because when you generate the tarball you will create the configure
script for them.

But if the goal is to support AS 2.1 in the mode where they can check
the code out and run autoconf then you would need to support the older
versions.  And I suppose if you are doing your development on AS 2.1
then you would probably want that.

> > What is "makebo philosophy"?  I'm not familiar with that but I am
> > somewhat new to autoconf and automake.
> 
> makebo what we're using instead of automake. 
> 
> http://oss.oracle.com/projects/makebo/ (yes, the project info is
spartan)

> makebo is intended to be an automake/libtool replacement, since the
many
> of the latters' design decisions result in a system that's more
complex
> than it has to be.

Thanks I will take a look at that :)

>> > What I'd like to see is having one Makefile that does 
>> > everything, with the
>> > defines, cflags, and object files defined only once. Keeping 
>> > this in sync
>> > across multiple files is a maintainence headache.
>> 
>> I agree.  I did it this way to minimize the impact to the current
>> Makefile system and figured we could work on integrating them in the
>> future.  I still need to figure out if there is a better way of doing
>> the build for the 2.6.x. kernel so that it isn't as convulted.
>
>Well, reexecing make against the kernel's build stuff is the right
>approach I think. Use of the "export" directive in GNU make might be
>useful.

Okay.  I will try to integrate the stuff in.  The only hard part I had
before is that when the Kernel includes the makefile I can NOT figure
out where I am so I had a hard time including Config.make,
Pre/post-amble.make.  If I can figure that out then it can work but
otherwise I'm not sure how to do it.

John
