From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Mar  2 18:01:59 2004
Subject: [Ocfs2-devel] Updated Patch for 2.6 Make system
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A5698B@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> On Tue, Mar 02, 2004 at 02:29:27PM -0800, John L. Villalovos wrote:
> > Fixes an error from the previous patch where I forgot to do NPTL :(
> > 
> > This now compiles with SVN revision 748.
> 
> I just committed a modified version of the configure.in and 
> Config.make.in
> changes.

Sounds good.

> I got rid of the _'s. configure's never use _ in switches. 
> Also, we can't
> use AC_HELP_STRING since we still need to support AS 2.1, 
> which ships with
> ancient autoconf 2.13.

Makes sense.  Though would it make sense to distribute your generated
configure script in the future?  I thought the purpose of configure was
that you could use it to create a configure script that is distributed
in the tarball and the people don't need to have autoconf on their end.
This way we wouldn't have to worry about which version of autoconf is on
a system.

> > @@ -314,4 +331,5 @@
> >  vendor/unitedlinux/ocfs2-2.4.21-107.spec
> >  vendor/unitedlinux/ocfs2-2.4.21-111.spec
> >  vendor/unitedlinux/ocfs2-2.4.21-138.spec
> > +src/Makefile-2.6
> 
> In makebo philosophy, Makefiles should never be generated 
> from .in's. You
> should be able to include Config.make for what you need.

What is "makebo philosophy"?  I'm not familiar with that but I am
somewhat new to autoconf and automake.

From reading the documentation on autoconf and automake it appears that
a lot of times they use a template file to create a makefile.  Usually
it is Makefile.am though.

> What I'd like to see is having one Makefile that does 
> everything, with the
> defines, cflags, and object files defined only once. Keeping 
> this in sync
> across multiple files is a maintainence headache.

I agree.  I did it this way to minimize the impact to the current
Makefile system and figured we could work on integrating them in the
future.  I still need to figure out if there is a better way of doing
the build for the 2.6.x. kernel so that it isn't as convulted.

John
