From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 17:51:43 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2_dlmfs: User DLM_* when decoding
	file open flags.
In-Reply-To: <1269926491-11646-1-git-send-email-tao.ma@oracle.com>
References: <1269926491-11646-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100401005143.GC28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 30, 2010 at 01:21:31PM +0800, Tao Ma wrote:
> In commit 0016eedc4185a3cd7e578b027a6e69001b85d6c4, we have
> changed dlmfs to use stackglue. So when use DLM* when we
> decode dlm flags from open level.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"In the beginning, the universe was created. This has made a lot 
 of people very angry, and is generally considered to have been a 
 bad move."
        - Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
