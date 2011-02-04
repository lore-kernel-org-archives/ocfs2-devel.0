From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 4 Feb 2011 09:58:01 -0800
Subject: [Ocfs2-devel] [PATCH] [ocfs2] Use a kobject instead of a kset
In-Reply-To: <1296837627-7416-1-git-send-email-dann.frazier@canonical.com>
References: <1296837627-7416-1-git-send-email-dann.frazier@canonical.com>
Message-ID: <20110204175751.GA21472@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dann.frazier@canonical.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:40:27AM -0700, dann.frazier at canonical.com wrote:
> From: dann frazier <dann.frazier@canonical.com>
> 
> We currently allocate a kset and add attributes to its internal kobject.
> However, Documentation/kobject.txt says only the kset code should manipulate
> this internal object, and we can get the same results by just creating our
> own kobject and avoiding a kset altogether.

	Hmm, is this actually valid?  I thought you had to be a kset to
have children.  Did this change at some point?

Joel

-- 

"Soap and education are not as sudden as a massacre, but they are more
 deadly in the long run."
	- Mark Twain


			http://www.jlbec.org/
			jlbec at evilplan.org
