From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Mar 19 17:59:00 2004
Subject: [Ocfs2-devel] Bug in ocfs_file_entry struct for 2.6
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0E3E08@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0E3E08@orsmsx410.jf.intel.com>
Message-ID: <20040319235852.GA22829@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2004 at 03:15:11PM -0800, Villalovos, John L wrote:
> I was looking at the ocfs_file_entry struct in inc/ocfs.h
> 
> I noticed that it defines:
> 
>     __u16 dev_major;                  // NUMBER RANGE(0,65535)
>     __u16 dev_minor;                  // NUMBER RANGE(0,65535)
> 
> So dev_major is not going to have a problem because they use 12 bits to
> hold the major number.
> 
> But the dev_minor entry will be a problem because they use 20 bits to
> hold the minor number in the 2.6.x kernel.
> 
> >From a quick look at the code I'm not sure that this is an easy fix.  It
> doesn't look like we can just change the structure (unless they have
> __u20 and __u12 type variables??).  I'm saying that it doesn't look like
> an easy fix because I think that this structure is put as is on the
> disk, but maybe I am mistaken.
Yeah, that's a bug. The quick consensus 'round here is that nobody uses
char/block devices on ocfs at the moment, so it's ok to just mash those two
__u16's together as a __u32 (preferably in the code which requres it) and
just treat it as such (un-mashing them when we need to put it back into the
fe). As long as the behavior is documented, I think we're OK.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
