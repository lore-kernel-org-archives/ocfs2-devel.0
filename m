From: Cahill, Ben M <ben.m.cahill@intel.com>
Date: Tue Feb 17 08:50:57 2004
Subject: [Ocfs2-devel] Request to remove -Wfno-format
Message-ID: <0604335B7764D141945E20215310596002299B4C@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Code in OpenGFS does something similar, but with a smaller macro label:
FMT_64

It's just a little more compact than Rusty's suggestion.

-- Ben --

> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com 
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Rusty Lynch
> Sent: Friday, February 13, 2004 10:22 PM
> To: Mark Fasheh
> Cc: ocfs2-devel@oss.oracle.com
> Subject: Re: [Ocfs2-devel] Request to remove -Wfno-format
> 
> 
> On Fri, Feb 13, 2004 at 07:18:41PM -0800, Mark Fasheh wrote:
> > On Fri, Feb 13, 2004 at 07:09:40PM -0800, Rusty Lynch wrote:
> > > I have something here that instead of doing crazy cast, 
> with define a U64_MODIFIER
> > > that will expand appropriatly.  So... it's always correct 
> and much easier on the eyes.
> > > 
> > > printk's would look something like:
> > > 
> > > printk(KERN_DEBUG "size_t is %Zu, and a u64 is " 
> U64_MODIFIER "\n", asize, au64value);
> > > 
> > > Let me do one more verification on the patch and I will 
> send it out.
> > > 
> > >     --rusty
> > 
> > Have you seen how often we print out __u64's? I predict 
> that chopping up our
> > format strings with that will be much uglier than a cast macro ;)
> > 	--Mark
> > 
> 
> Take a look at the following and see if it's too much.
> 
>     --rusty
> 
> 
