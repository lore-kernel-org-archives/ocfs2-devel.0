From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 23 May 2011 23:56:32 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: clean up mount option about
 atime in ocfs2.txt
In-Reply-To: <1299065529-6626-1-git-send-email-tiger.yang@oracle.com>
References: <4D6E2994.1050302@oracle.com>
	<1299065529-6626-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20110524065632.GB24290@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 02, 2011 at 07:32:09PM +0800, Tiger Yang wrote:
> As ocfs2 supports relatime and strictatime, we need update the
> relative document. Atime_quantum need work with strictatime, so only
> show it in procfs when mount with strictatime.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

			http://www.jlbec.org/
			jlbec at evilplan.org
