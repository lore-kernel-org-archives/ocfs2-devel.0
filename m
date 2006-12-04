From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec  4 16:10:12 2006
Subject: [Ocfs2-devel] Re: What's in ocfs2.git
In-Reply-To: <1165229693.3752.629.camel@quoit.chygwyn.com>
References: <20061203203149.GC19617@ca-server1.us.oracle.com>
	<1165229693.3752.629.camel@quoit.chygwyn.com>
Message-ID: <20061205001007.GF19617@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Whitehouse <steve@chygwyn.com>
Cc: Valerie Henson <val_henson@linux.intel.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Steve,

On Mon, Dec 04, 2006 at 10:54:53AM +0000, Steven Whitehouse wrote:
> > In the future, I'd like to see a "relative atime" mode, which functions
> > in the manner described by Valerie Henson at:
> > 
> > http://lkml.org/lkml/2006/8/25/380
> > 
> I'd like to second that. [adding Val Henson to the "to"] What (if
> anything) remains to be done before the relative atime patch is ready to
> go upstream? I'm happy to help out here if required,
Last time I looked at them, things seemed to be in pretty good shape - it
wasn't a very large patch series.

The thing is (I'm going from memory here), gfs2 and ocfs2 are likely to just
make use of the option parsing (and setting of the MNT_RELATIME flag), and
ignore the changes to touch_atime() since we we handle our own atime
updates.

Overall I think it's a matter of pushing the patches to the kernel and to
mount(8). For ocfs2/gfs2 we implement a small amount of the logic in our
"lock and update atime" functions.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
