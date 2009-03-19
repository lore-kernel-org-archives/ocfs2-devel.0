From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Mar 2009 15:06:37 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix 2 warning during ocfs2 make.
In-Reply-To: <49C1EA90.6090201@oracle.com>
References: <1237410523-8639-1-git-send-email-tao.ma@oracle.com>
	<49C1E605.5030801@oracle.com> <49C1E968.9070103@oracle.com>
	<49C1EA90.6090201@oracle.com>
Message-ID: <20090319220637.GA18943@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 19, 2009 at 02:47:44PM +0800, Wengang Wang wrote:
> yes, that's the problem.
> we'd better unify the different types(but could be another patch).
> since the on disk is u16, modifying other types to u16 is fine :)

	The -1 is a special value, and it isn't always a u16 we're
talking about.  This is both historical code and on-disk values.
INVALID_SLOT isn't 65535, it's -1.  You have to have the comparisons as
they currently stand, with the casts.

Joel

-- 

"Any man who is under 30, and is not a liberal, has not heart;
 and any man who is over 30, and is not a conservative, has no brains."
         - Sir Winston Churchill 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
