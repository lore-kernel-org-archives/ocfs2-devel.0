From: Manish Singh <manish.singh@oracle.com>
Date: Wed Mar  3 17:15:13 2004
Subject: [Ocfs2-devel] Updated Patch for 2.6 Make system
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A6178046@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A6178046@orsmsx403.jf.intel.com>
Message-ID: <20040303231509.GD22645@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 03, 2004 at 08:54:23AM -0800, Villalovos, John L wrote:
> > > Makes sense.  Though would it make sense to distribute your 
> > generated
> > > configure script in the future?  I thought the purpose of 
> > configure was
> > > that you could use it to create a configure script that is 
> > distributed
> > > in the tarball and the people don't need to have autoconf 
> > on their end.
> > > This way we wouldn't have to worry about which version of 
> > autoconf is on
> > > a system.
> > 
> > That's true for released tarballs, but not for svn checkouts. It's not
> > really proper to have generated files in source control, 
> > since different
> > installations can produce different output, which leads to 
> > merge confusion.
> 
> I agree but you should NOT have to support older versions of autoconf
> because when you generate the tarball you will create the configure
> script for them.

That's what I meant with "That's true for released tarballs".

> But if the goal is to support AS 2.1 in the mode where they can check
> the code out and run autoconf then you would need to support the older
> versions.  And I suppose if you are doing your development on AS 2.1
> then you would probably want that.

That's precisely the goal.

-Manish
