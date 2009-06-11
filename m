From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 11 Jun 2009 08:43:49 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Prevent mount with "-o acl" if acl
	isn't	supported.
In-Reply-To: <1244667835-16907-1-git-send-email-tao.ma@oracle.com>
References: <1244667835-16907-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090611154349.GD11636@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 11, 2009 at 05:03:55AM +0800, Tao Ma wrote:
> Currently, if we don't enable CONFIG_OCFS2_FS_POSIX_ACL, ocfs2
> will not support acl. That is OK.
> 
> But in the following case:
> 1. kernel isn't built to support acl.
> 2. mount -t ocfs2 -o acl /dev/sdx /mnt/ocfs2.
> It sucesses. And what's more, if I do "mount|grep sdx" will get
> /dev/sdx on /mnt/ocfs2 type ocfs2 (rw,acl,heartbeat=none)
> 
> So a normal user will just think acl now is ok for the volume and
> he will surely be puzzled when he tries setfacl and fails with
> "Operation not supported".
> 
> The good thing is that the kernel already printk some useful
> information, so this patch just tries to prevent the user from
> mounting the volume.

	Hmm, everyone else seems to do it the way we have been.  Trying
to think about the surprise you describe vs the surprise of ocfs2 being
different than other linux filesystms.

Joel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
