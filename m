From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 11 15:27:03 2006
Subject: [Ocfs2-devel] [patch 2/3]OCFS2: allow the ocfs2 heartbeat thread
	to prioritize I/O --revision 3
In-Reply-To: <20061211223801.GD6831@ca-server1.us.oracle.com>
References: <4579B3C00200000400262DB0@lucius.provo.novell.com>
	<20061211223801.GD6831@ca-server1.us.oracle.com>
Message-ID: <20061211232659.GE6831@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 11, 2006 at 02:38:01PM -0800, Mark Fasheh wrote:
> > +	run_hb_ctl (hb_ctl_path, mo.dev, "-P");
> Don't we need to add another argument for the actual priority value?
Never mind - I see that ocfs2_hb_ctl will just pick the default.

Ok, both userspace patches and the kernel patch are merged now. Thanks!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
