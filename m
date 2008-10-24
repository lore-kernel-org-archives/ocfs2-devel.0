From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 18:16:37 -0700
Subject: [Ocfs2-devel] xattr fixes branch
In-Reply-To: <49011D7C.4080307@oracle.com>
References: <20081024002246.GF12751@mail.oracle.com>
	<49011D7C.4080307@oracle.com>
Message-ID: <20081024011637.GI12751@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 24, 2008 at 08:57:32AM +0800, Tao Ma wrote:
> Joel Becker wrote:
> > Folks,
> > 	To keep track of what we want to upstream in the 2.6.28-rc
> > cycle, I've put together a branch called 'xattr-28' with almost all of
> > the patches merged.  You can see it and pull it from my linux-2.6.git
> > repository.
> Thanks for that. So I can base my work on your branch for my future work.

	Yes.  What I put there will go to Mark as-is.  But the only
thing I'm planning to add to xattr-28 is the hash collision fix.  On top
of that we'll start our .29 work, which includes my read-metadata
branch, the xattr_set patch, some other xattr cleanups I'm doing, the
ACL code, and much much more :-)

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
