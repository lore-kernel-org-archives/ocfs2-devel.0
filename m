From: Manish Singh <manish.singh@oracle.com>
Date: Tue Mar  2 19:51:16 2004
Subject: [Ocfs2-devel] Updated Patch for 2.6 Make system
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A5698B@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A5698B@orsmsx403.jf.intel.com>
Message-ID: <20040303015112.GA5581@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2004 at 04:01:33PM -0800, Villalovos, John L wrote:
> > On Tue, Mar 02, 2004 at 02:29:27PM -0800, John L. Villalovos wrote:
> > I got rid of the _'s. configure's never use _ in switches. 
> > Also, we can't
> > use AC_HELP_STRING since we still need to support AS 2.1, 
> > which ships with
> > ancient autoconf 2.13.
> 
> Makes sense.  Though would it make sense to distribute your generated
> configure script in the future?  I thought the purpose of configure was
> that you could use it to create a configure script that is distributed
> in the tarball and the people don't need to have autoconf on their end.
> This way we wouldn't have to worry about which version of autoconf is on
> a system.

That's true for released tarballs, but not for svn checkouts. It's not
really proper to have generated files in source control, since different
installations can produce different output, which leads to merge confusion.
 
> > > @@ -314,4 +331,5 @@
> > >  vendor/unitedlinux/ocfs2-2.4.21-107.spec
> > >  vendor/unitedlinux/ocfs2-2.4.21-111.spec
> > >  vendor/unitedlinux/ocfs2-2.4.21-138.spec
> > > +src/Makefile-2.6
> > 
> > In makebo philosophy, Makefiles should never be generated 
> > from .in's. You
> > should be able to include Config.make for what you need.
> 
> What is "makebo philosophy"?  I'm not familiar with that but I am
> somewhat new to autoconf and automake.

makebo what we're using instead of automake. 

http://oss.oracle.com/projects/makebo/ (yes, the project info is spartan)

makebo is intended to be an automake/libtool replacement, since the many
of the latters' design decisions result in a system that's more complex
than it has to be.

> From reading the documentation on autoconf and automake it appears that
> a lot of times they use a template file to create a makefile.  Usually
> it is Makefile.am though.

Yeah, that's what automake does. I don't like that, since it makes
configure take an age, and results in hugely bloated Makefiles. include
is much nicer.

> > What I'd like to see is having one Makefile that does 
> > everything, with the
> > defines, cflags, and object files defined only once. Keeping 
> > this in sync
> > across multiple files is a maintainence headache.
> 
> I agree.  I did it this way to minimize the impact to the current
> Makefile system and figured we could work on integrating them in the
> future.  I still need to figure out if there is a better way of doing
> the build for the 2.6.x. kernel so that it isn't as convulted.

Well, reexecing make against the kernel's build stuff is the right
approach I think. Use of the "export" directive in GNU make might be
useful.

-Manish
