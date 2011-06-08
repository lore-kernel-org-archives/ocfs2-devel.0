From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 7 Jun 2011 23:41:32 -0700
Subject: [Ocfs2-devel] Do filesystem need to turn RO on dx corruptions?
In-Reply-To: <BANLkTikh_cV_AHYR-nDJC_V5zzt8AEnGvA@mail.gmail.com>
References: <BANLkTikh_cV_AHYR-nDJC_V5zzt8AEnGvA@mail.gmail.com>
Message-ID: <20110608064132.GB12846@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 07, 2011 at 10:41:42AM -0500, Goldwyn Rodrigues wrote:
> There have been index tree corruptions, where the directory entries
> are correct however the index directory is not. In this case, the
> filesystem turns read-only where as all the information to complete
> the operation is still available because the primary directory
> structure is sane. The ocfs2 module could just disable indexed
> directory for this directory and continue handling the operation like
> the normal directories without indexes. Of course, it still writes the
> warning message, to run fsck, to the kernel log  but avoid the RO
> filesystem which halt all I/O writes.

Goldwyn,
	You're correct, this is a more graceful solution.  We've just
never gotten around to it.

Joel

-- 

"Behind every successful man there's a lot of unsuccessful years."
        - Bob Brown

			http://www.jlbec.org/
			jlbec at evilplan.org
