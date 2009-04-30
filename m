From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Apr 2009 15:57:35 -0700
Subject: [Ocfs2-devel] orphan cleanup
In-Reply-To: <49FA2994.2080803@oracle.com>
References: <20090430185346.GE2762@mail.oracle.com>
	<49F9FA82.3020201@oracle.com> <49FA2994.2080803@oracle.com>
Message-ID: <20090430225735.GH2762@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 03:43:32PM -0700, Srinivas Eeda wrote:
> hmm, even if we queue the orphan recovery, inode may not get cleaned if 
> the inode is still around on some node right? The node where the inode 
> is still cached will vote "no" again?

	Yes.

Joel

-- 

Life's Little Instruction Book #456

	"Send your loved one flowers.  Think of a reason later."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
