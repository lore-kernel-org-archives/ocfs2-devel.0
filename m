From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 24 May 2011 00:00:55 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: change incorrect 'extern' keyword
 to 'static' in dlmfs
In-Reply-To: <1304668900-20573-1-git-send-email-sanbai@taobao.com>
References: <1304668900-20573-1-git-send-email-sanbai@taobao.com>
Message-ID: <20110524070054.GE24290@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 06, 2011 at 04:01:40PM +0800, Robin Dong wrote:
> Change function param_set_dlmfs_capabilities from 'extern' to 'static' since
> function param_get_dlmfs_capabilities is also 'static'.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

			http://www.jlbec.org/
			jlbec at evilplan.org
