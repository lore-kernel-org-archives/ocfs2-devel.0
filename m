From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Dec 2009 21:11:08 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: explicit declare uninitialized var
 in user_cluster_connect()
In-Reply-To: <4B17FD3B.1050503@suse.de>
References: <4B17FD3B.1050503@suse.de>
Message-ID: <20091218051108.GC20149@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 04, 2009 at 02:02:35AM +0800, Coly Li wrote:
> This patch explicitly declares an uninitialized local variable in user_cluster_connect(), to remove a compiling warning.

	This is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
