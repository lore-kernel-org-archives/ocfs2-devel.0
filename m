From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar 10 20:32:47 2004
Subject: [Ocfs2-devel] Converting some macros to inline functions
In-Reply-To: <20040311022650.GD30591@ca2.us.oracle.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A569F5@orsmsx403.jf.intel.com>
	<20040311021339.GA29616@ca-server1.us.oracle.com>
	<20040311022650.GD30591@ca2.us.oracle.com>
Message-ID: <20040311023239.GA24868@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 10, 2004 at 06:26:50PM -0800, Kurt Hackel wrote:
> heh.  yeah good idea.  the only ones we might turn down would be those
> that we really need to be macros for debugging purposes (need to be able
> to get at stuff like __FILE__ and __LINE__ of the calling func).
> there shouldn't be too many that need that tho, so we'll likely approve
> most of them.
> -k
> 

I have a patch that I am working on that fixes the 2.6 use of inode's union
for private data that moves a bunch of macros to inline functions.  Hopefully
I'll have it working real soon.

    --rusty

> On Wed, Mar 10, 2004 at 06:13:39PM -0800, Mark Fasheh wrote:
> > On Wed, Mar 10, 2004 at 06:03:46PM -0800, Villalovos, John L wrote:
> > > If I were to submit some patches that converted some of the macros to
> > > inline functions would it be accepted?
> > > 
> > > I just prefer to have actual functions so that we get more type
> > > checking.  Plus it gives me a chance to learn more about the code as I
> > > do it.
> > > 
> > > Any comments?
> > 
> > John,
> > 	That's the worst idea I've ever heard.
> > 
> > Just kidding. We've been meaning to do that for a while actually :)
> > So go ahead, we'd definitely be interested in those patches!
> > 	--Mark
> > 
> > --
> > Mark Fasheh
> > Software Developer, Oracle Corp
> > mark.fasheh@oracle.com
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
