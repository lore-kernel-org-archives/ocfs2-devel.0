From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Fri May 28 13:55:22 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65ED6@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65ED6@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040528185510.GB8601@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Yes, there are a few more format changes, but they are very minor
compared to the changes already made.  In particular, there will be a
small change to a more flexible "system file" format, and another small
change in the disk header to account for (future) blocksize of greater
that 512 bytes.  These are quite small in comparison to the directory
structure changes, which are essentially done.  The tree should not get
radically destabilized over the next few weeks as a result, so moving
ahead with the current code should be fine.

Thanks!
-kurt

On Sat, May 29, 2004 at 02:32:29AM +0800, Zhang, Sonic wrote:
> Hi Mark,
> 
> 	Do you plan to add more format changes to the OCFS2 recently? 
> 
> 	We are now working on stabilize the OCFS2 on top of IPF and kernel 2.6. We hope we can get a stable release for kernel 2.4 and IA32. What's your plan?
> 
> 	Thanks.
> 
> 
> *********************************************
> Sonic Zhang
> Software Engineer
> Intel China Software Lab
> Tel: (086)021-52574545-1667
> iNet: 752-1667
> ********************************************* 
> 
> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
> Sent: 2004??5??26?? 18:16
> To: ocfs2-devel@oss.oracle.com
> Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
> 
> For the last couple of weeks we've been making some important format changes
> for OCFS2. We're not done yet, but much of it is in a state where we feel it
> can be merged back into trunk and played with. There are bugs, and there
> will be more disk format changes, but at least now others can pitch in.
> 
> You will absolutely have to reformat your filesystems after picking up this
> revision (946). The userspace tools aren't as ready for ocfs-tools trunk yet
> though, so you'll need to pick up the new-dir-format branch of ocfs-tools
> and use that to create ocfs2 file systems.
> 
> $ svn co http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-format/ ocfs-tools
> 
> Those of you who have read the ext3 code might find some of this new stuff
> familiar. This is because we've finally done away with our dirnode
> structures and gone to something a little less... broken :)
> 	--Mark
> 
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
