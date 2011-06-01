From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 31 May 2011 19:24:06 -0700
Subject: [Ocfs2-devel] [patch] ocfs2: null deref on allocation error
In-Reply-To: <20110529195716.GD3099@shale.localdomain>
References: <20110529195716.GD3099@shale.localdomain>
Message-ID: <20110601022405.GC29741@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, May 29, 2011 at 10:57:16PM +0300, Dan Carpenter wrote:
> The original code had a null derefence in the error handling.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel


-- 

"The trouble with being punctual is that nobody's there to
 appreciate it."
	- Franklin P. Jones

			http://www.jlbec.org/
			jlbec at evilplan.org
