From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar  9 15:43:18 2004
Subject: [Ocfs2-devel] Bug in error handling
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A569E1@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A569E1@orsmsx403.jf.intel.com>
Message-ID: <20040309214314.GD19927@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 09, 2004 at 01:18:11PM -0800, Villalovos, John L wrote:
> It was NOT a 1st mount.  It was a disk that had been previously used.
> 
> It appears that the mount fails but then some globals are probably in a
> partially set state.
> 
> Here is what I saw after it happened:
> 
> # mount -t ocfs2 /dev/sda1 /ocfs2
> JBD: no valid journal superblock found
> (1856) ERROR: status = -22, /root/ocfs/ocfs2/src/osb.c, 424
> (1856) ERROR: status = -22, /root/ocfs/ocfs2/src/super.c, 1047
> mount: wrong fs type, bad option, bad superblock on /dev/sda1,
>        or too many mounted file systems
> [root@linuxjohn2 load_ocfs]# Unable to handle kernel NULL pointer
> dereference at virtual address 00000000
<snip>
Alright, we should definitely *not* be doing that :) I'll add your previous
patch and check it out.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
