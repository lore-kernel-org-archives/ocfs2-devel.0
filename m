From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Fri Feb 27 14:01:04 2004
Subject: [Ocfs2-devel] Patch for 2.6 support in configure
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A56961@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com 
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of 
> Villalovos, John L
> Sent: Friday, February 27, 2004 11:39 AM
> To: ocfs2-devel@oss.oracle.com
> Subject: [Ocfs2-devel] Patch for 2.6 support in configure
> 
> 
> This patch add support for using a 2.6.x kernel when running 
> configure.
> 
> It requires the user to use "--enable-kernel-2_6" to enable 
> it.  It also
> creates an OCFS_KERNEL_2_6 Makefile variable that is put into
> Config.make.in
> 
> I am working on using this information in the src/Makefile to add
> support for 2.6
> 

I'm working on getting a mail client that doesn't wrap text.  So sorry
about the wrapping.  I also attached the file as an attachment before so
you can use that too.
