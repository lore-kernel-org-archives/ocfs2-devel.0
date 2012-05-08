From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 7 May 2012 17:01:01 -0700
Subject: [Ocfs2-devel] ocfs2 discontiguous localalloc patches
In-Reply-To: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20120508000100.GB4713@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 07, 2012 at 04:21:27PM -0700, Srinivas Eeda wrote:
> can you please review following 3 patches that implement discontiguous
> localalloc bitmap support for ocfs2 file system. This feature helps
> applications that significantly fragment the filesystem.

	Hi Srini.  Have you some performance numbers backing this?  That
is, I believe that the described filesystem turned off local alloc.  Do
you have proof that these patches, turning it back on, improved the
customer's performance?

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

			http://www.jlbec.org/
			jlbec at evilplan.org
