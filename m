From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 24 21:07:58 2004
Subject: [Ocfs2-devel] Re: [CRASH]Oops in journal_wip on first mount
In-Reply-To: <20040324020542.GA13748@penguin.co.intel.com>
References: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
	<20040324015530.GD10672@ca-server1.us.oracle.com>
	<20040324020542.GA13748@penguin.co.intel.com>
Message-ID: <20040325030753.GL10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2004 at 06:05:42PM -0800, Rusty Lynch wrote:
> [root@nobody root]# mkfs -t ocfs2 -F -b 128 -g 0 -u 0 -L ocfs2 -m /oracle -p 775 /dev/sdb2
> Cleared volume header sectors
> Cleared node config sectors
> Cleared publish sectors
> Cleared vote sectors
> Cleared bitmap sectors
> Cleared data block
> Wrote volume header
> [root@nobody root]# tuneocfs -c 2 /dev/sdb2 Proceed (y/N): y
> Changes written to disk.
Whoa... just noticed this... If you make an ocfs2 file system (as opposed to
an "ocfs" file system), then you needn't run tuneocfs... in fact, tuneocfs
should fail on you... Now to see why it isn't :)

Ok, I do an mkfs.ocfs2 and then run tuneocfs -c 2 on the resulting file
system and i get:
(2314) ERROR: Version number not compatible: 2.0, Common/ocfsgenmisc.c, 811
(2314) ERROR: Device (0,3) failed verification, Linux/ocfsmount.c, 232
failed to mount

so, uhm, am I misunderstanding what that mount command is doing? :)
Anyway, this prolly doesn't explain the issue with journal_wipe.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
