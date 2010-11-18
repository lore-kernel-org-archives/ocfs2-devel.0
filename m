From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Nov 2010 15:42:41 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix memory leak
In-Reply-To: <1289034412-24278-4-git-send-email-jslaby@suse.cz>
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
	<1289034412-24278-4-git-send-email-jslaby@suse.cz>
Message-ID: <20101118234241.GI19821@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sat, Nov 06, 2010 at 10:06:52AM +0100, Jiri Slaby wrote:
> Stanse found that o2hb_heartbeat_group_make_item leaks some memory on
> fail paths. Fix the paths by adding a new label and jump there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: ocfs2-devel at oss.oracle.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel at vger.kernel.org

	This patch is now in the fixes branch of ocfs2.git.

Joel


-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
