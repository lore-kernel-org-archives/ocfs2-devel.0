From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Jan 10 15:51:37 2008
Subject: [Ocfs2-devel] OCFS2-1.4 Yet another drop
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080110235027.GB12597@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 09, 2008 at 05:59:02PM -0800, Sunil Mushran wrote:
> Hopefully this is the last drop before we create the repos.
> 
> The big change in this drop is moving the kernel code to from kapi-include
> headers to compat-file.c

These look good to me.  I couldn't see where COMPAT_SOURCES got added to
DIST_FILES, but I see it in the git tree.  I assume you just didn't send
the Makefile patch?

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
